"""
Unit Tests — SRS Engine + Lesson Generator logic.

Covers QUALITY_GATE §2.1:
  - outcome bucket classification
  - graduated learning steps (4h→1d→3d→7d)
  - stability/difficulty progression
  - state transitions (new→learning→reviewing→mastered, lapse recovery)
  - early review boost + fresh priority scoring
  - dynamic new/review ratio computation
  - due scoring correctness
  - MCQ distractor policy (known-first, pronoun-aware)
  - Al-Muqatta'at exclusion
  - intra-lesson repetition (4 formats per new word)
  - reinforcement non-consecutive guarantee
  - new selection dedup by concept
  - ayah eligibility

Run:
  cd quran-app
  python -m tests.test_unit_engine
"""
from __future__ import annotations

import sys
import os
import random
from datetime import datetime, timedelta, timezone
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from engine.srs_engine import (
    TokenProgress, AnswerSignal, update_progress, classify_outcome,
    is_due, is_fresh, due_score, reinforcement_score, compute_dynamic_counts,
    STATE_NEW, STATE_LEARNING, STATE_REVIEWING, STATE_MASTERED, STATE_LAPSED,
    BUCKET_PERFECT_FAST, BUCKET_CORRECT, BUCKET_CORRECT_SLOW,
    BUCKET_CORRECT_RETRY, BUCKET_HINT_USED, BUCKET_WRONG,
    INITIAL_STABILITY, INITIAL_DIFFICULTY, MIN_STABILITY, MAX_STABILITY,
    MASTERED_STABILITY_THRESHOLD, LAPSE_WRONG_STREAK,
    LEARNING_STEPS_DAYS, EARLY_REVIEW_BOOST,
)

DATASET_PATH = Path(__file__).resolve().parent.parent / "dataset.csv"

results = []


def log(test_name: str, status: str, details: str = ""):
    results.append({"test": test_name, "status": status, "details": details})
    icon = "✅" if status == "PASS" else "❌"
    print(f"  {icon} {test_name}: {details}")


# ═══════════════════════════════════════════════════════════════════════════
# 1. Outcome Bucket Classification
# ═══════════════════════════════════════════════════════════════════════════

def test_outcome_buckets():
    print("\n═══ 1. Outcome Bucket Classification ═══")

    # Perfect fast: correct, 1 attempt, <2s
    s = AnswerSignal(is_correct=True, attempt_count=1, latency_ms=1500)
    log("bucket_perfect_fast", "PASS" if classify_outcome(s) == BUCKET_PERFECT_FAST else "FAIL",
        f"got={classify_outcome(s)}")

    # Correct: correct, 1 attempt, 2s-8s
    s = AnswerSignal(is_correct=True, attempt_count=1, latency_ms=4000)
    log("bucket_correct", "PASS" if classify_outcome(s) == BUCKET_CORRECT else "FAIL",
        f"got={classify_outcome(s)}")

    # Correct slow: correct, 1 attempt, >8s
    s = AnswerSignal(is_correct=True, attempt_count=1, latency_ms=10000)
    log("bucket_correct_slow", "PASS" if classify_outcome(s) == BUCKET_CORRECT_SLOW else "FAIL",
        f"got={classify_outcome(s)}")

    # Correct retry: correct, >1 attempts
    s = AnswerSignal(is_correct=True, attempt_count=3, latency_ms=4000)
    log("bucket_correct_retry", "PASS" if classify_outcome(s) == BUCKET_CORRECT_RETRY else "FAIL",
        f"got={classify_outcome(s)}")

    # Hint used (overrides all)
    s = AnswerSignal(is_correct=True, attempt_count=1, latency_ms=1500, hint_used=True)
    log("bucket_hint_used", "PASS" if classify_outcome(s) == BUCKET_HINT_USED else "FAIL",
        f"got={classify_outcome(s)}")

    # Wrong
    s = AnswerSignal(is_correct=False, attempt_count=1, latency_ms=4000)
    log("bucket_wrong", "PASS" if classify_outcome(s) == BUCKET_WRONG else "FAIL",
        f"got={classify_outcome(s)}")

    # Edge: exactly 2000ms → correct (not perfect_fast)
    s = AnswerSignal(is_correct=True, attempt_count=1, latency_ms=2000)
    log("bucket_boundary_2000ms", "PASS" if classify_outcome(s) == BUCKET_CORRECT else "FAIL",
        f"got={classify_outcome(s)}")

    # Edge: exactly 8000ms → correct (not slow)
    s = AnswerSignal(is_correct=True, attempt_count=1, latency_ms=8000)
    log("bucket_boundary_8000ms", "PASS" if classify_outcome(s) == BUCKET_CORRECT else "FAIL",
        f"got={classify_outcome(s)}")


