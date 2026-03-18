"""
Regression Tests — Lesson Integrity Invariants (Phase 1)

Covers:
  1. A lesson cannot be completed when steps_answered < total_steps
  2. Ayah-build steps do NOT inflate lesson-level counters (1 UI step = 1 increment)
  3. Lesson summary accuracy is consistent with real pedagogical steps

Requires: PostgreSQL test database (same as test_integration_api.py).

Run:
  cd quran-app
  python -m tests.test_lesson_integrity
"""
from __future__ import annotations

import sys
import os
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from api.models.db import Base, get_db
from api.main import app
from api.config import settings

# ---------------------------------------------------------------------------
# Test DB setup (mirrors test_integration_api.py)
# ---------------------------------------------------------------------------
_prod_url = settings.DATABASE_URL
_test_url = _prod_url.rsplit("/", 1)[0] + "/quran_app_test"
TEST_DB_URL = _test_url

test_engine = create_engine(TEST_DB_URL)
TestSession = sessionmaker(bind=test_engine, autoflush=False, autocommit=False)


def override_get_db():
    db = TestSession()
    try:
        yield db
    finally:
        db.close()


app.dependency_overrides[get_db] = override_get_db
client = TestClient(app)

results = []


def log(test_name: str, status: str, details: str = ""):
    results.append({"test": test_name, "status": status, "details": details})
    icon = "✅" if status == "PASS" else "❌"
    print(f"  {icon} {test_name}: {details}")


def setup_db():
    Base.metadata.drop_all(bind=test_engine)
    Base.metadata.create_all(bind=test_engine)

    from engine.generate_lesson import read_tokens
    dataset_path = Path(__file__).resolve().parent.parent / "dataset.csv"
    all_tokens = read_tokens(dataset_path)

    db = TestSession()
    try:
        from api.models.orm import QuranToken
        batch = []
        seen_ids = set()
        for t in all_tokens:
            tid = getattr(t, "token_id", "")
            if not tid or tid in seen_ids:
                continue
            seen_ids.add(tid)
            batch.append(QuranToken(
                token_id=tid,
                surah=getattr(t, "surah", 0),
                ayah=getattr(t, "ayah", 0),
                word=getattr(t, "word", 0),
                location=getattr(t, "location", ""),
                full_form_ar=getattr(t, "full_form_ar", ""),
                lemma_ar=getattr(t, "lemma_ar", ""),
                root_ar=getattr(t, "root_ar", ""),
                pos=getattr(t, "pos", ""),
                translation_en=getattr(t, "translation_en", ""),
                concept_key=getattr(t, "concept_key", ""),
                freq_global=getattr(t, "freq_global", 1),
                concept_freq=getattr(t, "concept_freq", 1),
            ))
        db.add_all(batch)
        db.commit()
        print(f"  Setup: imported {len(batch)} tokens into test DB")
    finally:
        db.close()


def teardown_db():
    try:
        Base.metadata.drop_all(bind=test_engine)
    except Exception as e:
        print(f"  ⚠ teardown error: {e}")
    test_engine.dispose()


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _answer_step(lesson_id: str, user_id: str, step: dict, step_index: int) -> int:
    """Answer a single step correctly. Returns HTTP status code."""
    step_type = step.get("type", "")
    token_data = step.get("token", {})
    token_id = token_data.get("token_id", "") if token_data else ""
    if not token_id:
        pool = step.get("pool", [])
        if pool:
            token_id = pool[0].get("token_id", "")
        if not token_id:
            return -1  # skip

    if step_type in {"meaning_choice", "review_card", "reinforcement",
                     "audio_to_meaning", "translation_to_word"}:
        answer_payload = {"selected_option": step.get("correct", "")}
    elif step_type.startswith("ayah_build"):
        answer_payload = {"ordered_token_ids": step.get("gold_order_token_ids", [])}
    else:
        answer_payload = {"acknowledged": True}

    r = client.post(
        f"/lessons/{lesson_id}/answer?user_id={user_id}",
        json={
            "step_index": step_index,
            "step_type": step_type,
            "token_id": token_id,
            "answer": answer_payload,
            "telemetry": {"latency_ms": 2000, "attempt_count": 1},
        },
    )
    return r.status_code


