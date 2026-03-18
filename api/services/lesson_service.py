"""
Lesson generation/persistence service — bridges engine/ with the API layer.
"""
from __future__ import annotations

import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Dict, List, Optional

from sqlalchemy.orm import Session

# Engine imports
sys.path.insert(0, str(Path(__file__).resolve().parent.parent.parent))
from engine.generate_lesson import read_tokens, build_lesson

from api.models.orm import (
    UserTokenProgress, LessonRecord, ReviewHistory, TokenState, LessonStatus,
)
from api.cache import cache_lesson, get_cached_lesson, remove_cached_lesson

# Cache dataset tokens in memory (loaded once)
_DATASET_PATH = Path(__file__).resolve().parent.parent.parent / "dataset.csv"
_tokens_cache: Optional[list] = None


def _get_tokens():
    global _tokens_cache
    if _tokens_cache is None:
        _tokens_cache = read_tokens(_DATASET_PATH)
    return _tokens_cache


def _progress_to_legacy(rows: List[UserTokenProgress]) -> Dict[str, Dict]:
    """Convert ORM progress rows to legacy dict format for engine."""
    result = {}
    for r in rows:
        result[r.token_id] = {
            "token_id": r.token_id,
            "concept_key": r.concept_key or "",
            "state": r.state.value if isinstance(r.state, TokenState) else r.state,
            "learning_step": r.learning_step,
            "stability": r.stability,
            "difficulty_user": r.difficulty,
            "next_review_at": r.next_review_at.isoformat() if r.next_review_at else datetime.now(timezone.utc).isoformat(),
            "last_seen_at": r.last_seen_at.isoformat() if r.last_seen_at else None,
            "first_seen_at": r.first_seen_at.isoformat() if r.first_seen_at else None,
            "total_reviews": r.total_reviews,
            "total_correct": r.total_correct,
            "total_wrong": r.total_wrong,
            "consecutive_wrong": r.consecutive_wrong,
            "last_outcome": r.last_outcome_bucket or "",
        }
    return result


def _sync_legacy_flags(rec: LessonRecord) -> None:
    status = rec.status.value if isinstance(rec.status, LessonStatus) else rec.status
    rec.is_completed = status == LessonStatus.completed.value
    rec.is_invalidated = status == LessonStatus.invalidated.value
    if rec.is_invalidated and rec.invalidated_at is None:
        rec.invalidated_at = datetime.now(timezone.utc)


def _decorate_steps(lesson: Dict) -> Dict:
    for i, step in enumerate(lesson.get("steps", [])):
        step["step_id"] = f"step_{i:04d}"
        step["step_index"] = i
    return lesson


def _store_lesson_record(db: Session, user_id: str, seed: int | None, lesson: Dict) -> LessonRecord:
    now = datetime.now(timezone.utc)
    record = LessonRecord(
        lesson_id=lesson["lesson_id"],
        user_id=user_id,
        algorithm_version=lesson["algorithm_version"],
        status=LessonStatus.generated,
        lesson_payload=lesson,
        seed=seed,
        total_steps=len(lesson.get("steps", [])),
        new_words_count=len(lesson.get("selection", {}).get("new", [])),
        review_words_count=len(lesson.get("selection", {}).get("due", [])),
        started_at=now,
    )
    _sync_legacy_flags(record)
    db.add(record)
    db.commit()
    db.refresh(record)
    return record


def serialize_lesson_instance(rec: LessonRecord) -> Dict:
    payload = dict(rec.lesson_payload or {})
    payload.setdefault("lesson_id", rec.lesson_id)
    payload.setdefault("algorithm_version", rec.algorithm_version)
    status = rec.status.value if isinstance(rec.status, LessonStatus) else rec.status
    payload["status"] = status
    payload["read_only"] = status in {LessonStatus.completed.value, LessonStatus.invalidated.value}
    payload["started_at"] = rec.started_at.isoformat() if rec.started_at else None
    payload["completed_at"] = rec.completed_at.isoformat() if rec.completed_at else None
    payload["invalidated_at"] = rec.invalidated_at.isoformat() if rec.invalidated_at else None
    return payload


