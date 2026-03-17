"""
Lesson API endpoints.
"""
from __future__ import annotations

import time
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session

from api.models.db import get_db
from api.models.schemas import (
    APIResponse, AnswerRequest, AnswerResponse,
    LessonCompleteRequest, LessonCompleteResponse, LessonSummary,
)
from api.services.lesson_service import generate_lesson_for_user
from api.services.answer_service import process_answer, evaluate_mcq, evaluate_assembly
from api.services.progress_service import update_engagement_on_complete
from api.models.orm import LessonRecord
from api.cache import cache_lesson, get_cached_lesson

router = APIRouter(prefix="/lessons", tags=["lessons"])


@router.get("/today")
def get_lesson_today(
    user_id: str = Query(default="default_user"),
    seed: Optional[int] = Query(default=None),
    db: Session = Depends(get_db),
):
    """Generate today's lesson for the user."""
    if seed is None:
        seed = int(time.time()) % 100000

    lesson = generate_lesson_for_user(db, user_id, seed=seed)

    # Cache for answer processing
    cache_lesson(lesson["lesson_id"], lesson)

    return APIResponse(ok=True, data=lesson)


@router.get("/{lesson_id}")
def get_lesson_by_id(
    lesson_id: str,
):
    """Return an active lesson payload by ID from backend cache."""
    lesson = get_cached_lesson(lesson_id)
    if not lesson:
        raise HTTPException(
            status_code=404,
            detail={"code": "LESSON_NOT_ACTIVE", "message": "Lesson payload not found in active cache"},
        )
    return APIResponse(ok=True, data=lesson)


@router.post("/{lesson_id}/answer")
def submit_answer(
    lesson_id: str,
    req: AnswerRequest,
    user_id: str = Query(default="default_user"),
    db: Session = Depends(get_db),
):
    """Submit an answer for a lesson step."""
    # Validate lesson exists
    lesson_rec = db.query(LessonRecord).filter(
        LessonRecord.lesson_id == lesson_id
    ).first()
    if not lesson_rec:
        raise HTTPException(status_code=404, detail={"code": "NOT_FOUND", "message": "Lesson not found"})

    if lesson_rec.is_completed:
        raise HTTPException(status_code=400, detail={"code": "LESSON_EXPIRED", "message": "Lesson already completed"})

    # Determine correctness
    cached = get_cached_lesson(lesson_id)
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
            # new_word_intro — always "correct" (it's informational)
            is_correct = True
    else:
        # Fallback: trust client-reported correctness if no cache
        is_correct = req.answer.get("is_correct", False)
        step_type = req.step_type
        step = {}

    # ── ayah_build: process answer per token in gold_order ──
    if req.step_type.startswith("ayah_build"):
        gold_ids = step.get("gold_order_token_ids", []) if step else []
        if not gold_ids:
            gold_ids = [tid for tid in (req.answer.get("ordered_token_ids") or []) if tid]

        if not gold_ids:
            raise HTTPException(
                status_code=400,
                detail={"code": "INVALID_STEP", "message": "No token_ids for ayah_build step"},
            )

        last_result = None
        for token_id in gold_ids:
            last_result = process_answer(
                db=db,
                user_id=user_id,
                lesson_id=lesson_id,
                step_index=req.step_index,
                step_type=req.step_type,
                token_id=token_id,
                is_correct=is_correct,
                telemetry=req.telemetry,
            )

        result = last_result
        # Patch result with assembly-level info
        if result:
            result["step_index"] = req.step_index
            result["is_correct"] = is_correct
    else:
        result = process_answer(
            db=db,
            user_id=user_id,
            lesson_id=lesson_id,
            step_index=req.step_index,
            step_type=req.step_type,
            token_id=req.token_id,
            is_correct=is_correct,
            telemetry=req.telemetry,
        )

    return APIResponse(ok=True, data=result)


@router.post("/{lesson_id}/complete")
def complete_lesson(
    lesson_id: str,
    req: LessonCompleteRequest = LessonCompleteRequest(),
    user_id: str = Query(default="default_user"),
    db: Session = Depends(get_db),
):
    """Mark a lesson as completed."""
    lesson_rec = db.query(LessonRecord).filter(
        LessonRecord.lesson_id == lesson_id
    ).first()

    if not lesson_rec:
        raise HTTPException(status_code=404, detail={"code": "NOT_FOUND", "message": "Lesson not found"})

    if lesson_rec.is_completed:
        raise HTTPException(status_code=400, detail={"code": "LESSON_EXPIRED", "message": "Already completed"})

    from datetime import datetime, timezone
    lesson_rec.is_completed = True
    lesson_rec.completed_at = datetime.now(timezone.utc)
    db.commit()

    # Update engagement
    update_engagement_on_complete(db, user_id)

    accuracy = lesson_rec.correct_count / max(1, lesson_rec.steps_answered)

    # Count ayah tasks from cached lesson
    ayah_tasks_done = 0
    cached = get_cached_lesson(lesson_id)
    if cached:
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


# Cleanup cache on lesson complete
@router.on_event("shutdown")
def cleanup():
    _active_lessons.clear()
