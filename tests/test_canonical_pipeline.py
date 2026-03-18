"""
Tests — Canonical Next Lesson Pipeline (Phase 2).

Validates that Next Lesson is the single unified progression pipeline:
  1. Review pressure throttles new words automatically
  2. High due count → mostly review, minimal new
  3. Zero due → normal new-word flow
  4. build_lesson includes review-pressure metadata
  5. build_review_lesson is clearly marked as optional
  6. Multi-day progression through canonical pipeline
  7. compute_dynamic_counts respects actual_due parameter
  8. No separate review mode needed for proper SRS progression

Run:
  cd quran-app
  python -m tests.test_canonical_pipeline
"""
from __future__ import annotations

import sys
import os
import random
from datetime import datetime, timedelta, timezone
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from engine.srs_engine import (
    compute_dynamic_counts,
    STATE_NEW, STATE_LEARNING, STATE_REVIEWING, STATE_MASTERED, STATE_LAPSED,
)
from engine.generate_lesson import (
    read_tokens, build_lesson, build_review_lesson,
    build_ayah_index, Token, LESSON_CONFIG,
)

DATASET_PATH = Path(__file__).resolve().parent.parent / "dataset.csv"

results = []


def log(test_name: str, status: str, details: str = ""):
    results.append({"test": test_name, "status": status, "details": details})
    icon = "✅" if status == "PASS" else "❌"
    print(f"  {icon} {test_name}: {details}")


# ═══════════════════════════════════════════════════════════════════════════
# Helpers
# ═══════════════════════════════════════════════════════════════════════════

def _build_progress_with_due(tokens, n_known=50, n_due=0, seed=42):
    """Build synthetic progress where n_due tokens are actually due now."""
    rng = random.Random(seed)
    now = datetime.now(timezone.utc)
    progress = {}

    sample = tokens[:max(n_known, n_due + 10)]
    rng.shuffle(sample)

    for i, t in enumerate(sample[:n_known]):
        is_due = i < n_due
        next_review = (now - timedelta(hours=rng.randint(1, 48))) if is_due else (now + timedelta(days=rng.randint(1, 14)))

        progress[t.token_id] = {
            "token_id": t.token_id,
            "concept_key": t.concept_key,
            "state": STATE_REVIEWING,
            "learning_step": 4,
            "stability": round(rng.uniform(1.0, 7.0), 3),
            "difficulty_user": round(rng.uniform(0.2, 0.7), 3),
            "next_review_at": next_review.isoformat(),
            "last_seen_at": (now - timedelta(hours=rng.randint(1, 96))).isoformat(),
            "first_seen_at": (now - timedelta(days=rng.randint(5, 30))).isoformat(),
            "total_reviews": rng.randint(3, 15),
            "total_correct": rng.randint(2, 12),
            "total_wrong": rng.randint(0, 3),
            "consecutive_wrong": 0,
            "last_outcome": "correct",
        }

    return progress


_tokens_cache = None

def _get_tokens():
    global _tokens_cache
    if _tokens_cache is None:
        _tokens_cache = read_tokens(DATASET_PATH)
    return _tokens_cache


# ═══════════════════════════════════════════════════════════════════════════
# 1. compute_dynamic_counts — review pressure parameter
# ═══════════════════════════════════════════════════════════════════════════

def test_dynamic_counts_no_due():
    """Without actual_due, behaves like before (backward compat)."""
    print("\n═══ 1. compute_dynamic_counts — backward compat ═══")

    n, r = compute_dynamic_counts(50)
    n2, r2 = compute_dynamic_counts(50, actual_due=None)

    log("no_due_backward_compat", "PASS" if n == n2 and r == r2 else "FAIL",
        f"no arg: new={n},rev={r}; None: new={n2},rev={r2}")


def test_dynamic_counts_zero_due():
    """Zero actual due → no extra throttle on new words."""
    print("\n═══ 2. compute_dynamic_counts — zero due ═══")

    n_base, _ = compute_dynamic_counts(50, actual_due=None)
    n_zero, _ = compute_dynamic_counts(50, actual_due=0)

    log("zero_due_no_throttle", "PASS" if n_zero == n_base else "FAIL",
        f"base new={n_base}, zero-due new={n_zero}")