def get_active_lesson_record(db: Session, user_id: str) -> LessonRecord | None:
    return db.query(LessonRecord).filter(
        LessonRecord.user_id == user_id,
        LessonRecord.status.in_([LessonStatus.generated, LessonStatus.in_progress]),
    ).order_by(LessonRecord.started_at.desc()).first()


def invalidate_active_lessons(db: Session, user_id: str) -> List[str]:
    """
    Invalidate all active lessons for user.
    Deletes orphaned review_history (SRS was never committed).
    Returns list of invalidated lesson_ids.
    """
    now = datetime.now(timezone.utc)

    active = db.query(LessonRecord).filter(
        LessonRecord.user_id == user_id,
        LessonRecord.status.in_([LessonStatus.generated, LessonStatus.in_progress]),
    ).all()

    invalidated_ids = []
    for rec in active:
        rec.status = LessonStatus.invalidated
        rec.invalidated_at = now
        _sync_legacy_flags(rec)
        invalidated_ids.append(rec.lesson_id)

        db.query(ReviewHistory).filter(
            ReviewHistory.lesson_id == rec.lesson_id,
        ).delete()

        remove_cached_lesson(rec.lesson_id)

    if invalidated_ids:
        db.commit()

    return invalidated_ids


def generate_lesson_for_user(db: Session, user_id: str, seed: int = 7) -> Dict:
    """
    Generate a new lesson for the given user and persist full payload to DB.
    """
    tokens = _get_tokens()
    progress_rows = db.query(UserTokenProgress).filter(
        UserTokenProgress.user_id == user_id
    ).all()
    progress_dict = _progress_to_legacy(progress_rows) if progress_rows else {}

    lesson = build_lesson(tokens, seed=seed, progress_override=progress_dict)
    lesson = _decorate_steps(lesson)
    _store_lesson_record(db, user_id=user_id, seed=seed, lesson=lesson)
    lesson["status"] = LessonStatus.generated.value
    lesson["read_only"] = False
    cache_lesson(lesson["lesson_id"], lesson)
    return lesson


def create_or_reuse_next_lesson(db: Session, user_id: str, seed: int) -> Dict:
    active = get_active_lesson_record(db, user_id)
    if active:
        payload = serialize_lesson_instance(active)
        if active.lesson_payload:
            cache_lesson(active.lesson_id, active.lesson_payload)
        return payload
    return generate_lesson_for_user(db, user_id, seed=seed)


def get_lesson_payload(db: Session, lesson_id: str, user_id: str) -> Dict | None:
    rec = db.query(LessonRecord).filter(
        LessonRecord.lesson_id == lesson_id,
        LessonRecord.user_id == user_id,
    ).first()
    if not rec:
        return None

    cached = get_cached_lesson(lesson_id)
    if cached is None and rec.lesson_payload:
        cache_lesson(lesson_id, rec.lesson_payload)
    return serialize_lesson_instance(rec)


def get_lesson_timeline(db: Session, user_id: str, limit: int = 20) -> Dict:
    records = db.query(LessonRecord).filter(
        LessonRecord.user_id == user_id,
    ).order_by(LessonRecord.started_at.desc()).limit(limit).all()

    items = []
    active_lesson_id = None
    for rec in records:
        status = rec.status.value if isinstance(rec.status, LessonStatus) else rec.status
        if status in {LessonStatus.generated.value, LessonStatus.in_progress.value} and active_lesson_id is None:
            active_lesson_id = rec.lesson_id
        items.append({
            "lesson_id": rec.lesson_id,
            "status": status,
            "read_only": status in {LessonStatus.completed.value, LessonStatus.invalidated.value},
            "started_at": rec.started_at.isoformat() if rec.started_at else None,
            "completed_at": rec.completed_at.isoformat() if rec.completed_at else None,
            "invalidated_at": rec.invalidated_at.isoformat() if rec.invalidated_at else None,
            "total_steps": rec.total_steps,
            "steps_answered": rec.steps_answered,
            "correct_count": rec.correct_count,
            "new_words_count": rec.new_words_count,
            "review_words_count": rec.review_words_count,
            "algorithm_version": rec.algorithm_version,
        })

    return {
        "items": items,
        "next_lesson": {
            "kind": "create_or_open",
            "has_active_lesson": active_lesson_id is not None,
            "active_lesson_id": active_lesson_id,
        },
    }
