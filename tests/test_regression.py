"""
Regression Tests — Fixed seed snapshots + contract compatibility.

Covers QUALITY_GATE §2.3:
  1. Fixed seed snapshot: same seed → same lesson structure
  2. Contract compatibility: API responses match backend_contracts.md schemas
  3. Lesson structure quality thresholds (§3)
  4. Multi-seed stability

Run:
  cd quran-app
  python -m tests.test_regression
"""
from __future__ import annotations

import sys
import os
import json
from pathlib import Path
from datetime import datetime, timezone

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from engine.generate_lesson import read_tokens, build_lesson, MUQATTAAT_SURAHS

DATASET_PATH = Path(__file__).resolve().parent.parent / "dataset.csv"

results = []


def log(test_name: str, status: str, details: str = ""):
    results.append({"test": test_name, "status": status, "details": details})
    icon = "✅" if status == "PASS" else "❌"
    print(f"  {icon} {test_name}: {details}")


# ═══════════════════════════════════════════════════════════════════════════
# 1. Fixed Seed Determinism
# ═══════════════════════════════════════════════════════════════════════════

def test_fixed_seed_determinism():
    print("\n═══ 1. Fixed Seed Determinism ═══")
    tokens = read_tokens(DATASET_PATH)

    # Generate same seed twice
    lesson1 = build_lesson(tokens, seed=42)
    lesson2 = build_lesson(tokens, seed=42)

    # Same number of steps
    log("seed_same_step_count", "PASS" if len(lesson1["steps"]) == len(lesson2["steps"]) else "FAIL",
        f"lesson1={len(lesson1['steps'])}, lesson2={len(lesson2['steps'])}")

    # Same algorithm version
    log("seed_same_algo", "PASS" if lesson1["algorithm_version"] == lesson2["algorithm_version"] else "FAIL",
        f"v1={lesson1['algorithm_version']}, v2={lesson2['algorithm_version']}")

    # Same step types sequence
    types1 = [s.get("type") for s in lesson1["steps"]]
    types2 = [s.get("type") for s in lesson2["steps"]]
    log("seed_same_step_types", "PASS" if types1 == types2 else "FAIL",
        f"types match: {types1 == types2}")

    # Same new token selection
    new1 = [t.get("token_id") if isinstance(t, dict) else getattr(t, "token_id", "")
            for t in lesson1.get("selection", {}).get("new", [])]
    new2 = [t.get("token_id") if isinstance(t, dict) else getattr(t, "token_id", "")
            for t in lesson2.get("selection", {}).get("new", [])]
    log("seed_same_new_tokens", "PASS" if new1 == new2 else "FAIL",
        f"new1={new1}, new2={new2}")

    # Same dynamic counts
    dyn1 = lesson1.get("dynamic", {})
    dyn2 = lesson2.get("dynamic", {})
    log("seed_same_dynamic", "PASS" if dyn1 == dyn2 else "FAIL",
        f"match: {dyn1 == dyn2}")

    # Different seeds → different lessons
    lesson3 = build_lesson(tokens, seed=99)
    new3 = [t.get("token_id") if isinstance(t, dict) else getattr(t, "token_id", "")
            for t in lesson3.get("selection", {}).get("new", [])]
    log("different_seed_different_lesson", "PASS" if new1 != new3 else "FAIL",
        f"seed=42 new={new1}, seed=99 new={new3}")


# ═══════════════════════════════════════════════════════════════════════════
# 2. Lesson Structure Contract
# ═══════════════════════════════════════════════════════════════════════════

