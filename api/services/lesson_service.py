"""
Lesson generation service — bridges engine/ with the API layer.
"""
from __future__ import annotations

import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Dict, List, Optional

from sqlalchemy.orm import Session

# Engine imports
sys.path.insert(0, str(Path(__file__).resolve().parent.parent.parent))
from engine.generate_lesson import read_tokens, build_lesson, token_payload
from engine.srs_engine import compute_dynamic_counts

from api.models.orm import (
    QuranToken, UserTokenProgress, LessonRecord, ReviewHistory, TokenState,
)
from api.cache import remove_cached_lesson

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


def invalidate_active_lessons(db: Session, user_id: str) -> List[str]:
    """
    Invalidate all incomplete lessons for user.
    Deletes orphaned review_history (SRS was never committed).
    Returns list of invalidated lesson_ids.
    """
    now = datetime.now(timezone.utc)

    active = db.query(LessonRecord).filter(
        LessonRecord.user_id == user_id,
        LessonRecord.is_completed == False,
        LessonRecord.is_invalidated == False,
    ).all()

    invalidated_ids = []
    for rec in active:
        rec.is_invalidated = True
        rec.invalidated_at = now
        invalidated_ids.append(rec.lesson_id)

        # Delete orphaned review_history rows (SRS was never committed)
        db.query(ReviewHistory).filter(
            ReviewHistory.lesson_id == rec.lesson_id,
        ).delete()

        # Remove from in-memory cache
        remove_cached_lesson(rec.lesson_id)

    if invalidated_ids:
        db.commit()

    return invalidated_ids


def generate_lesson_for_user(db: Session, user_id: str, seed: int = 7) -> Dict:
    """
    Generate a lesson for the given user (side-effect-free).

    1. Load user progress from DB
    2. Convert to legacy format
    3. Call engine build_lesson()
    4. Save lesson record to DB (no user_token_progress changes)
    """
    tokens = _get_tokens()

    # Load user progress
    progress_rows = db.query(UserTokenProgress).filter(
        UserTokenProgress.user_id == user_id
    ).all()

    progress_dict = _progress_to_legacy(progress_rows) if progress_rows else {}

    # Generate lesson via engine
    lesson = build_lesson(tokens, seed=seed, progress_override=progress_dict if progress_dict else None)

    # Save lesson record (no progress side effects)
    now = datetime.now(timezone.utc)
    record = LessonRecord(
        lesson_id=lesson["lesson_id"],
        user_id=user_id,
        algorithm_version=lesson["algorithm_version"],
        total_steps=len(lesson["steps"]),
        new_words_count=len(lesson.get("selection", {}).get("new", [])),
        review_words_count=len(lesson.get("selection", {}).get("due", [])),
        started_at=now,
    )
    db.add(record)
    db.commit()

    # Add step_id and step_index to steps
    for i, step in enumerate(lesson["steps"]):
        step["step_id"] = f"step_{i:04d}"
        step["step_index"] = i

    return lesson
