"""
Comprehensive SRS test scenarios:
  1. Lapse: 2+ consecutive wrongs → stability resets, state=lapsed
  2. Due/reinforcement selection at 50+ tokens
  3. Scale: 10-20 lesson cycles → learning→reviewing→mastered curve

Run:
  cd quran-app
  python -m tests.test_srs_scenarios
"""
from __future__ import annotations

import json
import random
import sys
import os
from datetime import datetime, timedelta, timezone
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from engine.srs_engine import (
    TokenProgress, AnswerSignal, update_progress, classify_outcome,
    is_due, due_score, reinforcement_score,
    STATE_NEW, STATE_LEARNING, STATE_REVIEWING, STATE_MASTERED, STATE_LAPSED,
    BUCKET_WRONG, BUCKET_CORRECT, BUCKET_PERFECT_FAST,
    MIN_STABILITY,
)
from engine.user_progress_store import UserProgressStore
from engine.generate_lesson import read_tokens, build_lesson, build_ayah_index, concept_key_for_token

DATASET_PATH = Path(__file__).resolve().parent.parent / "dataset.csv"

results = []


def log(test_name: str, status: str, details: str = ""):
    results.append({"test": test_name, "status": status, "details": details})
    icon = "✅" if status == "PASS" else "❌"
    print(f"  {icon} {test_name}: {details}")


# ═══════════════════════════════════════════════════════════════════════════
# TEST 1: Lapse scenario
# ═══════════════════════════════════════════════════════════════════════════

def test_lapse_scenario():
    print("\n═══ TEST 1: Lapse scenario ═══")
    now = datetime.now(timezone.utc)

    p = TokenProgress(token_id="tok:test:1:1", concept_key="test_word", state=STATE_REVIEWING)
    p.stability = 10.0
    p.total_reviews = 5
    p.total_correct = 4
    p.total_wrong = 1

    stability_before = p.stability

    # Two consecutive wrong answers
    wrong = AnswerSignal(is_correct=False, attempt_count=1, latency_ms=5000)
    update_progress(p, wrong, now)
    log("lapse_first_wrong", "PASS" if p.state == STATE_REVIEWING else "FAIL",
        f"state={p.state} (expected reviewing after 1 wrong), consecutive_wrong={p.consecutive_wrong}")

    update_progress(p, wrong, now + timedelta(seconds=30))

    is_lapsed = p.state == STATE_LAPSED
    stability_dropped = p.stability < stability_before * 0.5
    log("lapse_state_transition", "PASS" if is_lapsed else "FAIL",
        f"state={p.state} (expected lapsed), consecutive_wrong={p.consecutive_wrong}")
    log("lapse_stability_reset", "PASS" if stability_dropped else "FAIL",
        f"stability: {stability_before:.2f} → {p.stability:.2f}")

    # Recovery: correct answer should move out of lapsed
    correct = AnswerSignal(is_correct=True, attempt_count=1, latency_ms=3000)
    update_progress(p, correct, now + timedelta(minutes=5))
    recovered = p.state == STATE_LEARNING
    log("lapse_recovery", "PASS" if recovered else "FAIL",
        f"state={p.state} after correct (expected learning)")


# ═══════════════════════════════════════════════════════════════════════════
# TEST 2: Due/reinforcement selection at 50+ tokens
# ═══════════════════════════════════════════════════════════════════════════