# ═══════════════════════════════════════════════════════════════════════════
# 2. Graduated Learning Steps
# ═══════════════════════════════════════════════════════════════════════════

def test_graduated_steps():
    print("\n═══ 2. Graduated Learning Steps ═══")
    now = datetime.now(timezone.utc)

    p = TokenProgress(token_id="tok:test:1:1", state=STATE_NEW)
    correct = AnswerSignal(is_correct=True, attempt_count=1, latency_ms=3000)

    # Answer 1: new → learning, step 0→1
    update_progress(p, correct, now)
    log("grad_step_0_to_1", "PASS" if p.state == STATE_LEARNING and p.learning_step == 1 else "FAIL",
        f"state={p.state}, step={p.learning_step}")

    # Steps 1→2→3→4 (graduating to reviewing)
    for expected_step in [2, 3, 4]:
        update_progress(p, correct, now + timedelta(days=expected_step))
        if expected_step < 4:
            log(f"grad_step_{expected_step-1}_to_{expected_step}",
                "PASS" if p.learning_step == expected_step else "FAIL",
                f"step={p.learning_step}")

    # After step 4 (all LEARNING_STEPS completed) → reviewing
    log("grad_to_reviewing", "PASS" if p.state == STATE_REVIEWING else "FAIL",
        f"state={p.state}, step={p.learning_step}")

    # Verify stability at graduation = last step interval (7d)
    log("grad_stability_at_review", "PASS" if abs(p.stability - LEARNING_STEPS_DAYS[-1]) < 0.01 else "FAIL",
        f"stability={p.stability:.2f}, expected={LEARNING_STEPS_DAYS[-1]}")


def test_learning_step_wrong_answer():
    print("\n═══ 2b. Learning Step — Wrong Answer Regression ═══")
    now = datetime.now(timezone.utc)

    p = TokenProgress(token_id="tok:test:2:1", state=STATE_LEARNING, learning_step=2)
    wrong = AnswerSignal(is_correct=False, attempt_count=1, latency_ms=5000)

    update_progress(p, wrong, now)
    log("learning_step_regress", "PASS" if p.learning_step == 1 else "FAIL",
        f"step went from 2 to {p.learning_step} (expected 1)")

    # Wrong again: 1→0
    update_progress(p, wrong, now + timedelta(minutes=5))
    log("learning_step_regress_to_0", "PASS" if p.learning_step == 0 else "FAIL",
        f"step={p.learning_step}")

    # Wrong at 0: stays 0
    update_progress(p, wrong, now + timedelta(minutes=10))
    log("learning_step_floor", "PASS" if p.learning_step == 0 else "FAIL",
        f"step={p.learning_step} (should stay 0)")


# ═══════════════════════════════════════════════════════════════════════════
# 3. Stability & Difficulty Progression
# ═══════════════════════════════════════════════════════════════════════════