def test_lesson_structure_contract():
    print("\n═══ 2. Lesson Structure Contract ═══")
    tokens = read_tokens(DATASET_PATH)
    lesson = build_lesson(tokens, seed=42)

    # Top-level required fields
    required_fields = ["lesson_id", "generated_at_utc", "algorithm_version",
                       "config", "dynamic", "selection", "steps"]
    missing = [f for f in required_fields if f not in lesson]
    log("contract_top_level_fields", "PASS" if not missing else "FAIL",
        f"missing: {missing}" if missing else f"all {len(required_fields)} present")

    # Dynamic counts required fields
    dyn = lesson.get("dynamic", {})
    dyn_required = ["total_known_words", "computed_new", "computed_review",
                    "actual_new", "actual_due", "actual_reinforcement"]
    dyn_missing = [f for f in dyn_required if f not in dyn]
    log("contract_dynamic_fields", "PASS" if not dyn_missing else "FAIL",
        f"missing: {dyn_missing}" if dyn_missing else f"all {len(dyn_required)} present")

    # Selection has 'new' and 'due'
    sel = lesson.get("selection", {})
    log("contract_selection_keys", "PASS" if "new" in sel and "due" in sel else "FAIL",
        f"keys: {list(sel.keys())}")

    # Steps are a list of dicts with 'type'
    steps = lesson.get("steps", [])
    all_have_type = all(isinstance(s, dict) and "type" in s for s in steps)
    log("contract_steps_have_type", "PASS" if all_have_type else "FAIL",
        f"steps count: {len(steps)}")

    # Algorithm version format
    algo = lesson.get("algorithm_version", "")
    log("contract_algo_version", "PASS" if algo.startswith("v3-") else "FAIL",
        f"algorithm={algo}")


# ═══════════════════════════════════════════════════════════════════════════
# 3. Step Payload Contract
# ═══════════════════════════════════════════════════════════════════════════

def test_step_payload_contract():
    print("\n═══ 3. Step Payload Contract ═══")
    tokens = read_tokens(DATASET_PATH)
    lesson = build_lesson(tokens, seed=42)
    steps = lesson.get("steps", [])

    valid_types = {"new_word_intro", "meaning_choice", "review_card", "reinforcement",
                   "audio_to_meaning", "translation_to_word",
                   "ayah_build_scramble", "ayah_build_fill",
                   "ayah_build_ar_from_translation", "ayah_build_ar_from_audio"}

    # All step types are valid
    step_types = {s.get("type") for s in steps}
    unknown_types = step_types - valid_types
    log("step_types_valid", "PASS" if not unknown_types else "FAIL",
        f"unknown types: {unknown_types}" if unknown_types else f"all types valid: {step_types}")

    # MCQ steps have correct + options
    mcq_types = {"meaning_choice", "review_card", "reinforcement", "audio_to_meaning", "translation_to_word"}
    mcq_steps = [s for s in steps if s.get("type") in mcq_types]
    mcq_with_correct = sum(1 for s in mcq_steps if s.get("correct"))
    mcq_with_options = sum(1 for s in mcq_steps if s.get("options") and len(s.get("options", [])) > 0)
    log("mcq_have_correct", "PASS" if mcq_with_correct == len(mcq_steps) else "FAIL",
        f"{mcq_with_correct}/{len(mcq_steps)} have correct answer")
    log("mcq_have_options", "PASS" if mcq_with_options == len(mcq_steps) else "FAIL",
        f"{mcq_with_options}/{len(mcq_steps)} have options")

    # new_word_intro steps have token with ar/translation
    intro_steps = [s for s in steps if s.get("type") == "new_word_intro"]
    for i, s in enumerate(intro_steps):
        token = s.get("token", {})
        has_ar = bool(token.get("ar") or token.get("full_form_ar"))
        has_trans = bool(token.get("translation_en"))
        log(f"intro_{i}_has_content", "PASS" if has_ar and has_trans else "FAIL",
            f"ar={has_ar}, translation={has_trans}")

    # Ayah steps have gold_order + pool
    ayah_steps = [s for s in steps if s.get("type", "").startswith("ayah_build")]
    for i, s in enumerate(ayah_steps):
        has_gold = bool(s.get("gold_order_token_ids"))
        has_pool = bool(s.get("pool"))
        log(f"ayah_{i}_has_structure", "PASS" if has_gold and has_pool else "FAIL",
            f"gold_order={has_gold}, pool={has_pool}")


# ═══════════════════════════════════════════════════════════════════════════
# 4. Lesson Quality Thresholds (§3)
# ═══════════════════════════════════════════════════════════════════════════