def _answer_all_steps(lesson_id: str, user_id: str, steps: list) -> int:
    """Answer all steps correctly. Returns number of steps successfully answered."""
    answered = 0
    for i, step in enumerate(steps):
        status = _answer_step(lesson_id, user_id, step, i)
        if status == 200:
            answered += 1
    return answered


# ═══════════════════════════════════════════════════════════════════════════
# TEST 1: Cannot complete incomplete lesson
# ═══════════════════════════════════════════════════════════════════════════

def test_cannot_complete_incomplete_lesson():
    print("\n═══ TEST 1: Cannot Complete Incomplete Lesson ═══")

    uid = "test_integrity_incomplete"

    # Generate lesson
    r = client.get(f"/lessons/next?user_id={uid}&seed=1001")
    lesson = r.json().get("data", {})
    lesson_id = lesson.get("lesson_id", "")
    steps = lesson.get("steps", [])
    total = len(steps)

    log("integrity_lesson_generated", "PASS" if lesson_id and total > 0 else "FAIL",
        f"lesson_id={lesson_id}, total_steps={total}")

    # Answer only 2 steps (less than total)
    answered = 0
    for i, step in enumerate(steps[:2]):
        status = _answer_step(lesson_id, uid, step, i)
        if status == 200:
            answered += 1

    log("integrity_answered_partial", "PASS" if 0 < answered < total else "FAIL",
        f"answered={answered}, total={total}")

    # Try to complete — should be rejected with LESSON_INCOMPLETE
    r = client.post(f"/lessons/{lesson_id}/complete?user_id={uid}", json={})
    log("integrity_incomplete_rejected", "PASS" if r.status_code == 400 else "FAIL",
        f"status={r.status_code} (expected 400)")

    if r.status_code == 400:
        detail = r.json().get("detail", {})
        log("integrity_incomplete_error_code", "PASS" if detail.get("code") == "LESSON_INCOMPLETE" else "FAIL",
            f"code={detail.get('code')} (expected LESSON_INCOMPLETE)")

    # Verify lesson is NOT marked completed in DB
    db = TestSession()
    try:
        from api.models.orm import LessonRecord, LessonStatus
        rec = db.query(LessonRecord).filter(LessonRecord.lesson_id == lesson_id).first()
        status_val = rec.status.value if hasattr(rec.status, 'value') else rec.status
        log("integrity_still_in_progress", "PASS" if status_val != LessonStatus.completed.value else "FAIL",
            f"status={status_val}")
    finally:
        db.close()

    # Now answer ALL remaining steps and complete — should succeed
    for i, step in enumerate(steps[2:], start=2):
        _answer_step(lesson_id, uid, step, i)

    r = client.post(f"/lessons/{lesson_id}/complete?user_id={uid}", json={})
    log("integrity_complete_after_all_answered", "PASS" if r.status_code == 200 else "FAIL",
        f"status={r.status_code} (expected 200)")


# ═══════════════════════════════════════════════════════════════════════════
# TEST 2: Zero-step completion rejected
# ═══════════════════════════════════════════════════════════════════════════

def test_cannot_complete_zero_answers():
    print("\n═══ TEST 2: Cannot Complete With Zero Answers ═══")

    uid = "test_integrity_zero"
    r = client.get(f"/lessons/next?user_id={uid}&seed=1002")
    lesson = r.json().get("data", {})
    lesson_id = lesson.get("lesson_id", "")

    # Try to complete immediately — no answers submitted
    r = client.post(f"/lessons/{lesson_id}/complete?user_id={uid}", json={})
    log("integrity_zero_rejected", "PASS" if r.status_code == 400 else "FAIL",
        f"status={r.status_code} (expected 400)")


# ═══════════════════════════════════════════════════════════════════════════
# TEST 3: Ayah-build step does NOT inflate lesson counters
# ═══════════════════════════════════════════════════════════════════════════