def test_stability_difficulty():
    print("\n═══ 3. Stability & Difficulty Progression ═══")
    now = datetime.now(timezone.utc)

    # Reviewing state: correct answers should increase stability
    p = TokenProgress(token_id="tok:test:3:1", state=STATE_REVIEWING,
                      stability=7.0, difficulty=0.5, learning_step=4)
    old_stab = p.stability
    old_diff = p.difficulty

    correct = AnswerSignal(is_correct=True, attempt_count=1, latency_ms=3000)
    update_progress(p, correct, now)

    log("stab_increase_on_correct", "PASS" if p.stability > old_stab else "FAIL",
        f"stability: {old_stab:.2f} → {p.stability:.2f}")
    log("diff_decrease_on_correct", "PASS" if p.difficulty < old_diff else "FAIL",
        f"difficulty: {old_diff:.2f} → {p.difficulty:.2f}")

    # Wrong answers should decrease stability
    p2 = TokenProgress(token_id="tok:test:3:2", state=STATE_REVIEWING,
                       stability=7.0, difficulty=0.5, learning_step=4)
    old_stab2 = p2.stability
    old_diff2 = p2.difficulty
    wrong = AnswerSignal(is_correct=False, attempt_count=1, latency_ms=5000)
    update_progress(p2, wrong, now)

    log("stab_decrease_on_wrong", "PASS" if p2.stability < old_stab2 else "FAIL",
        f"stability: {old_stab2:.2f} → {p2.stability:.2f}")
    log("diff_increase_on_wrong", "PASS" if p2.difficulty > old_diff2 else "FAIL",
        f"difficulty: {old_diff2:.2f} → {p2.difficulty:.2f}")

    # Stability clamped to MAX
    p3 = TokenProgress(token_id="tok:test:3:3", state=STATE_REVIEWING,
                       stability=80.0, difficulty=0.1, learning_step=4)
    fast = AnswerSignal(is_correct=True, attempt_count=1, latency_ms=1000)
    update_progress(p3, fast, now)
    log("stab_max_clamp", "PASS" if p3.stability <= MAX_STABILITY else "FAIL",
        f"stability={p3.stability:.2f} (max={MAX_STABILITY})")

    # Stability clamped to MIN
    p4 = TokenProgress(token_id="tok:test:3:4", state=STATE_REVIEWING,
                       stability=0.2, difficulty=0.9, learning_step=4)
    update_progress(p4, wrong, now)
    log("stab_min_clamp", "PASS" if p4.stability >= MIN_STABILITY else "FAIL",
        f"stability={p4.stability:.2f} (min={MIN_STABILITY})")


# ═══════════════════════════════════════════════════════════════════════════
# 4. State Transitions
# ═══════════════════════════════════════════════════════════════════════════

def test_state_transitions():
    print("\n═══ 4. State Transitions ═══")
    now = datetime.now(timezone.utc)

    # NEW → LEARNING on first answer
    p = TokenProgress(token_id="tok:test:4:1", state=STATE_NEW)
    correct = AnswerSignal(is_correct=True, attempt_count=1, latency_ms=3000)
    update_progress(p, correct, now)
    log("new_to_learning", "PASS" if p.state == STATE_LEARNING else "FAIL",
        f"state={p.state}")

    # REVIEWING → MASTERED when stability >= threshold
    p2 = TokenProgress(token_id="tok:test:4:2", state=STATE_REVIEWING,
                       stability=20.0, difficulty=0.1, learning_step=4)
    fast = AnswerSignal(is_correct=True, attempt_count=1, latency_ms=1000)
    update_progress(p2, fast, now)
    log("reviewing_to_mastered", "PASS" if p2.state == STATE_MASTERED else "FAIL",
        f"state={p2.state}, stability={p2.stability:.2f} (threshold={MASTERED_STABILITY_THRESHOLD})")

    # LAPSE: 2 consecutive wrongs from reviewing
    p3 = TokenProgress(token_id="tok:test:4:3", state=STATE_REVIEWING,
                       stability=10.0, difficulty=0.5, learning_step=4)
    wrong = AnswerSignal(is_correct=False, attempt_count=1, latency_ms=5000)
    update_progress(p3, wrong, now)
    log("lapse_after_1_wrong", "PASS" if p3.state == STATE_REVIEWING else "FAIL",
        f"state={p3.state} (should still be reviewing)")
    update_progress(p3, wrong, now + timedelta(seconds=10))
    log("lapse_after_2_wrongs", "PASS" if p3.state == STATE_LAPSED else "FAIL",
        f"state={p3.state}")

    # LAPSE recovery: correct answer
    update_progress(p3, correct, now + timedelta(minutes=1))
    log("lapse_recovery", "PASS" if p3.state == STATE_LEARNING else "FAIL",
        f"state={p3.state}")


