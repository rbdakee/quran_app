"""
Answer processing service — records answers (deferred SRS), applies SRS on completion.
"""
from __future__ import annotations

from datetime import datetime, timezone
from typing import Dict

from sqlalchemy.orm import Session

from api.models.orm import (
    UserTokenProgress, ReviewHistory, LessonRecord, QuranToken, TokenState,
)
from engine.srs_engine import (
    TokenProgress, AnswerSignal, update_progress, classify_outcome,
)


def _orm_to_engine(row: UserTokenProgress) -> TokenProgress:
    """Convert ORM row to engine TokenProgress for SRS calculation."""
    return TokenProgress(
        token_id=row.token_id,
        concept_key=row.concept_key or "",
        state=row.state.value if isinstance(row.state, TokenState) else row.state,
        stability=row.stability,
        difficulty=row.difficulty,
        learning_step=row.learning_step,
        next_review_at=row.next_review_at.isoformat() if row.next_review_at else None,
        last_seen_at=row.last_seen_at.isoformat() if row.last_seen_at else None,
        first_seen_at=row.first_seen_at.isoformat() if row.first_seen_at else None,
        total_reviews=row.total_reviews,
        total_correct=row.total_correct,
        total_wrong=row.total_wrong,
        consecutive_wrong=row.consecutive_wrong,
        last_outcome_bucket=row.last_outcome_bucket or "",
        last_latency_ms=row.last_latency_ms,
    )


def _sync_engine_to_orm(engine_prog: TokenProgress, row: UserTokenProgress) -> None:
    """Write engine TokenProgress back to ORM row without dropping identity fields."""
    if engine_prog.concept_key:
        row.concept_key = engine_prog.concept_key
    row.state = TokenState(engine_prog.state)
    row.stability = engine_prog.stability
    row.difficulty = engine_prog.difficulty
    row.learning_step = engine_prog.learning_step
    row.next_review_at = (
        datetime.fromisoformat(engine_prog.next_review_at)
        if engine_prog.next_review_at else None
    )
    row.last_seen_at = (
        datetime.fromisoformat(engine_prog.last_seen_at)
        if engine_prog.last_seen_at else None
    )
    row.first_seen_at = (
        datetime.fromisoformat(engine_prog.first_seen_at)
        if engine_prog.first_seen_at else row.first_seen_at
    )
    row.total_reviews = engine_prog.total_reviews
    row.total_correct = engine_prog.total_correct
    row.total_wrong = engine_prog.total_wrong
    row.consecutive_wrong = engine_prog.consecutive_wrong
    row.last_outcome_bucket = engine_prog.last_outcome_bucket
    row.last_latency_ms = engine_prog.last_latency_ms


def evaluate_mcq(answer: Dict, correct: str) -> bool:
    """Evaluate MCQ answer."""
    selected = answer.get("selected_option", "")
    return selected.strip().lower() == correct.strip().lower()


def evaluate_assembly(answer: Dict, gold_order: list) -> bool:
    """Evaluate ayah assembly answer (order of token_ids)."""
    submitted = answer.get("ordered_token_ids", [])
    return submitted == gold_order


def record_answer(
    db: Session,
    user_id: str,
    lesson_id: str,
    step_index: int,
    step_type: str,
    token_id: str,
    is_correct: bool,
    telemetry: Dict,
    *,
    update_lesson_counters: bool = True,
) -> Dict:
    """
    Record a user answer (deferred SRS — no progress update until completion):
    1. Classify outcome
    2. Write review_history as buffer
    3. Update lesson record counters (unless update_lesson_counters=False)

    For multi-token steps (e.g. ayah_build), callers should pass
    update_lesson_counters=False and increment counters once externally
    to avoid inflating lesson-level metrics.
    """
    now = datetime.now(timezone.utc)

    attempt_count = telemetry.get("attempt_count", 1)
    latency_ms = telemetry.get("latency_ms", 4000)
    hint_used = telemetry.get("hint_used", False) or telemetry.get("used_hint", False)

    # Build signal + classify
    signal = AnswerSignal(
        is_correct=is_correct,
        attempt_count=attempt_count,
        latency_ms=latency_ms,
        hint_used=hint_used,
    )
    outcome_bucket = classify_outcome(signal)

    # Write review history (serves as the SRS buffer)
    history = ReviewHistory(
        user_id=user_id,
        lesson_id=lesson_id,
        step_index=step_index,
        step_type=step_type,
        token_id=token_id,
        is_correct=is_correct,
        attempt_count=attempt_count,
        latency_ms=latency_ms,
        hint_used=hint_used,
        outcome_bucket=outcome_bucket,
        answered_at=now,
    )
    db.add(history)

    # Update lesson record counters only when this is a single-token step.
    # Multi-token steps (ayah_build) manage counters externally.
    if update_lesson_counters:
        lesson_rec = db.query(LessonRecord).filter(
            LessonRecord.lesson_id == lesson_id
        ).first()
        if lesson_rec:
            lesson_rec.steps_answered += 1
            if is_correct:
                lesson_rec.correct_count += 1

    db.commit()

    return {
        "step_index": step_index,
        "is_correct": is_correct,
        "outcome_bucket": outcome_bucket,
        "feedback": {
            "type": "success" if is_correct else "incorrect",
            "message": "Correct!" if is_correct else "Try again",
        },
        "progress_update": None,
    }


