"""
Progress and engagement API endpoints.
"""
from __future__ import annotations

from typing import Optional
import time
from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session

from api.models.db import get_db
from api.models.schemas import APIResponse
from api.services.progress_service import (
    get_progress_summary,
    get_due_tokens,
    get_engagement,
    generate_review_lesson,
)
from api.cache import cache_lesson

router = APIRouter(prefix="/progress", tags=["progress"])


@router.get("/summary")
def progress_summary(
    user_id: str = Query(default="default_user"),
    db: Session = Depends(get_db),
):
    """Return progress summary for user."""
    data = get_progress_summary(db, user_id)
    return APIResponse(ok=True, data=data)


@router.get("/reviews-due")
def reviews_due(
    user_id: str = Query(default="default_user"),
    limit: int = Query(default=50, ge=1, le=200),
    db: Session = Depends(get_db),
):
    """Return tokens due for review."""
    data = get_due_tokens(db, user_id, limit=limit)
    return APIResponse(ok=True, data=data)


@router.get("/engagement")
def engagement_summary(
    user_id: str = Query(default="default_user"),
    db: Session = Depends(get_db),
):
    """Return engagement stats."""
    data = get_engagement(db, user_id)
    return APIResponse(ok=True, data=data)


@router.get("/reviews-words")
def reviews_words(
    user_id: str = Query(default="default_user"),
    seed: Optional[int] = Query(default=None, description="Random seed (omit for auto-generate)"),
    limit: int = Query(default=20, ge=1, le=50),
    db: Session = Depends(get_db),
):
    """
    **DEMOTED** — Optional review-only lesson for debug/testing/extra practice.

    This is NOT the canonical learning path.  Use POST /lessons/create-next
    for the primary progression pipeline.  Next Lesson automatically absorbs
    review pressure and throttles new words when due reviews are high.

    This endpoint remains available for:
    - Admin/debug inspection of review-only behavior
    - Optional extra practice outside the canonical flow
    - Backward compatibility during transition

    Prioritizes words with next_review_at <= now, then adds random words.
    No new words added by backend.
    """
    if seed is None:
        seed = int(time.time()) % 100000
    
    lesson = generate_review_lesson(db, user_id, seed=seed, word_limit=limit)
    
    # Mark as non-canonical so consumers know this is optional
    lesson["pipeline"] = "review_only_optional"
    
    # Cache for answer processing (shared with lessons)
    cache_lesson(lesson["lesson_id"], lesson)
    
    return APIResponse(ok=True, data=lesson)