def test_ayah_step_no_counter_inflation():
    print("\n═══ TEST 3: Ayah Step Does Not Inflate Counters ═══")

    uid = "test_integrity_ayah"

    # Generate lesson and find an ayah_build step
    r = client.get(f"/lessons/next?user_id={uid}&seed=1003")
    lesson = r.json().get("data", {})
    lesson_id = lesson.get("lesson_id", "")
    steps = lesson.get("steps", [])

    ayah_step = None
    ayah_index = None
    for i, step in enumerate(steps):
        if step.get("type", "").startswith("ayah_build"):
            ayah_step = step
            ayah_index = i
            break

    if ayah_step is None:
        # Try more seeds to find one with ayah_build
        for seed in range(1004, 1020):
            r = client.get(f"/lessons/next?user_id={uid}&seed={seed}")
            lesson = r.json().get("data", {})
            lesson_id = lesson.get("lesson_id", "")
            steps = lesson.get("steps", [])
            for i, step in enumerate(steps):
                if step.get("type", "").startswith("ayah_build"):
                    ayah_step = step
                    ayah_index = i
                    break
            if ayah_step:
                break

    if ayah_step is None:
        log("ayah_inflation_skipped", "PASS", "no ayah_build steps found in test seeds — skipping")
        return

    gold_ids = ayah_step.get("gold_order_token_ids", [])
    num_tokens = len(gold_ids)
    log("ayah_found", "PASS" if num_tokens > 1 else "FAIL",
        f"ayah step at index={ayah_index}, tokens={num_tokens}")

    # Get DB state before
    db = TestSession()
    try:
        from api.models.orm import LessonRecord
        rec = db.query(LessonRecord).filter(LessonRecord.lesson_id == lesson_id).first()
        steps_before = rec.steps_answered
        correct_before = rec.correct_count
    finally:
        db.close()

    # Submit the ayah_build answer
    pool = ayah_step.get("pool", [])
    token_id = pool[0].get("token_id", "") if pool else gold_ids[0]

    r = client.post(
        f"/lessons/{lesson_id}/answer?user_id={uid}",
        json={
            "step_index": ayah_index,
            "step_type": ayah_step.get("type", "ayah_build_scramble"),
            "token_id": token_id,
            "answer": {"ordered_token_ids": gold_ids},
            "telemetry": {"latency_ms": 5000, "attempt_count": 1},
        },
    )
    log("ayah_answer_accepted", "PASS" if r.status_code == 200 else "FAIL",
        f"status={r.status_code}")

    # Check DB: steps_answered should have incremented by exactly 1
    db = TestSession()
    try:
        from api.models.orm import LessonRecord, ReviewHistory
        rec = db.query(LessonRecord).filter(LessonRecord.lesson_id == lesson_id).first()
        steps_after = rec.steps_answered
        correct_after = rec.correct_count

        steps_delta = steps_after - steps_before
        correct_delta = correct_after - correct_before

        log("ayah_steps_answered_delta_is_1", "PASS" if steps_delta == 1 else "FAIL",
            f"delta={steps_delta} (expected 1, tokens_in_step={num_tokens})")
        log("ayah_correct_count_delta_is_1", "PASS" if correct_delta == 1 else "FAIL",
            f"delta={correct_delta} (expected 1)")

        # But review_history should have N entries (one per token for SRS)
        history_count = db.query(ReviewHistory).filter(
            ReviewHistory.lesson_id == lesson_id,
            ReviewHistory.step_index == ayah_index,
        ).count()
        log("ayah_review_history_per_token", "PASS" if history_count == num_tokens else "FAIL",
            f"review_history rows={history_count} (expected {num_tokens})")
    finally:
        db.close()


# ═══════════════════════════════════════════════════════════════════════════
# TEST 4: Full cycle — accuracy consistent with pedagogical steps
# ═══════════════════════════════════════════════════════════════════════════

