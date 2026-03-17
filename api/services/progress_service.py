"""
Progress and engagement query services.
"""
from __future__ import annotations

import sys
import random
from datetime import datetime, timezone
from pathlib import Path
from typing import Dict, List, Optional

from sqlalchemy.orm import Session
from sqlalchemy import func

from api.models.orm import (
    UserTokenProgress, UserEngagement, LessonRecord, TokenState,
)
from engine.srs_engine import due_score, TokenProgress, is_due

# Engine imports
sys.path.insert(0, str(Path(__file__).resolve().parent.parent.parent))
from engine.generate_lesson import read_tokens, build_review_lesson
from api.services.lesson_service import _progress_to_legacy, _get_tokens


def get_progress_summary(db: Session, user_id: str) -> Dict:
    """Return user progress summary (state counts, due count, weak concepts)."""
    rows = db.query(UserTokenProgress).filter(
        UserTokenProgress.user_id == user_id
    ).all()

    now = datetime.now(timezone.utc)
    by_state: Dict[str, int] = {}
    due_count = 0
    weak_concepts: List[str] = []

    for r in rows:
        state = r.state.value if isinstance(r.state, TokenState) else r.state
        by_state[state] = by_state.get(state, 0) + 1

        if r.next_review_at and r.next_review_at <= now and state != "new":
            due_count += 1

        if r.total_wrong > 0 and r.total_reviews > 0:
            wrong_rate = r.total_wrong / r.total_reviews
            if wrong_rate >= 0.4 and r.concept_key:
                weak_concepts.append(r.concept_key)

    return {
        "total_tokens": len(rows),
        "by_state": by_state,
        "due_count": due_count,
        "weak_concepts": list(set(weak_concepts))[:20],
    }


def get_due_tokens(db: Session, user_id: str, limit: int = 50) -> List[Dict]:
    """Return tokens due for review, sorted by urgency."""
    now = datetime.now(timezone.utc)

    rows = db.query(UserTokenProgress).filter(
        UserTokenProgress.user_id == user_id,
        UserTokenProgress.state != TokenState.new,
        UserTokenProgress.next_review_at <= now,
    ).all()

    scored = []
    for r in rows:
        tp = TokenProgress(
            token_id=r.token_id,
            concept_key=r.concept_key or "",
            state=r.state.value if isinstance(r.state, TokenState) else r.state,
            stability=r.stability,
            difficulty=r.difficulty,
            next_review_at=r.next_review_at.isoformat() if r.next_review_at else None,
            first_seen_at=r.first_seen_at.isoformat() if r.first_seen_at else None,
            total_reviews=r.total_reviews,
            total_wrong=r.total_wrong,
        )
        score = due_score(tp, now)
        scored.append({
            "token_id": r.token_id,
            "concept_key": r.concept_key or "",
            "state": r.state.value if isinstance(r.state, TokenState) else r.state,
            "stability": round(r.stability, 2),
            "next_review_at": r.next_review_at.isoformat() if r.next_review_at else None,
            "due_score": round(score, 2),
        })

    scored.sort(key=lambda x: x["due_score"], reverse=True)
    return scored[:limit]


def get_engagement(db: Session, user_id: str) -> Dict:
    """Return user engagement stats."""
    eng = db.query(UserEngagement).filter(
        UserEngagement.user_id == user_id
    ).first()

    if not eng:
        return {
            "current_streak_days": 0,
            "best_streak_days": 0,
            "lessons_completed_total": 0,
            "days_active_30d": 0,
            "last_active_at": None,
        }

    return {
        "current_streak_days": eng.current_streak_days,
        "best_streak_days": eng.best_streak_days,
        "lessons_completed_total": eng.lessons_completed_total,
        "days_active_30d": eng.days_active_30d,
        "last_active_at": eng.last_active_at.isoformat() if eng.last_active_at else None,
    }


def generate_review_lesson(db: Session, user_id: str, seed: int = 7, word_limit: int = 20) -> Dict:
    """Generate a review-only lesson from full user progress.

    word_limit is kept for API compatibility; lesson sizing is handled by the engine.
    """
    tokens = _get_tokens()
    now = datetime.now(timezone.utc)

    all_known = db.query(UserTokenProgress).filter(
        UserTokenProgress.user_id == user_id,
        UserTokenProgress.state != TokenState.new,
    ).all()

    progress_dict = _progress_to_legacy(all_known) if all_known else {}

    lesson = build_review_lesson(
        tokens=tokens,
        seed=seed,
        progress_override=progress_dict,
        target_steps=14,
    )

    record = LessonRecord(
        lesson_id=lesson["lesson_id"],
        user_id=user_id,
        algorithm_version=lesson["algorithm_version"],
        total_steps=len(lesson["steps"]),
        new_words_count=0,
        review_words_count=len(lesson.get("selection", {}).get("due", [])),
        started_at=now,
    )
    db.add(record)
    db.commit()

    return lesson


def update_engagement_on_complete(db: Session, user_id: str) -> None:
    """Update engagement stats when a lesson is completed."""
    now = datetime.now(timezone.utc)

    eng = db.query(UserEngagement).filter(
        UserEngagement.user_id == user_id
    ).first()

    if not eng:
        eng = UserEngagement(
            user_id=user_id,
            current_streak_days=1,
            best_streak_days=1,
            last_active_at=now,
            lessons_completed_total=1,
            days_active_30d=1,
        )
        db.add(eng)
    else:
        eng.lessons_completed_total += 1

        if eng.last_active_at:
            days_since = (now.date() - eng.last_active_at.date()).days
            if days_since == 1:
                eng.current_streak_days += 1
            elif days_since > 1:
                eng.current_streak_days = 1
            # days_since == 0 → same day, no streak change
        else:
            eng.current_streak_days = 1

        eng.best_streak_days = max(eng.best_streak_days, eng.current_streak_days)
        eng.last_active_at = now

    db.commit()