def test_due_reinforcement_at_scale():
    print("\n═══ TEST 2: Due/reinforcement at 50+ tokens ═══")
    now = datetime.now(timezone.utc)

    store = UserProgressStore.__new__(UserProgressStore)
    store.path = Path("__test_progress_50.json")
    store._data = {}

    rng = random.Random(42)

    # Create 60 tokens with varied states
    for i in range(60):
        tid = f"tok:test:{i//10 + 1}:{i}"
        p = store.get_or_create(tid, f"concept_{i % 30}")

        # Simulate some history
        p.state = STATE_LEARNING if i < 40 else STATE_REVIEWING
        p.total_reviews = rng.randint(2, 10)
        p.total_correct = max(1, p.total_reviews - rng.randint(0, 3))
        p.total_wrong = p.total_reviews - p.total_correct
        p.stability = rng.uniform(0.3, 5.0)
        p.difficulty = rng.uniform(0.2, 0.8)

        # Some are overdue, some not
        if i < 30:
            p.next_review_at = (now - timedelta(hours=rng.randint(1, 48))).isoformat()
        else:
            p.next_review_at = (now + timedelta(hours=rng.randint(1, 72))).isoformat()

        p.first_seen_at = (now - timedelta(days=rng.randint(1, 30))).isoformat()
        p.last_seen_at = (now - timedelta(hours=rng.randint(1, 96))).isoformat()

    due_tokens = store.get_due_tokens(now, limit=10)
    log("due_count", "PASS" if len(due_tokens) > 0 else "FAIL",
        f"found {len(due_tokens)} due tokens (expected >0 from 30 overdue)")

    # Verify due tokens are actually overdue
    all_actually_due = all(is_due(p, now) for p in due_tokens)
    log("due_actually_overdue", "PASS" if all_actually_due else "FAIL",
        "all returned tokens are actually overdue")

    # Verify sorted by urgency (descending score)
    scores = [due_score(p, now) for p in due_tokens]
    sorted_correctly = all(scores[i] >= scores[i+1] for i in range(len(scores)-1))
    log("due_sort_order", "PASS" if sorted_correctly else "FAIL",
        f"scores (first 5): {[round(s, 2) for s in scores[:5]]}")

    # Reinforcement
    excluded = {due_tokens[0].token_id} if due_tokens else set()
    blocked_concepts = {due_tokens[0].concept_key} if due_tokens else set()
    reinf = store.get_reinforcement_candidates(excluded, blocked_concepts, limit=5)
    log("reinforcement_count", "PASS" if len(reinf) > 0 else "FAIL",
        f"found {len(reinf)} reinforcement candidates")

    # Verify exclusion works
    reinf_ids = {p.token_id for p in reinf}
    no_overlap = len(reinf_ids & excluded) == 0
    log("reinforcement_exclusion", "PASS" if no_overlap else "FAIL",
        "reinforcement excludes already-selected tokens")

    reinf_concepts = {p.concept_key for p in reinf}
    no_concept_overlap = len(reinf_concepts & blocked_concepts) == 0
    log("reinforcement_concept_block", "PASS" if no_concept_overlap else "FAIL",
        "reinforcement excludes blocked concepts")

    # Verify all reinforcement candidates have errors
    all_have_errors = all(p.total_wrong > 0 for p in reinf)
    log("reinforcement_error_signal", "PASS" if all_have_errors else "FAIL",
        "all reinforcement candidates have total_wrong > 0")

    # Cleanup
    if store.path.exists():
        store.path.unlink()


# ═══════════════════════════════════════════════════════════════════════════
# TEST 3: Scale — 15 lesson cycles, state progression curve
# ═══════════════════════════════════════════════════════════════════════════

