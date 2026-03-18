"""
Lesson API endpoints.
"""
from __future__ import annotations

import time
from datetime import datetime, timezone
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session

from api.models.db import get_db
from api.models.schemas import APIResponse, AnswerRequest, LessonCompleteRequest, LessonCompleteResponse, LessonSummary
from api.services.lesson_service import (
    create_or_reuse_next_lesson,
    generate_lesson_for_user,
    get_lesson_payload,
    get_lesson_timeline,
    invalidate_active_lessons,
)
from api.services.answer_service import record_answer, apply_deferred_srs, evaluate_mcq, evaluate_assembly
from api.services.progress_service import update_engagement_on_complete
from api.models.orm import LessonRecord, LessonStatus
from api.cache import get_cached_lesson

router = APIRouter(prefix="/lessons", tags=["lessons"])


@router.post("/create-next")
def create_next_lesson(
    user_id: str = Query(default="default_user"),
    seed: Optional[int] = Query(default=None),
    db: Session = Depends(get_db),
):
    """**Canonical progression endpoint** — create next lesson or reuse active.

    This is the single entry point for the learning pipeline.  The backend
    planner automatically decides the right mix of:
    - Due reviews (SRS backlog)
    - Reinforcement (weak words)
    - Controlled new word introduction
    - Occasional ayah practice

    When review pressure is high, new words are automatically throttled so
    the user addresses their backlog without needing a separate review mode.
    """
    if seed is None:
        seed = int(time.time()) % 100000
    lesson = create_or_reuse_next_lesson(db, user_id, seed)
    return APIResponse(ok=True, data=lesson)


@router.get("/timeline")
def lessons_timeline(
    user_id: str = Query(default="default_user"),
    limit: int = Query(default=20, ge=1, le=100),
    db: Session = Depends(get_db),
):
    return APIResponse(ok=True, data=get_lesson_timeline(db, user_id, limit=limit))


@router.get("/next")
def get_lesson_next(
    user_id: str = Query(default="default_user"),
    seed: Optional[int] = Query(default=None),
    db: Session = Depends(get_db),
):
    """Backward-compatible endpoint: force-generate a new lesson, invalidating active ones."""
    if seed is None:
        seed = int(time.time()) % 100000
    invalidate_active_lessons(db, user_id)
    lesson = generate_lesson_for_user(db, user_id, seed=seed)
    return APIResponse(ok=True, data=lesson)


@router.get("/today")
def get_lesson_today(
    user_id: str = Query(default="default_user"),
    seed: Optional[int] = Query(default=None),
    db: Session = Depends(get_db),
):
    """Deprecated alias for /lessons/next — kept for backward compatibility."""
    if seed is None:
        seed = int(time.time()) % 100000
    invalidate_active_lessons(db, user_id)
    lesson = generate_lesson_for_user(db, user_id, seed=seed)
    return APIResponse(ok=True, data=lesson)


@router.get("/{lesson_id}")
def get_lesson_by_id(
    lesson_id: str,
    user_id: str = Query(default="default_user"),
    db: Session = Depends(get_db),
):
    """Return the exact stored lesson instance from DB source-of-truth."""
    lesson = get_lesson_payload(db, lesson_id, user_id)
    if not lesson:
        raise HTTPException(
            status_code=404,
            detail={"code": "NOT_FOUND", "message": "Lesson not found"},
        )
    return APIResponse(ok=True, data=lesson)


