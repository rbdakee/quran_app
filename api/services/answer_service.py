"""
Answer processing service — evaluates answers, updates SRS, writes history.
"""
from __future__ import annotations

from datetime import datetime, timezone
from typing import Dict, Optional

from sqlalchemy.orm import Session

from api.models.orm import (
    UserTokenProgress, ReviewHistory, LessonRecord, TokenState,
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
    """Write engine TokenProgress back to ORM row."""
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


def process_answer(
    db: Session,
    user_id: str,
    lesson_id: str,
    step_index: int,
    step_type: str,
    token_id: str,
    is_correct: bool,
    telemetry: Dict,
) -> Dict:
    """
    Process a user answer:
    1. Record in review_history
    2. Update SRS via engine
    3. Write updated progress to DB
    """
    now = datetime.now(timezone.utc)

    attempt_count = telemetry.get("attempt_count", 1)
    latency_ms = telemetry.get("latency_ms", 4000)
    hint_used = telemetry.get("hint_used", False) or telemetry.get("used_hint", False)

    # Build signal
    signal = AnswerSignal(
        is_correct=is_correct,
        attempt_count=attempt_count,
        latency_ms=latency_ms,
        hint_used=hint_used,
    )
    outcome_bucket = classify_outcome(signal)

    # Write review history
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

    # Get or create progress row
    progress_row = db.query(UserTokenProgress).filter(
        UserTokenProgress.user_id == user_id,
        UserTokenProgress.token_id == token_id,
    ).first()

    if not progress_row:
        progress_row = UserTokenProgress(
            user_id=user_id,
            token_id=token_id,
            state=TokenState.new,
            first_seen_at=now,
        )
        db.add(progress_row)
        db.flush()

    # Run SRS engine
    engine_prog = _orm_to_engine(progress_row)
    update_progress(engine_prog, signal, now)
    _sync_engine_to_orm(engine_prog, progress_row)

    # Update lesson record steps_answered
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
        "progress_update": {
            "token_id": token_id,
            "new_state": engine_prog.state,
            "stability": round(engine_prog.stability, 2),
            "next_review_at": engine_prog.next_review_at,
        },
    }
