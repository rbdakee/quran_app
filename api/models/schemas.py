"""
Pydantic schemas — request/response models for the API.
Matches backend_contracts.md.
"""
from __future__ import annotations
from datetime import datetime
from typing import Any, Dict, List, Optional
from pydantic import BaseModel, Field


# ---------------------------------------------------------------------------
# Shared
# ---------------------------------------------------------------------------

class APIResponse(BaseModel):
    ok: bool = True
    data: Any = None


class APIError(BaseModel):
    ok: bool = False
    error: Dict[str, Any]


# ---------------------------------------------------------------------------
# Token payload (read-only, embedded in steps)
# ---------------------------------------------------------------------------

class TokenPayload(BaseModel):
    token_id: str
    location: str
    surah: int
    ayah: int
    word: int
    ar: str
    lemma_ar: str = ""
    root_ar: str = ""
    pos: str = ""
    translation_en: str = ""
    audio_key: str = ""
    freq_global: int = 1
    concept_key: str = ""
    concept_freq: int = 1
    pos_bucket: str = ""


# ---------------------------------------------------------------------------
# Lesson
# ---------------------------------------------------------------------------

class LessonStep(BaseModel):
    step_id: str = ""
    step_index: int = 0
    type: str
    skill_type: str = ""
    token: Optional[TokenPayload] = None
    task: Optional[str] = None
    options: Optional[List[str]] = None
    correct: Optional[str] = None
    # Ayah fields
    surah: Optional[int] = None
    ayah: Optional[int] = None
    ayah_segment_index: Optional[int] = None
    gold_order_token_ids: Optional[List[str]] = None
    pool: Optional[List[Dict[str, Any]]] = None
    # Additional
    extra: Optional[Dict[str, Any]] = None


class DynamicCounts(BaseModel):
    total_known_words: int
    computed_new: int
    computed_review: int
    actual_new: int
    actual_due: int
    actual_reinforcement: int


class LessonResponse(BaseModel):
    lesson_id: str
    generated_at_utc: str
    algorithm_version: str
    config: Dict[str, Any]
    dynamic: DynamicCounts
    selection: Dict[str, List[TokenPayload]]
    steps: List[LessonStep]
    notes: Dict[str, Any] = {}


# ---------------------------------------------------------------------------
# Answer submission
# ---------------------------------------------------------------------------

class AnswerRequest(BaseModel):
    step_index: int
    step_type: str
    token_id: str
    answer: Dict[str, Any] = Field(
        ...,
        description="selected_option for MCQ, ordered_token_ids for assembly",
    )
    telemetry: Dict[str, Any] = Field(
        default_factory=dict,
        description="latency_ms, attempt_count, client_ts",
    )


class AnswerResponse(BaseModel):
    step_index: int
    is_correct: bool
    outcome_bucket: str
    feedback: Dict[str, str] = {}
    progress_update: Optional[Dict[str, Any]] = None


# ---------------------------------------------------------------------------
# Lesson completion
# ---------------------------------------------------------------------------

class LessonCompleteRequest(BaseModel):
    completed_at: Optional[str] = None


class LessonSummary(BaseModel):
    lesson_id: str
    steps_done: int
    accuracy: float
    new_concepts_learned: int
    reviews_done: int
    ayah_tasks_done: int


class LessonCompleteResponse(BaseModel):
    summary: LessonSummary
    engagement: Dict[str, Any] = {}


# ---------------------------------------------------------------------------
# Progress
# ---------------------------------------------------------------------------

class ProgressSummary(BaseModel):
    total_tokens: int
    by_state: Dict[str, int]
    due_count: int
    weak_concepts: List[str] = []


class DueToken(BaseModel):
    token_id: str
    concept_key: str
    state: str
    stability: float
    next_review_at: Optional[str] = None
    due_score: float = 0.0


# ---------------------------------------------------------------------------
# Engagement
# ---------------------------------------------------------------------------

class EngagementSummary(BaseModel):
    current_streak_days: int
    best_streak_days: int
    lessons_completed_total: int
    days_active_30d: int
    last_active_at: Optional[str] = None