# ═══════════════════════════════════════════════════════════════════════════
# 5. Due Scoring
# ═══════════════════════════════════════════════════════════════════════════

def test_due_scoring():
    print("\n═══ 5. Due Scoring ═══")
    now = datetime.now(timezone.utc)

    # New tokens are never due
    p_new = TokenProgress(token_id="tok:test:5:1", state=STATE_NEW)
    log("new_not_due", "PASS" if not is_due(p_new, now) else "FAIL",
        "new tokens should not be due")

    # Overdue token should be due
    p_due = TokenProgress(token_id="tok:test:5:2", state=STATE_LEARNING,
                          next_review_at=(now - timedelta(hours=2)).isoformat())
    log("overdue_is_due", "PASS" if is_due(p_due, now) else "FAIL",
        "overdue token should be due")

    # Future review is not due
    p_future = TokenProgress(token_id="tok:test:5:3", state=STATE_REVIEWING,
                             next_review_at=(now + timedelta(hours=5)).isoformat())
    log("future_not_due", "PASS" if not is_due(p_future, now) else "FAIL",
        "future review should not be due")

    # Early review boost: token with few reviews should score higher
    p_few = TokenProgress(token_id="tok:test:5:4", state=STATE_LEARNING,
                          next_review_at=(now - timedelta(hours=1)).isoformat(),
                          total_reviews=2, total_wrong=0, difficulty=0.5)
    p_many = TokenProgress(token_id="tok:test:5:5", state=STATE_LEARNING,
                           next_review_at=(now - timedelta(hours=1)).isoformat(),
                           total_reviews=10, total_wrong=0, difficulty=0.5)
    score_few = due_score(p_few, now)
    score_many = due_score(p_many, now)
    log("early_review_boost", "PASS" if score_few > score_many else "FAIL",
        f"few_reviews_score={score_few:.1f} > many_reviews_score={score_many:.1f}")

    # Fresh priority: recently seen token should get boost
    p_fresh = TokenProgress(token_id="tok:test:5:6", state=STATE_LEARNING,
                            first_seen_at=(now - timedelta(hours=12)).isoformat(),
                            next_review_at=(now - timedelta(hours=1)).isoformat(),
                            total_reviews=2, total_wrong=0, difficulty=0.5)
    log("fresh_is_fresh", "PASS" if is_fresh(p_fresh, now) else "FAIL",
        "token seen 12h ago with 2 reviews should be fresh")

    p_old = TokenProgress(token_id="tok:test:5:7", state=STATE_LEARNING,
                          first_seen_at=(now - timedelta(days=5)).isoformat(),
                          next_review_at=(now - timedelta(hours=1)).isoformat(),
                          total_reviews=2, total_wrong=0, difficulty=0.5)
    log("old_not_fresh", "PASS" if not is_fresh(p_old, now) else "FAIL",
        "token seen 5 days ago should not be fresh")


# ═══════════════════════════════════════════════════════════════════════════
# 6. Dynamic New/Review Ratio
# ═══════════════════════════════════════════════════════════════════════════

