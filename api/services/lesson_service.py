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
    QuranToken, UserTokenProgress, LessonRecord, TokenState,
)

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


def generate_lesson_for_user(db: Session, user_id: str, seed: int = 7) -> Dict:
    """
    Generate a lesson for the given user.

    1. Load user progress from DB
    2. Convert to legacy format
    3. Call engine build_lesson()
    4. Save lesson record to DB
    5. Mark new words in user progress
    """
    tokens = _get_tokens()

    # Load user progress
    progress_rows = db.query(UserTokenProgress).filter(
        UserTokenProgress.user_id == user_id
    ).all()

    progress_dict = _progress_to_legacy(progress_rows) if progress_rows else {}

    # Generate lesson via engine
    lesson = build_lesson(tokens, seed=seed, progress_override=progress_dict if progress_dict else None)

    # Save lesson record
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

    # Mark new words in progress (first_seen_at)
    for t_payload in lesson.get("selection", {}).get("new", []):
        tid = t_payload.get("token_id", "")
        ckey = t_payload.get("concept_key", "")
        if not tid:
            continue

        existing = db.query(UserTokenProgress).filter(
            UserTokenProgress.user_id == user_id,
            UserTokenProgress.token_id == tid,
        ).first()

        if not existing:
            new_prog = UserTokenProgress(
                user_id=user_id,
                token_id=tid,
                concept_key=ckey,
                state=TokenState.new,
                first_seen_at=now,
                last_seen_at=now,
            )
            db.add(new_prog)
        elif existing.first_seen_at is None:
            existing.first_seen_at = now
            existing.last_seen_at = now

    db.commit()

    # Add step_id and step_index to steps
    for i, step in enumerate(lesson["steps"]):
        step["step_id"] = f"step_{i:04d}"
        step["step_index"] = i

    return lesson