def _resolve_concept_key(db: Session, lesson_id: str, token_id: str) -> str:
    """Resolve concept_key from stored lesson payload first, then dataset fallback."""
    lesson_rec = db.query(LessonRecord).filter(LessonRecord.lesson_id == lesson_id).first()
    payload = lesson_rec.lesson_payload if lesson_rec else None
    if isinstance(payload, dict):
        selection = payload.get("selection", {}) or {}
        for section in ("due", "new", "reinforcement"):
            for token in selection.get(section, []) or []:
                if token.get("token_id") == token_id and token.get("concept_key"):
                    return token["concept_key"]
        for step in payload.get("steps", []) or []:
            token = step.get("token") or {}
            if token.get("token_id") == token_id and token.get("concept_key"):
                return token["concept_key"]
            for pool_token in step.get("pool", []) or []:
                if pool_token.get("token_id") == token_id and pool_token.get("concept_key"):
                    return pool_token["concept_key"]

    quran_token = db.query(QuranToken).filter(QuranToken.token_id == token_id).first()
    return (quran_token.concept_key or "") if quran_token else ""


def apply_deferred_srs(db: Session, user_id: str, lesson_id: str) -> Dict:
    """
    Apply all buffered SRS updates for a completed lesson.
    Called only from complete_lesson — atomic commit.

    Groups review_history by token_id, applies last answer per token.
    """
    now = datetime.now(timezone.utc)

    # Get all review_history for this lesson, ordered by answered_at
    reviews = db.query(ReviewHistory).filter(
        ReviewHistory.lesson_id == lesson_id,
        ReviewHistory.user_id == user_id,
    ).order_by(ReviewHistory.answered_at.asc()).all()

    # Group by token_id — last answer per token wins
    token_reviews: Dict[str, ReviewHistory] = {}
    for r in reviews:
        token_reviews[r.token_id] = r

    tokens_updated = 0
    for token_id, review in token_reviews.items():
        # Get or create progress row
        progress_row = db.query(UserTokenProgress).filter(
            UserTokenProgress.user_id == user_id,
            UserTokenProgress.token_id == token_id,
        ).first()

        if not progress_row:
            progress_row = UserTokenProgress(
                user_id=user_id,
                token_id=token_id,
                concept_key=_resolve_concept_key(db, lesson_id, token_id),
                state=TokenState.new,
                first_seen_at=now,
                last_seen_at=now,
            )
            db.add(progress_row)
            db.flush()
        elif not progress_row.concept_key:
            progress_row.concept_key = _resolve_concept_key(db, lesson_id, token_id)

        # Build signal from review_history
        signal = AnswerSignal(
            is_correct=review.is_correct,
            attempt_count=review.attempt_count,
            latency_ms=review.latency_ms or 4000,
            hint_used=review.hint_used,
        )

        # Run SRS engine
        engine_prog = _orm_to_engine(progress_row)
        if progress_row.concept_key and not engine_prog.concept_key:
            engine_prog.concept_key = progress_row.concept_key
        update_progress(engine_prog, signal, now)
        _sync_engine_to_orm(engine_prog, progress_row)
        tokens_updated += 1

    # Single atomic commit for all SRS updates
    db.commit()
    return {"tokens_updated": tokens_updated}


# Keep old name as alias for backward compatibility in tests
process_answer = record_answer
