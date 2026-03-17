"""
Implicit SRS Engine — Quran Learning App (Phase B sandbox).

No manual grading buttons (Again/Hard/Good/Easy).
Intervals are computed from implicit signals:
  - is_correct
  - attempt_count
  - latency_ms
  - hint_used

Algorithm: simplified FSRS-like with stability/difficulty model.
Includes:
  - Graduated learning steps (4h → 1d → 3d → 7d)
  - Next-day priority for fresh words
  - Early review boost for under-reviewed words
  - Mastered words still appear (rarely)
"""
from __future__ import annotations

from dataclasses import dataclass, field, asdict
from datetime import datetime, timedelta, timezone
from typing import Dict, Optional
import math


# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------

# State machine
STATE_NEW = "new"
STATE_LEARNING = "learning"
STATE_REVIEWING = "reviewing"
STATE_MASTERED = "mastered"
STATE_LAPSED = "lapsed"

# Graduated learning steps (in days).
# A word must pass each step with a correct answer to advance.
# After completing all steps → state = reviewing.
LEARNING_STEPS_DAYS = [0.17, 1.0, 3.0, 7.0]  # ~4h, 1d, 3d, 7d

# Initial values
INITIAL_STABILITY = 0.17        # days (~4 hours, = first learning step)
INITIAL_DIFFICULTY = 0.5        # 0..1 scale
MIN_STABILITY = 0.1
MAX_STABILITY = 90.0            # mastered ceiling: max 90 days between reviews
MIN_DIFFICULTY = 0.05
MAX_DIFFICULTY = 0.95

# Outcome buckets (derived from signals)
BUCKET_PERFECT_FAST = "perfect_fast"     # correct, 1 attempt, fast
BUCKET_CORRECT = "correct"               # correct, 1 attempt, normal speed
BUCKET_CORRECT_SLOW = "correct_slow"     # correct, 1 attempt, slow
BUCKET_CORRECT_RETRY = "correct_retry"   # correct, >1 attempts
BUCKET_HINT_USED = "hint_used"           # used hint
BUCKET_WRONG = "wrong"                   # incorrect

# Latency thresholds (ms) — calibrated for single-word MCQ
FAST_THRESHOLD_MS = 2000
SLOW_THRESHOLD_MS = 8000

# Stability multipliers per outcome bucket
STABILITY_MULTIPLIERS = {
    BUCKET_PERFECT_FAST: 2.5,
    BUCKET_CORRECT: 2.0,
    BUCKET_CORRECT_SLOW: 1.6,
    BUCKET_CORRECT_RETRY: 1.2,
    BUCKET_HINT_USED: 0.8,
    BUCKET_WRONG: 0.4,
}

# Difficulty adjustments per outcome bucket (additive)
DIFFICULTY_DELTAS = {
    BUCKET_PERFECT_FAST: -0.08,
    BUCKET_CORRECT: -0.03,
    BUCKET_CORRECT_SLOW: 0.0,
    BUCKET_CORRECT_RETRY: +0.05,
    BUCKET_HINT_USED: +0.08,
    BUCKET_WRONG: +0.12,
}

# State transition thresholds
MASTERED_STABILITY_THRESHOLD = 21.0   # days — enter mastered state
LAPSE_WRONG_STREAK = 2                # consecutive wrongs to lapse

# Early review boost: words with <= this many reviews get priority scoring
EARLY_REVIEW_THRESHOLD = 4
EARLY_REVIEW_BOOST = 50.0             # additive score bonus


# ---------------------------------------------------------------------------
# Data structures
# ---------------------------------------------------------------------------

@dataclass
class TokenProgress:
    """Per-token SRS progress record."""
    token_id: str
    concept_key: str = ""
    state: str = STATE_NEW
    stability: float = INITIAL_STABILITY
    difficulty: float = INITIAL_DIFFICULTY
    learning_step: int = 0                     # index into LEARNING_STEPS_DAYS
    next_review_at: Optional[str] = None       # ISO-8601
    last_seen_at: Optional[str] = None
    first_seen_at: Optional[str] = None
    total_reviews: int = 0
    total_correct: int = 0
    total_wrong: int = 0
    consecutive_wrong: int = 0
    last_outcome_bucket: str = ""
    last_latency_ms: Optional[int] = None

    def to_dict(self) -> Dict:
        return asdict(self)

    @staticmethod
    def from_dict(d: Dict) -> "TokenProgress":
        known = {k for k in TokenProgress.__dataclass_fields__}
        return TokenProgress(**{k: v for k, v in d.items() if k in known})


