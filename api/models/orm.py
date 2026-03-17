"""
SQLAlchemy ORM models — matches DATA_SCHEMA.md.
"""
from datetime import datetime, timezone
from sqlalchemy import (
    String, Integer, Float, Text, Boolean, DateTime, Enum as SAEnum,
    ForeignKey, Index, UniqueConstraint, CheckConstraint,
)
from sqlalchemy.orm import Mapped, mapped_column, relationship

from api.models.db import Base


# ---------------------------------------------------------------------------
# Enums
# ---------------------------------------------------------------------------

import enum


class TokenState(str, enum.Enum):
    new = "new"
    learning = "learning"
    reviewing = "reviewing"
    mastered = "mastered"
    lapsed = "lapsed"


class OutcomeBucket(str, enum.Enum):
    perfect_fast = "perfect_fast"
    correct = "correct"
    correct_slow = "correct_slow"
    correct_retry = "correct_retry"
    hint_used = "hint_used"
    wrong = "wrong"


# ---------------------------------------------------------------------------
# Tables
# ---------------------------------------------------------------------------

class QuranToken(Base):
    """Static Quran token data — imported from dataset.csv."""
    __tablename__ = "quran_tokens"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    token_id: Mapped[str] = mapped_column(String(32), unique=True, nullable=False, index=True)
    surah: Mapped[int] = mapped_column(Integer, nullable=False)
    ayah: Mapped[int] = mapped_column(Integer, nullable=False)
    word: Mapped[int] = mapped_column(Integer, nullable=False)
    location: Mapped[str] = mapped_column(String(16), nullable=False)
    audio_key: Mapped[str] = mapped_column(String(64), nullable=True)
    full_form_ar: Mapped[str] = mapped_column(String(128), nullable=False)
    lemma_ar: Mapped[str] = mapped_column(String(128), nullable=True)
    root_ar: Mapped[str] = mapped_column(String(32), nullable=True)
    pos: Mapped[str] = mapped_column(String(16), nullable=True)
    translation_en: Mapped[str] = mapped_column(Text, nullable=True)
    concept_key: Mapped[str] = mapped_column(String(128), nullable=True, index=True)
    freq_global: Mapped[int] = mapped_column(Integer, default=1)
    concept_freq: Mapped[int] = mapped_column(Integer, default=1)

    __table_args__ = (
        Index("ix_quran_tokens_surah_ayah", "surah", "ayah"),
    )


class UserTokenProgress(Base):
    """Per-user, per-token SRS progress."""
    __tablename__ = "user_token_progress"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    user_id: Mapped[str] = mapped_column(String(64), nullable=False, index=True)
    token_id: Mapped[str] = mapped_column(String(32), ForeignKey("quran_tokens.token_id"), nullable=False)
    concept_key: Mapped[str] = mapped_column(String(128), nullable=True)

    state: Mapped[str] = mapped_column(
        SAEnum(TokenState, name="token_state", create_constraint=True),
        default=TokenState.new,
        nullable=False,
    )
    learning_step: Mapped[int] = mapped_column(Integer, default=0)
    stability: Mapped[float] = mapped_column(Float, default=0.17)
    difficulty: Mapped[float] = mapped_column(Float, default=0.5)

    next_review_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True, index=True)
    last_seen_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    first_seen_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)

    total_reviews: Mapped[int] = mapped_column(Integer, default=0)
    total_correct: Mapped[int] = mapped_column(Integer, default=0)
    total_wrong: Mapped[int] = mapped_column(Integer, default=0)
    consecutive_wrong: Mapped[int] = mapped_column(Integer, default=0)

    last_outcome_bucket: Mapped[str | None] = mapped_column(String(32), nullable=True)
    last_latency_ms: Mapped[int | None] = mapped_column(Integer, nullable=True)

    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
    )

    __table_args__ = (
        UniqueConstraint("user_id", "token_id", name="uq_user_token"),
        Index("ix_user_progress_due", "user_id", "state", "next_review_at"),
    )


class ReviewHistory(Base):
    """Individual answer events — audit trail."""
    __tablename__ = "review_history"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    user_id: Mapped[str] = mapped_column(String(64), nullable=False, index=True)
    lesson_id: Mapped[str] = mapped_column(String(64), nullable=False, index=True)
    step_index: Mapped[int] = mapped_column(Integer, nullable=False)
    step_type: Mapped[str] = mapped_column(String(48), nullable=False)
    token_id: Mapped[str] = mapped_column(String(32), ForeignKey("quran_tokens.token_id"), nullable=False)

    is_correct: Mapped[bool] = mapped_column(Boolean, nullable=False)
    attempt_count: Mapped[int] = mapped_column(Integer, default=1)
    latency_ms: Mapped[int] = mapped_column(Integer, nullable=True)
    hint_used: Mapped[bool] = mapped_column(Boolean, default=False)
    outcome_bucket: Mapped[str] = mapped_column(String(32), nullable=True)

    answered_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
    )

    __table_args__ = (
        Index("ix_review_history_user_lesson", "user_id", "lesson_id"),
    )


class LessonRecord(Base):
    """Completed lesson metadata."""
    __tablename__ = "lesson_records"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    lesson_id: Mapped[str] = mapped_column(String(64), unique=True, nullable=False)
    user_id: Mapped[str] = mapped_column(String(64), nullable=False, index=True)
    algorithm_version: Mapped[str] = mapped_column(String(48), nullable=False)

    total_steps: Mapped[int] = mapped_column(Integer, nullable=False)
    steps_answered: Mapped[int] = mapped_column(Integer, default=0)
    correct_count: Mapped[int] = mapped_column(Integer, default=0)
    new_words_count: Mapped[int] = mapped_column(Integer, default=0)
    review_words_count: Mapped[int] = mapped_column(Integer, default=0)

    started_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
    )
    completed_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    is_completed: Mapped[bool] = mapped_column(Boolean, default=False)


class UserEngagement(Base):
    """User-level engagement stats."""
    __tablename__ = "user_engagement"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    user_id: Mapped[str] = mapped_column(String(64), unique=True, nullable=False)

    current_streak_days: Mapped[int] = mapped_column(Integer, default=0)
    best_streak_days: Mapped[int] = mapped_column(Integer, default=0)
    last_active_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    lessons_completed_total: Mapped[int] = mapped_column(Integer, default=0)
    days_active_30d: Mapped[int] = mapped_column(Integer, default=0)

    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
    )