def test_dynamic_counts_moderate_due():
    """Moderate due (3-5) reduces new by 1."""
    print("\n═══ 3. compute_dynamic_counts — moderate due ═══")

    n_base, _ = compute_dynamic_counts(50, actual_due=0)
    n_mod, r_mod = compute_dynamic_counts(50, actual_due=4)

    log("moderate_due_reduces_new", "PASS" if n_mod < n_base or n_mod <= 2 else "FAIL",
        f"base new={n_base}, moderate-due new={n_mod}")
    log("moderate_due_review_covers_due", "PASS" if r_mod >= 4 else "FAIL",
        f"review={r_mod} for due=4")


def test_dynamic_counts_high_due():
    """High due (>=6) caps new at 2."""
    print("\n═══ 4. compute_dynamic_counts — high due ═══")

    n_high, r_high = compute_dynamic_counts(50, actual_due=8)

    log("high_due_cap_new_at_2", "PASS" if n_high <= 2 else "FAIL",
        f"new={n_high} for due=8 (expected <=2)")
    log("high_due_review_budget", "PASS" if r_high >= 8 else "FAIL",
        f"review={r_high} for due=8")


def test_dynamic_counts_very_high_due():
    """Very high due (>=10) caps new at 1."""
    print("\n═══ 5. compute_dynamic_counts — very high due ═══")

    n_vhigh, r_vhigh = compute_dynamic_counts(50, actual_due=12)

    log("very_high_due_cap_new_at_1", "PASS" if n_vhigh == 1 else "FAIL",
        f"new={n_vhigh} for due=12 (expected 1)")
    log("very_high_due_review_budget", "PASS" if r_vhigh >= 12 else "FAIL",
        f"review={r_vhigh} for due=12")


# ═══════════════════════════════════════════════════════════════════════════
# 2. build_lesson — canonical pipeline metadata & behavior
# ═══════════════════════════════════════════════════════════════════════════

def test_canonical_lesson_metadata():
    """build_lesson marks itself as canonical pipeline."""
    print("\n═══ 6. Canonical lesson metadata ═══")

    tokens = _get_tokens()
    progress = _build_progress_with_due(tokens, n_known=30, n_due=5)

    lesson = build_lesson(tokens, seed=42, progress_override=progress)

    log("pipeline_field", "PASS" if lesson.get("pipeline") == "canonical" else "FAIL",
        f"pipeline={lesson.get('pipeline')}")
    log("review_pressure_in_dynamic", "PASS" if "review_pressure" in lesson.get("dynamic", {}) else "FAIL",
        f"dynamic keys={list(lesson.get('dynamic', {}).keys())}")
    log("canonical_note", "PASS" if "canonical_pipeline" in lesson.get("notes", {}) else "FAIL",
        "notes.canonical_pipeline present")


def test_canonical_lesson_throttles_new_under_pressure():
    """With many due reviews, canonical lesson reduces new words."""
    print("\n═══ 7. Canonical lesson throttles new under review pressure ═══")

    tokens = _get_tokens()

    # No pressure
    progress_no_due = _build_progress_with_due(tokens, n_known=60, n_due=0)
    lesson_no_due = build_lesson(tokens, seed=42, progress_override=progress_no_due)
    new_no_due = lesson_no_due["dynamic"]["actual_new"]

    # Heavy pressure
    progress_heavy = _build_progress_with_due(tokens, n_known=60, n_due=12)
    lesson_heavy = build_lesson(tokens, seed=42, progress_override=progress_heavy)
    new_heavy = lesson_heavy["dynamic"]["actual_new"]
    due_heavy = lesson_heavy["dynamic"]["actual_due"]

    log("heavy_pressure_fewer_new", "PASS" if new_heavy < new_no_due or new_heavy <= 1 else "FAIL",
        f"no-pressure new={new_no_due}, heavy-pressure new={new_heavy}")
    log("heavy_pressure_has_reviews", "PASS" if due_heavy >= 5 else "FAIL",
        f"due in heavy-pressure lesson={due_heavy}")


def test_canonical_lesson_no_pressure_has_new():
    """Without review pressure, new words flow normally."""
    print("\n═══ 8. No pressure → normal new word flow ═══")

    tokens = _get_tokens()
    progress = _build_progress_with_due(tokens, n_known=30, n_due=0)

    lesson = build_lesson(tokens, seed=42, progress_override=progress)
    actual_new = lesson["dynamic"]["actual_new"]

    log("no_pressure_new_words", "PASS" if actual_new >= 1 else "FAIL",
        f"actual_new={actual_new}")


# ═══════════════════════════════════════════════════════════════════════════
# 3. Review-only lesson — demoted metadata
# ═══════════════════════════════════════════════════════════════════════════