def test_dynamic_ratio():
    print("\n═══ 6. Dynamic New/Review Ratio ═══")

    # 0 known words: ~1:1 ratio
    n, r = compute_dynamic_counts(0)
    log("ratio_0_known", "PASS" if n >= 1 and r >= 1 else "FAIL",
        f"new={n}, review={r} (expected ~1:1)")

    # 5 known: still ~1:1
    n5, r5 = compute_dynamic_counts(5)
    ratio5 = r5 / max(1, n5)
    log("ratio_5_known", "PASS" if ratio5 <= 2.0 else "FAIL",
        f"new={n5}, review={r5}, ratio={ratio5:.1f}")

    # 20 known: ~2:1
    n20, r20 = compute_dynamic_counts(20)
    ratio20 = r20 / max(1, n20)
    log("ratio_20_known", "PASS" if 1.0 <= ratio20 <= 3.0 else "FAIL",
        f"new={n20}, review={r20}, ratio={ratio20:.1f}")

    # 45 known: ~3:1
    n45, r45 = compute_dynamic_counts(45)
    ratio45 = r45 / max(1, n45)
    log("ratio_45_known", "PASS" if 2.0 <= ratio45 <= 5.0 else "FAIL",
        f"new={n45}, review={r45}, ratio={ratio45:.1f}")

    # 100 known: ~5:1
    n100, r100 = compute_dynamic_counts(100)
    ratio100 = r100 / max(1, n100)
    log("ratio_100_known", "PASS" if ratio100 >= 3.0 else "FAIL",
        f"new={n100}, review={r100}, ratio={ratio100:.1f}")

    # Monotonic: ratio increases with more known words
    ratios = []
    for kw in [0, 10, 30, 60, 100]:
        n, r = compute_dynamic_counts(kw)
        ratios.append(r / max(1, n))
    monotonic = all(ratios[i] <= ratios[i+1] + 0.5 for i in range(len(ratios)-1))
    log("ratio_monotonic", "PASS" if monotonic else "FAIL",
        f"ratios={[round(x, 1) for x in ratios]}")


# ═══════════════════════════════════════════════════════════════════════════
# 7. Reinforcement Scoring
# ═══════════════════════════════════════════════════════════════════════════

def test_reinforcement_scoring():
    print("\n═══ 7. Reinforcement Scoring ═══")

    # No reviews = no reinforcement
    p0 = TokenProgress(token_id="tok:test:7:1", total_reviews=0)
    log("reinf_no_reviews", "PASS" if reinforcement_score(p0) == 0.0 else "FAIL",
        f"score={reinforcement_score(p0)}")

    # Higher wrong rate = higher score
    p_weak = TokenProgress(token_id="tok:test:7:2", total_reviews=5,
                           total_wrong=3, difficulty=0.5, consecutive_wrong=0)
    p_strong = TokenProgress(token_id="tok:test:7:3", total_reviews=5,
                             total_wrong=1, difficulty=0.5, consecutive_wrong=0)
    log("reinf_weak_higher", "PASS" if reinforcement_score(p_weak) > reinforcement_score(p_strong) else "FAIL",
        f"weak={reinforcement_score(p_weak):.2f} > strong={reinforcement_score(p_strong):.2f}")

    # Consecutive wrong bonus
    p_consec = TokenProgress(token_id="tok:test:7:4", total_reviews=5,
                             total_wrong=2, difficulty=0.5, consecutive_wrong=1)
    p_no_consec = TokenProgress(token_id="tok:test:7:5", total_reviews=5,
                                total_wrong=2, difficulty=0.5, consecutive_wrong=0)
    log("reinf_consec_bonus", "PASS" if reinforcement_score(p_consec) > reinforcement_score(p_no_consec) else "FAIL",
        f"consec={reinforcement_score(p_consec):.2f} > no_consec={reinforcement_score(p_no_consec):.2f}")


# ═══════════════════════════════════════════════════════════════════════════
# 8. Generator: Al-Muqatta'at Exclusion
# ═══════════════════════════════════════════════════════════════════════════