def test_lesson_summary_accuracy_consistent():
    print("\n═══ TEST 4: Lesson Summary Accuracy Consistent ═══")

    uid = "test_integrity_accuracy"

    r = client.get(f"/lessons/next?user_id={uid}&seed=1050")
    lesson = r.json().get("data", {})
    lesson_id = lesson.get("lesson_id", "")
    steps = lesson.get("steps", [])
    total = len(steps)

    # Answer all steps correctly
    answered = _answer_all_steps(lesson_id, uid, steps)
    log("accuracy_all_answered", "PASS" if answered == total else "FAIL",
        f"answered={answered}, total={total}")

    # Check DB counters before completion
    db = TestSession()
    try:
        from api.models.orm import LessonRecord
        rec = db.query(LessonRecord).filter(LessonRecord.lesson_id == lesson_id).first()
        db_steps_answered = rec.steps_answered
        db_correct_count = rec.correct_count
        db_total_steps = rec.total_steps

        log("accuracy_steps_equal_total", "PASS" if db_steps_answered == db_total_steps else "FAIL",
            f"steps_answered={db_steps_answered}, total_steps={db_total_steps}")
        log("accuracy_correct_leq_answered", "PASS" if db_correct_count <= db_steps_answered else "FAIL",
            f"correct={db_correct_count}, answered={db_steps_answered}")
    finally:
        db.close()

    # Complete and check summary
    r = client.post(f"/lessons/{lesson_id}/complete?user_id={uid}", json={})
    log("accuracy_complete_ok", "PASS" if r.status_code == 200 else "FAIL",
        f"status={r.status_code}")

    if r.status_code == 200:
        summary = r.json().get("data", {}).get("summary", {})
        steps_done = summary.get("steps_done", 0)
        accuracy = summary.get("accuracy", 0)

        log("accuracy_steps_done_matches", "PASS" if steps_done == total else "FAIL",
            f"steps_done={steps_done}, total={total}")
        log("accuracy_value_valid", "PASS" if 0 <= accuracy <= 1.0 else "FAIL",
            f"accuracy={accuracy}")


# ═══════════════════════════════════════════════════════════════════════════
# TEST 5: MCQ step increments counters by exactly 1
# ═══════════════════════════════════════════════════════════════════════════

def test_mcq_step_increments_by_one():
    print("\n═══ TEST 5: MCQ Step Increments By Exactly 1 ═══")

    uid = "test_integrity_mcq"

    r = client.get(f"/lessons/next?user_id={uid}&seed=1060")
    lesson = r.json().get("data", {})
    lesson_id = lesson.get("lesson_id", "")
    steps = lesson.get("steps", [])

    # Find a non-ayah, non-intro step
    mcq_step = None
    mcq_index = None
    for i, step in enumerate(steps):
        if step.get("type") in {"meaning_choice", "review_card", "reinforcement",
                                "audio_to_meaning", "translation_to_word"}:
            mcq_step = step
            mcq_index = i
            break

    if mcq_step is None:
        log("mcq_increment_skipped", "PASS", "no MCQ step found — skipping")
        return

    db = TestSession()
    try:
        from api.models.orm import LessonRecord
        rec = db.query(LessonRecord).filter(LessonRecord.lesson_id == lesson_id).first()
        before = rec.steps_answered
    finally:
        db.close()

    _answer_step(lesson_id, uid, mcq_step, mcq_index)

    db = TestSession()
    try:
        from api.models.orm import LessonRecord
        rec = db.query(LessonRecord).filter(LessonRecord.lesson_id == lesson_id).first()
        delta = rec.steps_answered - before
        log("mcq_step_delta_is_1", "PASS" if delta == 1 else "FAIL",
            f"delta={delta} (expected 1)")
    finally:
        db.close()


# ═══════════════════════════════════════════════════════════════════════════
# Runner
# ═══════════════════════════════════════════════════════════════════════════

def main():
    print("=" * 60)
    print("Lesson Integrity Regression Tests (Phase 1)")
    print("=" * 60)

    try:
        setup_db()

        test_cannot_complete_incomplete_lesson()
        test_cannot_complete_zero_answers()
        test_ayah_step_no_counter_inflation()
        test_lesson_summary_accuracy_consistent()
        test_mcq_step_increments_by_one()
    finally:
        teardown_db()

    passed = sum(1 for r in results if r["status"] == "PASS")
    failed = sum(1 for r in results if r["status"] == "FAIL")

    print(f"\n{'=' * 60}")
    print(f"INTEGRITY TESTS: {passed} passed, {failed} failed, {len(results)} total")
    print(f"{'=' * 60}")

    return 0 if failed == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