@router.post("/{lesson_id}/answer")
def submit_answer(
    lesson_id: str,
    req: AnswerRequest,
    user_id: str = Query(default="default_user"),
    db: Session = Depends(get_db),
):
    """Submit an answer for a lesson step (deferred SRS — no progress update until completion)."""
    lesson_rec = db.query(LessonRecord).filter(
        LessonRecord.lesson_id == lesson_id,
        LessonRecord.user_id == user_id,
    ).first()
    if not lesson_rec:
        raise HTTPException(status_code=404, detail={"code": "NOT_FOUND", "message": "Lesson not found"})

    status = lesson_rec.status.value if isinstance(lesson_rec.status, LessonStatus) else lesson_rec.status
    if status == LessonStatus.completed.value:
        raise HTTPException(status_code=400, detail={"code": "LESSON_READ_ONLY", "message": "Completed lesson is read-only"})

    if status == LessonStatus.invalidated.value:
        raise HTTPException(status_code=400, detail={"code": "LESSON_INVALIDATED", "message": "Lesson was invalidated"})

    cached = get_cached_lesson(lesson_id)
    if cached is None and lesson_rec.lesson_payload:
        cached = lesson_rec.lesson_payload
    is_correct = False

    if cached and req.step_index < len(cached["steps"]):
        step = cached["steps"][req.step_index]
        step_type = step.get("type", "")

        if step_type in {"meaning_choice", "review_card", "reinforcement", "audio_to_meaning", "translation_to_word"}:
            correct_answer = step.get("correct", "")
            is_correct = evaluate_mcq(req.answer, correct_answer)
        elif step_type.startswith("ayah_build"):
            gold = step.get("gold_order_token_ids", [])
            is_correct = evaluate_assembly(req.answer, gold)
        else:
            is_correct = True
    else:
        is_correct = req.answer.get("is_correct", False)
        step = {}

    if req.step_type.startswith("ayah_build"):
        gold_ids = step.get("gold_order_token_ids", []) if step else []
        if not gold_ids:
            gold_ids = [tid for tid in (req.answer.get("ordered_token_ids") or []) if tid]

        if not gold_ids:
            raise HTTPException(
                status_code=400,
                detail={"code": "INVALID_STEP", "message": "No token_ids for ayah_build step"},
            )

        # Record per-token review events for SRS but do NOT inflate
        # lesson-level counters (one UI step = one pedagogical event).
        last_result = None
        for token_id in gold_ids:
            last_result = record_answer(
                db=db,
                user_id=user_id,
                lesson_id=lesson_id,
                step_index=req.step_index,
                step_type=req.step_type,
                token_id=token_id,
                is_correct=is_correct,
                telemetry=req.telemetry,
                update_lesson_counters=False,
            )

        # Increment lesson counters exactly once for the whole ayah step.
        lesson_rec.steps_answered += 1
        if is_correct:
            lesson_rec.correct_count += 1
        db.commit()

        result = last_result
        if result:
            result["step_index"] = req.step_index
            result["is_correct"] = is_correct
    else:
        result = record_answer(
            db=db,
            user_id=user_id,
            lesson_id=lesson_id,
            step_index=req.step_index,
            step_type=req.step_type,
            token_id=req.token_id,
            is_correct=is_correct,
            telemetry=req.telemetry,
        )

    if status == LessonStatus.generated.value:
        lesson_rec.status = LessonStatus.in_progress
        db.commit()

    return APIResponse(ok=True, data=result)


@router.post("/{lesson_id}/complete")
def complete_lesson(
    lesson_id: str,
    req: LessonCompleteRequest = LessonCompleteRequest(),
    user_id: str = Query(default="default_user"),
    db: Session = Depends(get_db),
):
    """Mark a lesson as completed and apply all deferred SRS updates atomically."""
    lesson_rec = db.query(LessonRecord).filter(
        LessonRecord.lesson_id == lesson_id,
        LessonRecord.user_id == user_id,
    ).first()

    if not lesson_rec:
        raise HTTPException(status_code=404, detail={"code": "NOT_FOUND", "message": "Lesson not found"})

    status = lesson_rec.status.value if isinstance(lesson_rec.status, LessonStatus) else lesson_rec.status
    if status == LessonStatus.completed.value:
        raise HTTPException(status_code=400, detail={"code": "LESSON_READ_ONLY", "message": "Already completed"})

    if status == LessonStatus.invalidated.value:
        raise HTTPException(status_code=400, detail={"code": "LESSON_INVALIDATED", "message": "Lesson was invalidated"})

    # Guard: lesson cannot be completed unless all pedagogical steps are answered.
    if lesson_rec.steps_answered < lesson_rec.total_steps:
        raise HTTPException(
            status_code=400,
            detail={
                "code": "LESSON_INCOMPLETE",
                "message": (
                    f"Cannot complete lesson: {lesson_rec.steps_answered}/{lesson_rec.total_steps} steps answered"
                ),
            },
        )

    lesson_rec.status = LessonStatus.completed
    lesson_rec.is_completed = True
    lesson_rec.is_invalidated = False
    lesson_rec.completed_at = datetime.now(timezone.utc)
    db.commit()

    apply_deferred_srs(db, user_id, lesson_id)
    update_engagement_on_complete(db, user_id)

    accuracy = lesson_rec.correct_count / max(1, lesson_rec.steps_answered)

    cached = get_cached_lesson(lesson_id) or lesson_rec.lesson_payload or {}
    ayah_tasks_done = sum(
        1 for s in cached.get("steps", [])
        if s.get("type", "").startswith("ayah_build")
    )

    summary = LessonSummary(
        lesson_id=lesson_id,
        steps_done=lesson_rec.steps_answered,
        accuracy=round(accuracy, 2),
        new_concepts_learned=lesson_rec.new_words_count,
        reviews_done=lesson_rec.review_words_count,
        ayah_tasks_done=ayah_tasks_done,
    )

    return APIResponse(ok=True, data=LessonCompleteResponse(
        summary=summary,
        engagement={"streak_updated": True},
    ))