@dataclass
class AnswerSignal:
    """Implicit signals from a single answer event."""
    is_correct: bool
    attempt_count: int = 1
    latency_ms: int = 4000
    hint_used: bool = False


# ---------------------------------------------------------------------------
# Core SRS logic
# ---------------------------------------------------------------------------

def classify_outcome(signal: AnswerSignal) -> str:
    """Map raw signals to an outcome bucket."""
    if signal.hint_used:
        return BUCKET_HINT_USED
    if not signal.is_correct:
        return BUCKET_WRONG
    if signal.attempt_count > 1:
        return BUCKET_CORRECT_RETRY
    if signal.latency_ms < FAST_THRESHOLD_MS:
        return BUCKET_PERFECT_FAST
    if signal.latency_ms > SLOW_THRESHOLD_MS:
        return BUCKET_CORRECT_SLOW
    return BUCKET_CORRECT


def _clamp(value: float, lo: float, hi: float) -> float:
    return max(lo, min(hi, value))


def _next_learning_step_interval(step: int) -> float:
    """Return the interval in days for the given learning step index."""
    if step < len(LEARNING_STEPS_DAYS):
        return LEARNING_STEPS_DAYS[step]
    return LEARNING_STEPS_DAYS[-1]


def compute_next_review(stability: float, now: datetime) -> datetime:
    """Schedule next review based on current stability (in days)."""
    interval_days = max(0.01, stability)
    return now + timedelta(days=interval_days)


def update_progress(
    progress: TokenProgress,
    signal: AnswerSignal,
    now: datetime | None = None,
) -> TokenProgress:
    """
    Update a TokenProgress record after an answer event.

    Mutates and returns the same object.
    """
    if now is None:
        now = datetime.now(timezone.utc)

    now_iso = now.isoformat()
    bucket = classify_outcome(signal)

    # --- First-seen tracking ---
    if progress.first_seen_at is None:
        progress.first_seen_at = now_iso
    progress.last_seen_at = now_iso

    # --- Counters ---
    progress.total_reviews += 1
    if signal.is_correct:
        progress.total_correct += 1
        progress.consecutive_wrong = 0
    else:
        progress.total_wrong += 1
        progress.consecutive_wrong += 1

    progress.last_outcome_bucket = bucket
    progress.last_latency_ms = signal.latency_ms

    # --- Difficulty update ---
    delta = DIFFICULTY_DELTAS.get(bucket, 0.0)
    progress.difficulty = _clamp(progress.difficulty + delta, MIN_DIFFICULTY, MAX_DIFFICULTY)

    # --- State transitions & stability ---

    # NEW → LEARNING on first answer
    if progress.state == STATE_NEW:
        progress.state = STATE_LEARNING
        progress.learning_step = 0

    # LAPSE detection (before learning step logic)
    if progress.consecutive_wrong >= LAPSE_WRONG_STREAK and progress.state in {STATE_REVIEWING, STATE_MASTERED}:
        progress.state = STATE_LAPSED
        progress.stability = max(MIN_STABILITY, progress.stability * 0.3)
        progress.learning_step = 0  # restart graduated steps

    # LAPSE recovery
    if progress.state == STATE_LAPSED and signal.is_correct:
        progress.state = STATE_LEARNING
        progress.learning_step = 0

    # LEARNING: graduated steps
    if progress.state == STATE_LEARNING:
        if signal.is_correct:
            progress.learning_step += 1
            # Set stability to the next step interval
            progress.stability = _next_learning_step_interval(progress.learning_step)

            # Graduated to reviewing after all steps
            if progress.learning_step >= len(LEARNING_STEPS_DAYS):
                progress.state = STATE_REVIEWING
                progress.stability = LEARNING_STEPS_DAYS[-1]  # start reviewing at 7d
        else:
            # Wrong answer in learning: reset step (but not to 0, go back 1)
            progress.learning_step = max(0, progress.learning_step - 1)
            progress.stability = _next_learning_step_interval(progress.learning_step)

    # REVIEWING / MASTERED: standard stability update
    elif progress.state in {STATE_REVIEWING, STATE_MASTERED}:
        multiplier = STABILITY_MULTIPLIERS.get(bucket, 1.0)
        difficulty_factor = 1.0 - 0.3 * progress.difficulty
        new_stability = progress.stability * multiplier * difficulty_factor
        progress.stability = _clamp(new_stability, MIN_STABILITY, MAX_STABILITY)

        # REVIEWING → MASTERED
        if progress.state == STATE_REVIEWING and progress.stability >= MASTERED_STABILITY_THRESHOLD:
            progress.state = STATE_MASTERED

    # --- Next review ---
    progress.next_review_at = compute_next_review(progress.stability, now).isoformat()

    return progress