def test_lesson_quality_thresholds():
    print("\n═══ 4. Lesson Quality Thresholds ═══")
    tokens = read_tokens(DATASET_PATH)

    # Test across 20 seeds
    seeds_tested = 20
    failures = {
        "ayah_present": 0,
        "concept_diversity": 0,
        "option_count": 0,
    }

    for seed in range(seeds_tested):
        lesson = build_lesson(tokens, seed=seed)
        steps = lesson.get("steps", [])
        config = lesson.get("config", {})

        # Ayah steps present when configured
        ayah_count = config.get("ayah_assembly_count", 0)
        actual_ayah = sum(1 for s in steps if s.get("type", "").startswith("ayah_build"))
        if ayah_count > 0 and actual_ayah == 0:
            failures["ayah_present"] += 1

        # Concept diversity: unique concepts in MCQ steps
        mcq_concepts = set()
        for s in steps:
            if s.get("type") in {"meaning_choice", "review_card", "reinforcement",
                                 "audio_to_meaning", "translation_to_word"}:
                token = s.get("token", {})
                ck = token.get("concept_key", "")
                if ck:
                    mcq_concepts.add(ck)
        total_mcq = sum(1 for s in steps if s.get("type") in
                        {"meaning_choice", "review_card", "reinforcement",
                         "audio_to_meaning", "translation_to_word"})
        if total_mcq > 0 and len(mcq_concepts) / total_mcq < 0.3:
            failures["concept_diversity"] += 1

        # MCQ option count: should be 4 (or at least 2)
        for s in steps:
            opts = s.get("options", [])
            if s.get("type") in {"meaning_choice", "review_card", "reinforcement",
                                 "audio_to_meaning", "translation_to_word"}:
                if len(opts) < 2:
                    failures["option_count"] += 1
                    break

    log("quality_ayah_present", "PASS" if failures["ayah_present"] == 0 else "FAIL",
        f"seeds missing ayah steps: {failures['ayah_present']}/{seeds_tested}")
    log("quality_concept_diversity", "PASS" if failures["concept_diversity"] == 0 else "FAIL",
        f"seeds with low concept diversity: {failures['concept_diversity']}/{seeds_tested}")
    log("quality_option_count", "PASS" if failures["option_count"] == 0 else "FAIL",
        f"seeds with <2 MCQ options: {failures['option_count']}/{seeds_tested}")


# ═══════════════════════════════════════════════════════════════════════════
# 5. Multi-Seed Stability
# ═══════════════════════════════════════════════════════════════════════════

def test_multi_seed_stability():
    print("\n═══ 5. Multi-Seed Stability ═══")
    tokens = read_tokens(DATASET_PATH)

    step_counts = []
    new_counts = []
    due_counts = []
    crashes = 0

    for seed in range(50):
        try:
            lesson = build_lesson(tokens, seed=seed)
            step_counts.append(len(lesson.get("steps", [])))
            new_tokens = lesson.get("selection", {}).get("new", [])
            due_tokens = lesson.get("selection", {}).get("due", [])
            new_counts.append(len(new_tokens))
            due_counts.append(len(due_tokens))
        except Exception as e:
            crashes += 1
            print(f"    ⚠ seed={seed} crashed: {e}")

    log("stability_no_crashes", "PASS" if crashes == 0 else "FAIL",
        f"crashes: {crashes}/50 seeds")

    # Step count range should be reasonable
    avg_steps = sum(step_counts) / len(step_counts) if step_counts else 0
    min_steps = min(step_counts) if step_counts else 0
    max_steps = max(step_counts) if step_counts else 0
    log("stability_step_range", "PASS" if min_steps >= 5 and max_steps <= 40 else "FAIL",
        f"steps: min={min_steps}, max={max_steps}, avg={avg_steps:.1f}")

    # New word count should be stable (1-5)
    avg_new = sum(new_counts) / len(new_counts) if new_counts else 0
    log("stability_new_count", "PASS" if 1 <= avg_new <= 5 else "FAIL",
        f"avg new words: {avg_new:.1f}")

    # All seeds should produce at least some steps
    all_have_steps = all(c > 0 for c in step_counts)
    log("stability_all_have_steps", "PASS" if all_have_steps else "FAIL",
        "all seeds produce non-empty lessons")


# ═══════════════════════════════════════════════════════════════════════════
# 6. Snapshot: Fixed reference lesson (seed=42, no progress)
# ═══════════════════════════════════════════════════════════════════════════