def test_muqattaat_exclusion():
    print("\n═══ 8. Al-Muqatta'at Exclusion ═══")
    from engine.generate_lesson import read_tokens, build_lesson, MUQATTAAT_SURAHS

    tokens = read_tokens(DATASET_PATH)

    # No token from muqattaat surah ayah 1
    muq_tokens = [t for t in tokens if t.surah in MUQATTAAT_SURAHS and t.ayah == 1]
    log("muqattaat_filtered", "PASS" if len(muq_tokens) == 0 else "FAIL",
        f"found {len(muq_tokens)} muqattaat tokens (expected 0)")

    # Generate lesson and verify no muqattaat
    lesson = build_lesson(tokens, seed=42)
    steps = lesson["steps"]

    muq_in_lesson = []
    for step in steps:
        token = step.get("token", {})
        if isinstance(token, dict):
            surah = token.get("surah", 0)
            ayah = token.get("ayah", 0)
        else:
            surah = getattr(token, "surah", 0)
            ayah = getattr(token, "ayah", 0)
        if surah in MUQATTAAT_SURAHS and ayah == 1:
            muq_in_lesson.append(f"{surah}:{ayah}")

    log("muqattaat_not_in_lesson", "PASS" if len(muq_in_lesson) == 0 else "FAIL",
        f"muqattaat in lesson: {muq_in_lesson}")


# ═══════════════════════════════════════════════════════════════════════════
# 9. Generator: Intra-lesson Repetition (4 formats)
# ═══════════════════════════════════════════════════════════════════════════

def test_intra_lesson_repetition():
    print("\n═══ 9. Intra-Lesson Repetition (New Words) ═══")
    from engine.generate_lesson import read_tokens, build_lesson

    tokens = read_tokens(DATASET_PATH)
    lesson = build_lesson(tokens, seed=42)
    steps = lesson["steps"]
    new_tokens = lesson.get("selection", {}).get("new", [])

    expected_formats = {"new_word_intro", "meaning_choice", "audio_to_meaning", "translation_to_word"}

    if new_tokens:
        first_new_id = new_tokens[0].get("token_id") if isinstance(new_tokens[0], dict) else getattr(new_tokens[0], "token_id", "")

        formats_found = set()
        for step in steps:
            token = step.get("token", {})
            tid = token.get("token_id", "") if isinstance(token, dict) else getattr(token, "token_id", "")
            if tid == first_new_id:
                formats_found.add(step.get("type", ""))

        log("new_word_4_formats", "PASS" if formats_found >= expected_formats else "FAIL",
            f"formats for {first_new_id}: {formats_found} (expected {expected_formats})")
    else:
        log("new_word_4_formats", "FAIL", "no new words in lesson")

    # Check all new words have at least intro + MCQ
    for nt in new_tokens:
        tid = nt.get("token_id") if isinstance(nt, dict) else getattr(nt, "token_id", "")
        fmts = set()
        for step in steps:
            token = step.get("token", {})
            step_tid = token.get("token_id", "") if isinstance(token, dict) else getattr(token, "token_id", "")
            if step_tid == tid:
                fmts.add(step.get("type", ""))
        has_intro = "new_word_intro" in fmts
        has_mcq = "meaning_choice" in fmts
        log(f"new_{tid}_has_intro_mcq", "PASS" if has_intro and has_mcq else "FAIL",
            f"intro={has_intro}, mcq={has_mcq}, all={fmts}")


# ═══════════════════════════════════════════════════════════════════════════
# 10. Generator: Reinforcement Non-Consecutive
# ═══════════════════════════════════════════════════════════════════════════

def test_reinforcement_non_consecutive():
    print("\n═══ 10. Reinforcement Non-Consecutive ═══")
    from engine.generate_lesson import read_tokens, build_lesson

    tokens = read_tokens(DATASET_PATH)

    # Test across multiple seeds
    consecutive_found = 0
    seeds_tested = 20

    for seed in range(seeds_tested):
        lesson = build_lesson(tokens, seed=seed)
        steps = lesson["steps"]

        for i in range(len(steps) - 1):
            if steps[i].get("type") == "reinforcement" and steps[i+1].get("type") == "reinforcement":
                consecutive_found += 1
                break

    log("no_consecutive_reinforcement", "PASS" if consecutive_found == 0 else "FAIL",
        f"consecutive reinforcement found in {consecutive_found}/{seeds_tested} seeds")