# ---------------------------------------------------------------------------
# Due / reinforcement / fresh queries
# ---------------------------------------------------------------------------

def is_due(progress: TokenProgress, now: datetime) -> bool:
    """Check if a token is due for review."""
    if progress.state == STATE_NEW:
        return False
    if progress.next_review_at is None:
        return True
    next_review = datetime.fromisoformat(progress.next_review_at)
    return next_review <= now


def is_fresh(progress: TokenProgress, now: datetime, window_days: float = 2.0) -> bool:
    """Check if token was first seen within `window_days` and has few reviews.

    Fresh tokens get next-day priority scheduling.
    """
    if progress.first_seen_at is None:
        return False
    first_seen = datetime.fromisoformat(progress.first_seen_at)
    age_days = (now - first_seen).total_seconds() / 86400
    return age_days <= window_days and progress.total_reviews <= 3


def due_score(progress: TokenProgress, now: datetime) -> float:
    """Score for due priority (higher = more urgent).

    Includes:
    - Overdue time
    - Error rate
    - Difficulty
    - Early review boost (words with few reviews)
    - Next-day fresh boost
    """
    if progress.next_review_at is None:
        return 100.0
    next_review = datetime.fromisoformat(progress.next_review_at)
    overdue_hours = max(0.0, (now - next_review).total_seconds() / 3600)
    wrong_rate = progress.total_wrong / max(1, progress.total_reviews)

    score = overdue_hours * 1.2 + wrong_rate * 3.0 + progress.difficulty

    # Early review boost: under-reviewed words get priority
    if progress.total_reviews <= EARLY_REVIEW_THRESHOLD:
        score += EARLY_REVIEW_BOOST * (1.0 - progress.total_reviews / (EARLY_REVIEW_THRESHOLD + 1))

    # Next-day fresh boost
    if is_fresh(progress, now):
        score += 30.0

    return score


def reinforcement_score(progress: TokenProgress) -> float:
    """Score for reinforcement priority (higher = weaker / more urgent)."""
    if progress.total_reviews <= 0:
        return 0.0
    wrong_rate = progress.total_wrong / max(1, progress.total_reviews)
    recency_penalty = 1.0 if progress.consecutive_wrong > 0 else 0.0
    return wrong_rate * 3.0 + progress.difficulty * 2.0 + recency_penalty


# ---------------------------------------------------------------------------
# Dynamic new/review ratio
# ---------------------------------------------------------------------------

def compute_dynamic_counts(
    total_known_words: int,
    target_steps: int = 14,
    base_new: int = 3,
    base_review: int = 15,
) -> tuple[int, int]:
    """Compute (new_count, review_count) based on how many words user knows.

    Ramp schedule:
      0-10 known words  → ratio ~1:1 (learn fast at start)
      10-30             → ratio ~2:1
      30-60             → ratio ~3:1
      60+               → ratio 5:1 (standard)

    Returns (new_count, review_count) that together fit ~target_steps.
    """
    if total_known_words <= 10:
        ratio = 1.0
    elif total_known_words <= 30:
        # Linear ramp from 1.0 to 2.0
        t = (total_known_words - 10) / 20
        ratio = 1.0 + t * 1.0
    elif total_known_words <= 60:
        # Linear ramp from 2.0 to 4.0
        t = (total_known_words - 30) / 30
        ratio = 2.0 + t * 2.0
    else:
        ratio = 5.0

    # Each new word generates ~3 steps (intro + MCQ + audio + delayed recall = ~4,
    # but some are shared). Approximate: new_word_steps ≈ 4, review_step ≈ 1.
    # Solve: new * 4 + review * 1 ≈ target_steps, review/new ≈ ratio
    # → new * 4 + new * ratio ≈ target_steps
    # → new ≈ target_steps / (4 + ratio)
    new_count = max(1, round(target_steps / (4 + ratio)))
    review_count = max(1, round(new_count * ratio))

    # Clamp to reasonable bounds
    new_count = min(new_count, base_new + 2)
    review_count = min(review_count, base_review)

    return new_count, review_count