def test_scale_progression():
    print("\n--- TEST 3: Scale -- 20 review rounds on 8 tokens ---")

    now = datetime.now(timezone.utc)
    rng = random.Random(42)

    # Create 8 tokens with known concept keys
    token_defs = [
        (f"tok:scale:{i}:1", f"concept_{i}") for i in range(1, 9)
    ]

    store = UserProgressStore.__new__(UserProgressStore)
    store.path = Path("__test_progress_scale.json")
    store._data = {}

    # Initialize all as new
    for tid, ckey in token_defs:
        p = store.get_or_create(tid, ckey)
        p.first_seen_at = now.isoformat()
        p.last_seen_at = now.isoformat()

    num_rounds = 20
    state_history = []

    for r in range(num_rounds):
        round_now = now + timedelta(days=r)
        base_accuracy = min(0.55 + r * 0.02, 0.95)

        for tid, ckey in token_defs:
            is_correct = rng.random() < base_accuracy
            latency = rng.randint(1500, 6000)
            signal = AnswerSignal(
                is_correct=is_correct,
                attempt_count=1,
                latency_ms=latency,
            )
            store.record_answer(tid, signal, concept_key=ckey, now=round_now)

        stats = store.stats()
        state_history.append({
            "round": r + 1,
            "states": dict(stats["by_state"]),
            "accuracy": round(base_accuracy, 2),
        })

    final_stats = store.stats()
    states = final_stats["by_state"]
    total = final_stats["total_tokens"]

    log("scale_total_tokens", "PASS" if total == 8 else "FAIL",
        f"total tokens: {total} (expected 8)")

    reviewing = states.get(STATE_REVIEWING, 0)
    mastered = states.get(STATE_MASTERED, 0)
    advanced = reviewing + mastered
    log("scale_advancement", "PASS" if advanced > 0 else "FAIL",
        f"tokens in reviewing/mastered: {advanced} (reviewing={reviewing}, mastered={mastered})")

    new_count = states.get(STATE_NEW, 0)
    log("scale_not_all_new", "PASS" if new_count == 0 else "FAIL",
        f"new={new_count}/{total}")

    # Check that advanced states grew over time
    early_advanced = sum(
        h["states"].get(STATE_REVIEWING, 0) + h["states"].get(STATE_MASTERED, 0)
        for h in state_history[:7]
    )
    late_advanced = sum(
        h["states"].get(STATE_REVIEWING, 0) + h["states"].get(STATE_MASTERED, 0)
        for h in state_history[13:]
    )
    growing = late_advanced >= early_advanced
    log("scale_growing_curve", "PASS" if growing else "FAIL",
        f"advanced tokens: early(1-7)={early_advanced}, late(14-20)={late_advanced}")

    lapsed = states.get(STATE_LAPSED, 0)
    log("scale_lapse_info", "PASS",
        f"lapsed tokens: {lapsed} (info only)")

    # Show sample token progression
    print("\n  Round-by-round progression:")
    for h in state_history:
        s = h["states"]
        line = (f"    Round {h['round']:2d}: "
                f"new={s.get('new',0)} learning={s.get('learning',0)} "
                f"reviewing={s.get('reviewing',0)} mastered={s.get('mastered',0)} "
                f"lapsed={s.get('lapsed',0)} acc={h['accuracy']}")
        print(line)

    # Print a couple sample records
    print("\n  Sample final token states:")
    for tid, ckey in token_defs[:4]:
        p = store.get(tid)
        print(f"    {tid}: state={p.state} stability={p.stability:.2f}d "
              f"difficulty={p.difficulty:.2f} reviews={p.total_reviews} "
              f"correct={p.total_correct} wrong={p.total_wrong}")

    # Cleanup
    if store.path.exists():
        store.path.unlink()


# ═══════════════════════════════════════════════════════════════════════════
# Runner + results output
# ═══════════════════════════════════════════════════════════════════════════

def main():
    print("=" * 60)
    print("SRS Scenario Tests")
    print("=" * 60)

    test_lapse_scenario()
    test_due_reinforcement_at_scale()
    test_scale_progression()

    # Summary
    passed = sum(1 for r in results if r["status"] == "PASS")
    failed = sum(1 for r in results if r["status"] == "FAIL")

    print(f"\n{'=' * 60}")
    print(f"TOTAL: {passed} passed, {failed} failed, {len(results)} total")
    print(f"{'=' * 60}")

    # Write TEST_RESULTS.md
    output_path = Path(__file__).resolve().parent.parent / "TEST_RESULTS.md"
    lines = [
        "# TEST_RESULTS.md — SRS Scenario Test Results\n",
        f"_Generated: {datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M UTC')}_\n",
        f"\n**Summary: {passed} passed, {failed} failed, {len(results)} total**\n",
        "\n---\n",
    ]

    current_section = ""
    for r in results:
        test_name = r["test"]
        section = test_name.split("_")[0]
        if section != current_section:
            current_section = section
            section_titles = {
                "lapse": "## Test 1: Lapse Scenario",
                "due": "## Test 2: Due/Reinforcement at 50+ Tokens",
                "reinforcement": "## Test 2: Due/Reinforcement (continued)",
                "scale": "## Test 3: Scale — 15 Lesson Cycles",
            }
            title = section_titles.get(section, f"## {section}")
            lines.append(f"\n{title}\n\n")

        icon = "✅" if r["status"] == "PASS" else "❌"
        lines.append(f"- {icon} **{r['test']}**: {r['details']}\n")

    output_path.write_text("".join(lines), encoding="utf-8")
    print(f"\nResults written to: {output_path}")

    return 0 if failed == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