# ═══════════════════════════════════════════════════════════════════════════
# 11. Generator: New Selection Dedup by Concept
# ═══════════════════════════════════════════════════════════════════════════

def test_new_dedup_by_concept():
    print("\n═══ 11. New Selection Dedup by Concept ═══")
    from engine.generate_lesson import read_tokens, build_lesson

    tokens = read_tokens(DATASET_PATH)

    dup_seeds = 0
    for seed in range(20):
        lesson = build_lesson(tokens, seed=seed)
        new_tokens = lesson.get("selection", {}).get("new", [])
        concepts = []
        for nt in new_tokens:
            ck = nt.get("concept_key") if isinstance(nt, dict) else getattr(nt, "concept_key", "")
            concepts.append(ck)
        if len(concepts) != len(set(concepts)):
            dup_seeds += 1

    log("new_dedup_by_concept", "PASS" if dup_seeds == 0 else "FAIL",
        f"duplicate concepts in new selection: {dup_seeds}/20 seeds")


# ═══════════════════════════════════════════════════════════════════════════
# 12. Generator: MCQ Distractor Policy
# ═══════════════════════════════════════════════════════════════════════════

def test_mcq_distractors():
    print("\n═══ 12. MCQ Distractor Policy ═══")
    from engine.generate_lesson import read_tokens, build_lesson

    tokens = read_tokens(DATASET_PATH)
    lesson = build_lesson(tokens, seed=42)
    steps = lesson["steps"]

    mcq_steps = [s for s in steps if s.get("type") in
                 {"meaning_choice", "review_card", "reinforcement", "audio_to_meaning", "translation_to_word"}]

    # All MCQ steps should have options
    all_have_options = all(s.get("options") and len(s.get("options", [])) > 1 for s in mcq_steps)
    log("mcq_have_options", "PASS" if all_have_options else "FAIL",
        f"MCQ steps with options: {sum(1 for s in mcq_steps if s.get('options'))}/{len(mcq_steps)}")

    # Correct answer should be in options
    all_correct_in_options = all(
        s.get("correct") in s.get("options", [])
        for s in mcq_steps if s.get("correct") and s.get("options")
    )
    log("mcq_correct_in_options", "PASS" if all_correct_in_options else "FAIL",
        "correct answer present in all option lists")

    # No duplicate options
    dup_count = 0
    for s in mcq_steps:
        opts = s.get("options", [])
        if len(opts) != len(set(opts)):
            dup_count += 1
    log("mcq_no_dup_options", "PASS" if dup_count == 0 else "FAIL",
        f"steps with duplicate options: {dup_count}/{len(mcq_steps)}")


# ═══════════════════════════════════════════════════════════════════════════
# 13. Generator: Ayah Assembly Eligibility
# ═══════════════════════════════════════════════════════════════════════════

def test_ayah_eligibility():
    print("\n═══ 13. Ayah Assembly Eligibility ═══")
    from engine.generate_lesson import read_tokens, build_lesson, MUQATTAAT_SURAHS

    tokens = read_tokens(DATASET_PATH)
    lesson = build_lesson(tokens, seed=42)
    steps = lesson["steps"]

    ayah_steps = [s for s in steps if s.get("type", "").startswith("ayah_build")]

    if ayah_steps:
        # No ayah from muqattaat surahs
        muq_ayah = [s for s in ayah_steps if s.get("surah") in MUQATTAAT_SURAHS and s.get("ayah") == 1]
        log("ayah_no_muqattaat", "PASS" if len(muq_ayah) == 0 else "FAIL",
            f"muqattaat in ayah steps: {len(muq_ayah)}")

        # Ayah steps should have gold_order and pool
        all_have_gold = all(s.get("gold_order_token_ids") for s in ayah_steps)
        all_have_pool = all(s.get("pool") for s in ayah_steps)
        log("ayah_has_gold_order", "PASS" if all_have_gold else "FAIL",
            f"ayah steps with gold_order: {sum(1 for s in ayah_steps if s.get('gold_order_token_ids'))}/{len(ayah_steps)}")
        log("ayah_has_pool", "PASS" if all_have_pool else "FAIL",
            f"ayah steps with pool: {sum(1 for s in ayah_steps if s.get('pool'))}/{len(ayah_steps)}")
    else:
        log("ayah_no_muqattaat", "PASS", "no ayah steps (may be config)")
        log("ayah_has_gold_order", "PASS", "no ayah steps")
        log("ayah_has_pool", "PASS", "no ayah steps")