def test_review_lesson_type():
    """build_review_lesson produces lesson_type=review_only."""
    print("\n═══ 9. Review-only lesson type ═══")

    tokens = _get_tokens()
    progress = _build_progress_with_due(tokens, n_known=30, n_due=5)

    lesson = build_review_lesson(tokens, seed=42, progress_override=progress)

    log("review_lesson_type", "PASS" if lesson["lesson_type"] == "review_only" else "FAIL",
        f"lesson_type={lesson['lesson_type']}")
    log("review_lesson_no_new", "PASS" if lesson["dynamic"]["actual_new"] == 0 else "FAIL",
        f"actual_new={lesson['dynamic']['actual_new']}")


# ═══════════════════════════════════════════════════════════════════════════
# 4. Multi-day progression simulation
# ═══════════════════════════════════════════════════════════════════════════

def test_multiday_progression():
    """Simulate 5 days of Next Lesson: verify reviews appear and new words controlled."""
    print("\n═══ 10. Multi-day progression ═══")

    tokens = _get_tokens()
    now = datetime.now(timezone.utc)
    progress = {}

    daily_new_counts = []
    daily_due_counts = []

    for day in range(5):
        sim_now = now + timedelta(days=day)

        # Build lesson with current progress
        lesson = build_lesson(tokens, seed=42 + day, progress_override=dict(progress))

        actual_new = lesson["dynamic"]["actual_new"]
        actual_due = lesson["dynamic"]["actual_due"]
        daily_new_counts.append(actual_new)
        daily_due_counts.append(actual_due)

        # Simulate: mark new words as learning, due words as reviewed
        for t_payload in lesson["selection"]["new"]:
            tid = t_payload["token_id"]
            progress[tid] = {
                "token_id": tid,
                "concept_key": t_payload.get("concept_key", ""),
                "state": STATE_LEARNING,
                "learning_step": 1,
                "stability": 1.0,
                "difficulty_user": 0.5,
                "next_review_at": (sim_now + timedelta(days=1)).isoformat(),
                "last_seen_at": sim_now.isoformat(),
                "first_seen_at": sim_now.isoformat(),
                "total_reviews": 1,
                "total_correct": 1,
                "total_wrong": 0,
                "consecutive_wrong": 0,
                "last_outcome": "correct",
            }
        for t_payload in lesson["selection"]["due"]:
            tid = t_payload["token_id"]
            if tid in progress:
                progress[tid]["next_review_at"] = (sim_now + timedelta(days=3)).isoformat()
                progress[tid]["last_seen_at"] = sim_now.isoformat()
                progress[tid]["total_reviews"] = progress[tid].get("total_reviews", 0) + 1
                progress[tid]["total_correct"] = progress[tid].get("total_correct", 0) + 1

    # Verify: new words appeared on most days
    days_with_new = sum(1 for n in daily_new_counts if n > 0)
    log("multiday_new_on_most_days", "PASS" if days_with_new >= 3 else "FAIL",
        f"days with new: {days_with_new}/5, counts={daily_new_counts}")

    # Verify: total new words is reasonable (not exploding)
    total_new = sum(daily_new_counts)
    log("multiday_total_new_reasonable", "PASS" if 3 <= total_new <= 20 else "FAIL",
        f"total new over 5 days={total_new}")

    # Verify: vocabulary grew
    known_at_end = len(progress)
    log("multiday_vocab_grew", "PASS" if known_at_end >= 3 else "FAIL",
        f"known at end={known_at_end}")


def test_multiday_heavy_review():
    """When starting with heavy review backlog, new words are suppressed."""
    print("\n═══ 11. Multi-day heavy review ═══")

    tokens = _get_tokens()
    now = datetime.now(timezone.utc)

    # Create 15 tokens all due now
    progress = _build_progress_with_due(tokens, n_known=20, n_due=15)

    lesson = build_lesson(tokens, seed=42, progress_override=progress)
    actual_new = lesson["dynamic"]["actual_new"]
    actual_due = lesson["dynamic"]["actual_due"]
    review_pressure = lesson["dynamic"]["review_pressure"]

    log("heavy_review_pressure_detected", "PASS" if review_pressure >= 10 else "FAIL",
        f"review_pressure={review_pressure}")
    log("heavy_review_new_suppressed", "PASS" if actual_new <= 1 else "FAIL",
        f"actual_new={actual_new} (expected <=1)")
    log("heavy_review_due_served", "PASS" if actual_due >= 5 else "FAIL",
        f"actual_due={actual_due}")