SNAPSHOT_SEED = 42
SNAPSHOT_FILE = Path(__file__).resolve().parent / "snapshot_seed42.json"


def _save_snapshot(lesson: dict):
    """Save a reference snapshot for future comparison."""
    snap = {
        "seed": SNAPSHOT_SEED,
        "algorithm_version": lesson["algorithm_version"],
        "step_count": len(lesson["steps"]),
        "step_types": [s.get("type") for s in lesson["steps"]],
        "new_token_ids": [
            t.get("token_id") if isinstance(t, dict) else getattr(t, "token_id", "")
            for t in lesson.get("selection", {}).get("new", [])
        ],
        "due_count": len(lesson.get("selection", {}).get("due", [])),
        "dynamic": lesson.get("dynamic", {}),
        "created_at": datetime.now(timezone.utc).isoformat(),
    }
    SNAPSHOT_FILE.write_text(json.dumps(snap, indent=2), encoding="utf-8")
    return snap


def test_snapshot_regression():
    print("\n═══ 6. Snapshot Regression (seed=42) ═══")
    tokens = read_tokens(DATASET_PATH)
    lesson = build_lesson(tokens, seed=SNAPSHOT_SEED)

    if SNAPSHOT_FILE.exists():
        # Compare with saved snapshot
        saved = json.loads(SNAPSHOT_FILE.read_text(encoding="utf-8"))

        log("snapshot_algo_match",
            "PASS" if saved["algorithm_version"] == lesson["algorithm_version"] else "FAIL",
            f"saved={saved['algorithm_version']}, current={lesson['algorithm_version']}")

        log("snapshot_step_count_match",
            "PASS" if saved["step_count"] == len(lesson["steps"]) else "FAIL",
            f"saved={saved['step_count']}, current={len(lesson['steps'])}")

        current_types = [s.get("type") for s in lesson["steps"]]
        log("snapshot_step_types_match",
            "PASS" if saved["step_types"] == current_types else "FAIL",
            f"match={saved['step_types'] == current_types}")

        current_new_ids = [
            t.get("token_id") if isinstance(t, dict) else getattr(t, "token_id", "")
            for t in lesson.get("selection", {}).get("new", [])
        ]
        log("snapshot_new_tokens_match",
            "PASS" if saved["new_token_ids"] == current_new_ids else "FAIL",
            f"saved={saved['new_token_ids']}, current={current_new_ids}")

        log("snapshot_dynamic_match",
            "PASS" if saved["dynamic"] == lesson.get("dynamic", {}) else "FAIL",
            "dynamic counts match")

        print(f"\n  (Snapshot from: {saved.get('created_at', 'unknown')})")
    else:
        # First run: create baseline snapshot
        snap = _save_snapshot(lesson)
        log("snapshot_baseline_created", "PASS", f"saved to {SNAPSHOT_FILE}")
        log("snapshot_algo_match", "PASS", f"baseline: {snap['algorithm_version']}")
        log("snapshot_step_count_match", "PASS", f"baseline: {snap['step_count']} steps")
        log("snapshot_step_types_match", "PASS", "baseline saved")
        log("snapshot_new_tokens_match", "PASS", f"baseline: {snap['new_token_ids']}")
        log("snapshot_dynamic_match", "PASS", "baseline saved")


# ═══════════════════════════════════════════════════════════════════════════
# Runner
# ═══════════════════════════════════════════════════════════════════════════

def main():
    print("=" * 60)
    print("Regression Tests — Snapshots + Contracts")
    print("=" * 60)

    test_fixed_seed_determinism()
    test_lesson_structure_contract()
    test_step_payload_contract()
    test_lesson_quality_thresholds()
    test_multi_seed_stability()
    test_snapshot_regression()

    # Summary
    passed = sum(1 for r in results if r["status"] == "PASS")
    failed = sum(1 for r in results if r["status"] == "FAIL")

    print(f"\n{'=' * 60}")
    print(f"REGRESSION TESTS: {passed} passed, {failed} failed, {len(results)} total")
    print(f"{'=' * 60}")

    return 0 if failed == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