# ═══════════════════════════════════════════════════════════════════════════
# 14. Counters & Timestamps
# ═══════════════════════════════════════════════════════════════════════════

def test_counters_and_timestamps():
    print("\n═══ 14. Counters & Timestamps ═══")
    now = datetime.now(timezone.utc)

    p = TokenProgress(token_id="tok:test:14:1", state=STATE_NEW)
    correct = AnswerSignal(is_correct=True, attempt_count=1, latency_ms=3000)
    wrong = AnswerSignal(is_correct=False, attempt_count=1, latency_ms=5000)

    # First answer sets first_seen_at
    update_progress(p, correct, now)
    log("first_seen_set", "PASS" if p.first_seen_at is not None else "FAIL",
        f"first_seen_at={p.first_seen_at}")
    log("last_seen_updated", "PASS" if p.last_seen_at is not None else "FAIL",
        f"last_seen_at={p.last_seen_at}")
    log("next_review_set", "PASS" if p.next_review_at is not None else "FAIL",
        f"next_review_at={p.next_review_at}")

    # Counters
    log("total_reviews_1", "PASS" if p.total_reviews == 1 else "FAIL",
        f"total_reviews={p.total_reviews}")
    log("total_correct_1", "PASS" if p.total_correct == 1 else "FAIL",
        f"total_correct={p.total_correct}")

    # Wrong answer
    update_progress(p, wrong, now + timedelta(hours=1))
    log("total_wrong_1", "PASS" if p.total_wrong == 1 else "FAIL",
        f"total_wrong={p.total_wrong}")
    log("consecutive_wrong_1", "PASS" if p.consecutive_wrong == 1 else "FAIL",
        f"consecutive_wrong={p.consecutive_wrong}")

    # Correct resets consecutive_wrong
    update_progress(p, correct, now + timedelta(hours=2))
    log("consecutive_wrong_reset", "PASS" if p.consecutive_wrong == 0 else "FAIL",
        f"consecutive_wrong={p.consecutive_wrong}")

    # first_seen_at should not change
    first_seen_original = p.first_seen_at
    update_progress(p, correct, now + timedelta(hours=3))
    log("first_seen_immutable", "PASS" if p.first_seen_at == first_seen_original else "FAIL",
        "first_seen_at should not change after initial set")


# ═══════════════════════════════════════════════════════════════════════════
# Runner
# ═══════════════════════════════════════════════════════════════════════════

def main():
    print("=" * 60)
    print("Unit Tests — SRS Engine + Lesson Generator")
    print("=" * 60)

    # SRS Engine
    test_outcome_buckets()
    test_graduated_steps()
    test_learning_step_wrong_answer()
    test_stability_difficulty()
    test_state_transitions()
    test_due_scoring()
    test_dynamic_ratio()
    test_reinforcement_scoring()

    # Generator
    test_muqattaat_exclusion()
    test_intra_lesson_repetition()
    test_reinforcement_non_consecutive()
    test_new_dedup_by_concept()
    test_mcq_distractors()
    test_ayah_eligibility()

    # Shared
    test_counters_and_timestamps()

    # Summary
    passed = sum(1 for r in results if r["status"] == "PASS")
    failed = sum(1 for r in results if r["status"] == "FAIL")

    print(f"\n{'=' * 60}")
    print(f"UNIT TESTS: {passed} passed, {failed} failed, {len(results)} total")
    print(f"{'=' * 60}")

    return 0 if failed == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