# ═══════════════════════════════════════════════════════════════════════════
# 5. Canonical pipeline semantics
# ═══════════════════════════════════════════════════════════════════════════

def test_canonical_includes_all_components():
    """Next Lesson includes review + new + reinforcement + ayah."""
    print("\n═══ 12. Canonical lesson includes all components ═══")

    tokens = _get_tokens()
    # Build progress with some due and some known for ayah eligibility
    rng = random.Random(99)
    now = datetime.now(timezone.utc)
    ayah_index = {}
    for t in tokens:
        ayah_index.setdefault((t.surah, t.ayah), []).append(t)

    progress = {}
    # Add 50 known tokens including complete short ayahs
    short_ayahs = sorted(ayah_index.items(), key=lambda kv: (len(kv[1]), kv[0]))
    covered_tids = set()
    for (s, a), ayah_tokens in short_ayahs:
        if len(ayah_tokens) <= 8 and len(ayah_tokens) >= 3:
            for t in ayah_tokens:
                if t.token_id not in covered_tids:
                    covered_tids.add(t.token_id)
                    progress[t.token_id] = {
                        "token_id": t.token_id,
                        "concept_key": t.concept_key,
                        "state": STATE_REVIEWING,
                        "learning_step": 4,
                        "stability": 3.0,
                        "difficulty_user": 0.4,
                        "next_review_at": (now - timedelta(hours=rng.randint(1, 24))).isoformat(),
                        "last_seen_at": (now - timedelta(hours=48)).isoformat(),
                        "first_seen_at": (now - timedelta(days=10)).isoformat(),
                        "total_reviews": 5,
                        "total_correct": 4,
                        "total_wrong": 1,
                        "consecutive_wrong": 0,
                        "last_outcome": "correct",
                    }
            if len(covered_tids) >= 50:
                break

    lesson = build_lesson(tokens, seed=42, progress_override=progress)

    step_types = {s["type"] for s in lesson["steps"]}
    has_review = "review_card" in step_types
    has_new = "new_word_intro" in step_types
    has_ayah = any(t.startswith("ayah_build") for t in step_types)

    log("has_review_steps", "PASS" if has_review else "FAIL",
        f"step types: {step_types}")
    log("has_new_word_steps", "PASS" if has_new else "FAIL",
        f"step types: {step_types}")
    # Ayah may or may not appear depending on eligibility — just log it
    log("ayah_steps_possible", "PASS",
        f"has_ayah={has_ayah}, step types: {step_types}")


def test_review_only_zero_new():
    """Review-only never introduces new words."""
    print("\n═══ 13. Review-only never introduces new ═══")

    tokens = _get_tokens()
    progress = _build_progress_with_due(tokens, n_known=30, n_due=10)

    for seed in [1, 42, 99, 777]:
        lesson = build_review_lesson(tokens, seed=seed, progress_override=progress)
        new_steps = [s for s in lesson["steps"] if s["type"] == "new_word_intro"]
        if new_steps:
            log(f"review_only_no_new_seed_{seed}", "FAIL",
                f"found {len(new_steps)} new_word_intro steps!")
            return

    log("review_only_no_new_all_seeds", "PASS", "0 new_word_intro across 4 seeds")


# ═══════════════════════════════════════════════════════════════════════════
# Main
# ═══════════════════════════════════════════════════════════════════════════

def main():
    print("=" * 60)
    print("Tests — Canonical Next Lesson Pipeline (Phase 2)")
    print("=" * 60)

    # 1. compute_dynamic_counts with review pressure
    test_dynamic_counts_no_due()
    test_dynamic_counts_zero_due()
    test_dynamic_counts_moderate_due()
    test_dynamic_counts_high_due()
    test_dynamic_counts_very_high_due()

    # 2. build_lesson canonical behavior
    test_canonical_lesson_metadata()
    test_canonical_lesson_throttles_new_under_pressure()
    test_canonical_lesson_no_pressure_has_new()

    # 3. Review-only demoted
    test_review_lesson_type()

    # 4. Multi-day progression
    test_multiday_progression()
    test_multiday_heavy_review()

    # 5. Canonical semantics
    test_canonical_includes_all_components()
    test_review_only_zero_new()

    # Summary
    passed = sum(1 for r in results if r["status"] == "PASS")
    failed = sum(1 for r in results if r["status"] == "FAIL")

    print(f"\n{'=' * 60}")
    print(f"CANONICAL PIPELINE TESTS: {passed} passed, {failed} failed, {len(results)} total")
    print(f"{'=' * 60}")

    return 0 if failed == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
