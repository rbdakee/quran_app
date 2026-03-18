"""
Integration Tests — Full API cycle via TestClient (no live server required).

Covers QUALITY_GATE §2.2:
  1. generate lesson → answer steps → complete lesson
  2. review_history write consistency
  3. token+skill progress update consistency
  4. engagement update (streak/completion)
  5. invalid payload rejection
  6. progress endpoints correctness

Run:
  cd quran-app
  python -m tests.test_integration_api
"""
from __future__ import annotations

import sys
import os
import json
from datetime import datetime, timezone
from pathlib import Path

# Ensure project root on path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from fastapi.testclient import TestClient
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

from api.models.db import Base, get_db
from api.main import app


# ---------------------------------------------------------------------------
# Test DB setup (PostgreSQL — separate test database for real behavior)
# ---------------------------------------------------------------------------

from api.config import settings

# Derive test DB URL from production URL (replace db name with _test suffix)
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

USER_ID = "test_user_integration"
SEED = 42

results = []


def log(test_name: str, status: str, details: str = ""):
    results.append({"test": test_name, "status": status, "details": details})
    icon = "✅" if status == "PASS" else "❌"
    print(f"  {icon} {test_name}: {details}")


def setup_db():
    """Create tables + import minimal token set for testing."""
    # Drop and recreate
    Base.metadata.drop_all(bind=test_engine)
    Base.metadata.create_all(bind=test_engine)

    # Import tokens from dataset.csv (first 500 for speed)
    from engine.generate_lesson import read_tokens
    dataset_path = Path(__file__).resolve().parent.parent / "dataset.csv"
    all_tokens = read_tokens(dataset_path)

    db = TestSession()
    try:
        from api.models.orm import QuranToken
        batch = []
        seen_ids = set()
        for t in all_tokens:  # import full dataset for FK consistency
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
    """Drop all tables in test database."""
    try:
        Base.metadata.drop_all(bind=test_engine)
    except Exception as e:
        print(f"  ⚠ teardown error: {e}")
    test_engine.dispose()


# ═══════════════════════════════════════════════════════════════════════════
# TEST 1: Health + Root endpoints
# ═══════════════════════════════════════════════════════════════════════════

def test_health_and_root():
    print("\n═══ TEST 1: Health & Root ═══")

    r = client.get("/health")
    log("health_status_code", "PASS" if r.status_code == 200 else "FAIL",
        f"status={r.status_code}")
    log("health_body", "PASS" if r.json().get("status") == "ok" else "FAIL",
        f"body={r.json()}")

    r = client.get("/")
    data = r.json()
    log("root_status_code", "PASS" if r.status_code == 200 else "FAIL",
        f"status={r.status_code}")
    log("root_algorithm", "PASS" if "v3" in data.get("algorithm", "") else "FAIL",
        f"algorithm={data.get('algorithm')}")


# ═══════════════════════════════════════════════════════════════════════════
# TEST 2: Generate lesson → answer → complete (full cycle)
# ═══════════════════════════════════════════════════════════════════════════

def test_full_lesson_cycle():
    print("\n═══ TEST 2: Full Lesson Cycle ═══")

    # Generate lesson
    r = client.get(f"/lessons/today?user_id={USER_ID}&seed={SEED}")
    log("lesson_generate_status", "PASS" if r.status_code == 200 else "FAIL",
        f"status={r.status_code}")

    body = r.json()
    log("lesson_ok_flag", "PASS" if body.get("ok") is True else "FAIL",
        f"ok={body.get('ok')}")

    lesson = body.get("data", {})
    lesson_id = lesson.get("lesson_id", "")
    steps = lesson.get("steps", [])
    algo = lesson.get("algorithm_version", "")

    log("lesson_has_id", "PASS" if lesson_id else "FAIL",
        f"lesson_id={lesson_id}")
    log("lesson_has_steps", "PASS" if len(steps) > 0 else "FAIL",
        f"steps={len(steps)}")
    log("lesson_algorithm_version", "PASS" if "v3" in algo else "FAIL",
        f"algorithm={algo}")

    # Check dynamic counts
    dynamic = lesson.get("dynamic", {})
    log("lesson_has_dynamic", "PASS" if dynamic else "FAIL",
        f"dynamic keys={list(dynamic.keys())}")

    # Check selection
    selection = lesson.get("selection", {})
    new_tokens = selection.get("new", [])
    due_tokens = selection.get("due", [])
    log("lesson_has_selection", "PASS" if selection else "FAIL",
        f"new={len(new_tokens)}, due={len(due_tokens)}")

    # Answer ALL steps (completion guard requires all steps answered)
    answered_count = 0
    correct_count = 0
    answer_step_indices = []

    for i, step in enumerate(steps):  # answer all steps
        step_type = step.get("type", "")
        token_id = ""

        # Get token_id from step
        token_data = step.get("token", {})
        if token_data:
            token_id = token_data.get("token_id", "")

        if not token_id:
            # For ayah_build steps, use first token in pool
            pool = step.get("pool", [])
            if pool:
                token_id = pool[0].get("token_id", "")
            if not token_id:
                continue

        # Determine answer
        answer_payload = {}
        is_correct_expected = False

        if step_type in {"meaning_choice", "review_card", "reinforcement",
                         "audio_to_meaning", "translation_to_word"}:
            correct = step.get("correct", "")
            answer_payload = {"selected_option": correct}
            is_correct_expected = True
        elif step_type.startswith("ayah_build"):
            gold = step.get("gold_order_token_ids", [])
            answer_payload = {"ordered_token_ids": gold}
            is_correct_expected = True
        elif step_type == "new_word_intro":
            answer_payload = {"acknowledged": True}
            is_correct_expected = True
        else:
            answer_payload = {"selected_option": "unknown"}

        req_body = {
            "step_index": i,
            "step_type": step_type,
            "token_id": token_id,
            "answer": answer_payload,
            "telemetry": {"latency_ms": 3000, "attempt_count": 1},
        }

        r = client.post(
            f"/lessons/{lesson_id}/answer?user_id={USER_ID}",
            json=req_body,
        )

        if r.status_code == 200:
            answered_count += 1
            answer_data = r.json().get("data", {})
            if answer_data.get("is_correct"):
                correct_count += 1
            answer_step_indices.append(i)

    log("answer_submitted", "PASS" if answered_count > 0 else "FAIL",
        f"answered={answered_count} steps, correct={correct_count}")

    # Verify answer response structure
    if steps:
        step = steps[0]
        token_data = step.get("token", {})
        token_id = token_data.get("token_id", "") if token_data else ""
        if token_id:
            r = client.post(
                f"/lessons/{lesson_id}/answer?user_id={USER_ID}",
                json={
                    "step_index": 99,
                    "step_type": step.get("type", "review_card"),
                    "token_id": token_id,
                    "answer": {"selected_option": "test"},
                    "telemetry": {"latency_ms": 5000, "attempt_count": 1},
                },
            )
            if r.status_code == 200:
                resp = r.json().get("data", {})
                has_fields = all(k in resp for k in ["step_index", "is_correct", "outcome_bucket", "feedback", "progress_update"])
                log("answer_response_structure", "PASS" if has_fields else "FAIL",
                    f"keys={list(resp.keys())}")

    # Complete lesson
    r = client.post(
        f"/lessons/{lesson_id}/complete?user_id={USER_ID}",
        json={},
    )
    log("complete_status", "PASS" if r.status_code == 200 else "FAIL",
        f"status={r.status_code}")

    complete_data = r.json().get("data", {})
    summary = complete_data.get("summary", {})
    log("complete_has_summary", "PASS" if summary else "FAIL",
        f"summary keys={list(summary.keys())}")
    log("complete_lesson_id_match", "PASS" if summary.get("lesson_id") == lesson_id else "FAIL",
        f"expected={lesson_id}, got={summary.get('lesson_id')}")
    log("complete_steps_done", "PASS" if summary.get("steps_done", 0) > 0 else "FAIL",
        f"steps_done={summary.get('steps_done')}")
    log("complete_has_engagement", "PASS" if "engagement" in complete_data else "FAIL",
        f"engagement={complete_data.get('engagement')}")

    return lesson_id, steps


# ═══════════════════════════════════════════════════════════════════════════
# TEST 3: Review history consistency
# ═══════════════════════════════════════════════════════════════════════════

def test_review_history_consistency(lesson_id: str):
    print("\n═══ TEST 3: Review History Consistency ═══")

    db = TestSession()
    try:
        from api.models.orm import ReviewHistory
        records = db.query(ReviewHistory).filter(
            ReviewHistory.user_id == USER_ID,
            ReviewHistory.lesson_id == lesson_id,
        ).all()

        log("history_records_exist", "PASS" if len(records) > 0 else "FAIL",
            f"found {len(records)} review records")

        # Check all records have required fields
        all_valid = all(
            r.token_id and r.step_type and r.outcome_bucket and r.answered_at
            for r in records
        )
        log("history_fields_complete", "PASS" if all_valid else "FAIL",
            "all records have token_id, step_type, outcome_bucket, answered_at")

        # Check outcome_bucket values are valid
        valid_buckets = {"perfect_fast", "correct", "correct_slow", "correct_retry", "hint_used", "wrong"}
        all_valid_buckets = all(r.outcome_bucket in valid_buckets for r in records)
        log("history_valid_buckets", "PASS" if all_valid_buckets else "FAIL",
            f"buckets found: {set(r.outcome_bucket for r in records)}")

        # Check timestamps are reasonable
        all_ts_ok = all(r.answered_at is not None for r in records)
        log("history_timestamps", "PASS" if all_ts_ok else "FAIL",
            "all records have valid timestamps")

    finally:
        db.close()


# ═══════════════════════════════════════════════════════════════════════════
# TEST 4: Progress consistency after lesson
# ═══════════════════════════════════════════════════════════════════════════

def test_progress_consistency():
    print("\n═══ TEST 4: Progress Consistency ═══")

    # Via API
    r = client.get(f"/progress/summary?user_id={USER_ID}")
    log("progress_summary_status", "PASS" if r.status_code == 200 else "FAIL",
        f"status={r.status_code}")

    data = r.json().get("data", {})
    total = data.get("total_tokens", 0)
    by_state = data.get("by_state", {})
    log("progress_has_tokens", "PASS" if total > 0 else "FAIL",
        f"total_tokens={total}")
    log("progress_has_states", "PASS" if by_state else "FAIL",
        f"by_state={by_state}")

    # No tokens should be in 'new' state after being answered
    # (they should have transitioned to 'learning' at minimum)
    # Check DB directly
    db = TestSession()
    try:
        from api.models.orm import UserTokenProgress, TokenState
        rows = db.query(UserTokenProgress).filter(
            UserTokenProgress.user_id == USER_ID,
        ).all()

        # All answered tokens should have non-null timestamps
        all_have_first_seen = all(r.first_seen_at is not None for r in rows)
        log("progress_first_seen_set", "PASS" if all_have_first_seen else "FAIL",
            "all tokens have first_seen_at")

        # Unique constraint: no duplicate (user_id, token_id)
        pairs = [(r.user_id, r.token_id) for r in rows]
        log("progress_unique_constraint", "PASS" if len(pairs) == len(set(pairs)) else "FAIL",
            f"rows={len(rows)}, unique pairs={len(set(pairs))}")

        # Stability should be positive
        all_stable = all(r.stability > 0 for r in rows)
        log("progress_stability_positive", "PASS" if all_stable else "FAIL",
            "all tokens have positive stability")

        # SRS states are valid
        valid_states = {TokenState.new, TokenState.learning, TokenState.reviewing,
                        TokenState.mastered, TokenState.lapsed}
        all_valid_states = all(r.state in valid_states for r in rows)
        log("progress_valid_states", "PASS" if all_valid_states else "FAIL",
            f"states found: {set(r.state.value for r in rows)}")

    finally:
        db.close()


# ═══════════════════════════════════════════════════════════════════════════
# TEST 5: Engagement update
# ═══════════════════════════════════════════════════════════════════════════

def test_engagement():
    print("\n═══ TEST 5: Engagement ═══")

    r = client.get(f"/progress/engagement?user_id={USER_ID}")
    log("engagement_status", "PASS" if r.status_code == 200 else "FAIL",
        f"status={r.status_code}")

    data = r.json().get("data", {})
    log("engagement_streak", "PASS" if data.get("current_streak_days", 0) >= 1 else "FAIL",
        f"streak={data.get('current_streak_days')}")
    log("engagement_lessons_total", "PASS" if data.get("lessons_completed_total", 0) >= 1 else "FAIL",
        f"lessons_completed={data.get('lessons_completed_total')}")
    log("engagement_last_active", "PASS" if data.get("last_active_at") else "FAIL",
        f"last_active={data.get('last_active_at')}")


# ═══════════════════════════════════════════════════════════════════════════
# TEST 6: Invalid payload rejection
# ═══════════════════════════════════════════════════════════════════════════

def test_invalid_payloads():
    print("\n═══ TEST 6: Invalid Payload Rejection ═══")

    # Missing required fields in answer
    r = client.post(
        "/lessons/fake-lesson-id/answer?user_id=test",
        json={"step_index": 0},  # missing step_type, token_id, answer
    )
    log("invalid_answer_missing_fields", "PASS" if r.status_code == 422 else "FAIL",
        f"status={r.status_code} (expected 422)")

    # Non-existent lesson
    r = client.post(
        "/lessons/nonexistent-lesson/answer?user_id=test",
        json={
            "step_index": 0,
            "step_type": "review_card",
            "token_id": "tok:1:1:1",
            "answer": {"selected_option": "test"},
        },
    )
    log("invalid_answer_no_lesson", "PASS" if r.status_code == 404 else "FAIL",
        f"status={r.status_code} (expected 404)")

    # Complete non-existent lesson
    r = client.post(
        "/lessons/nonexistent-lesson/complete?user_id=test",
        json={},
    )
    log("invalid_complete_no_lesson", "PASS" if r.status_code == 404 else "FAIL",
        f"status={r.status_code} (expected 404)")

    # Complete already-completed lesson (need to generate+answer all+complete one first)
    r = client.get(f"/lessons/today?user_id=test_invalid&seed=99")
    if r.status_code == 200:
        lid = r.json()["data"]["lesson_id"]
        inv_steps = r.json()["data"].get("steps", [])
        # Answer all steps so completion guard passes
        for i, step in enumerate(inv_steps):
            step_type = step.get("type", "")
            token_data = step.get("token", {})
            token_id = token_data.get("token_id", "") if token_data else ""
            if not token_id:
                pool = step.get("pool", [])
                if pool:
                    token_id = pool[0].get("token_id", "")
                if not token_id:
                    continue
            if step_type in {"meaning_choice", "review_card", "reinforcement", "audio_to_meaning", "translation_to_word"}:
                ans = {"selected_option": step.get("correct", "")}
            elif step_type.startswith("ayah_build"):
                ans = {"ordered_token_ids": step.get("gold_order_token_ids", [])}
            else:
                ans = {"acknowledged": True}
            client.post(f"/lessons/{lid}/answer?user_id=test_invalid", json={
                "step_index": i, "step_type": step_type, "token_id": token_id,
                "answer": ans, "telemetry": {"latency_ms": 1000, "attempt_count": 1},
            })
        client.post(f"/lessons/{lid}/complete?user_id=test_invalid", json={})
        r2 = client.post(f"/lessons/{lid}/complete?user_id=test_invalid", json={})
        log("invalid_double_complete", "PASS" if r2.status_code == 400 else "FAIL",
            f"status={r2.status_code} (expected 400)")
    else:
        log("invalid_double_complete", "FAIL", f"could not generate lesson: {r.status_code}")


# ═══════════════════════════════════════════════════════════════════════════
# TEST 7: Reviews-due endpoint
# ═══════════════════════════════════════════════════════════════════════════

def test_reviews_due():
    print("\n═══ TEST 7: Reviews-Due Endpoint ═══")

    r = client.get(f"/progress/reviews-due?user_id={USER_ID}&limit=10")
    log("reviews_due_status", "PASS" if r.status_code == 200 else "FAIL",
        f"status={r.status_code}")

    data = r.json().get("data", [])
    log("reviews_due_is_list", "PASS" if isinstance(data, list) else "FAIL",
        f"type={type(data).__name__}, count={len(data)}")

    # If any due tokens, verify structure
    if data:
        first = data[0]
        has_fields = all(k in first for k in ["token_id", "state", "stability"])
        log("reviews_due_structure", "PASS" if has_fields else "FAIL",
            f"keys={list(first.keys())}")
    else:
        log("reviews_due_structure", "PASS", "no due tokens (expected for fresh lesson)")


# ═══════════════════════════════════════════════════════════════════════════
# TEST 8: Second lesson generation (progress-aware)
# ═══════════════════════════════════════════════════════════════════════════

def test_second_lesson_progress_aware():
    print("\n═══ TEST 8: Second Lesson (Progress-Aware) ═══")

    r = client.get(f"/lessons/today?user_id={USER_ID}&seed=123")
    log("second_lesson_status", "PASS" if r.status_code == 200 else "FAIL",
        f"status={r.status_code}")

    lesson = r.json().get("data", {})
    dynamic = lesson.get("dynamic", {})
    total_known = dynamic.get("total_known_words", 0)
    log("second_lesson_knows_progress", "PASS" if total_known > 0 else "FAIL",
        f"total_known_words={total_known} (should be >0 from previous lesson)")


# ═══════════════════════════════════════════════════════════════════════════
# TEST 9: /lessons/next endpoint (Duolingo-like)
# ═══════════════════════════════════════════════════════════════════════════

def test_lessons_next_endpoint():
    print("\n═══ TEST 9: /lessons/next Endpoint ═══")

    uid = "test_user_next"

    r = client.get(f"/lessons/next?user_id={uid}&seed=50")
    log("next_endpoint_status", "PASS" if r.status_code == 200 else "FAIL",
        f"status={r.status_code}")

    body = r.json()
    lesson = body.get("data", {})
    lesson_id = lesson.get("lesson_id", "")
    log("next_has_lesson_id", "PASS" if lesson_id else "FAIL",
        f"lesson_id={lesson_id}")
    log("next_has_steps", "PASS" if len(lesson.get("steps", [])) > 0 else "FAIL",
        f"steps={len(lesson.get('steps', []))}")

    # Regression: a truly fresh user must not get simulated due/reinforcement content.
    selection = lesson.get("selection", {})
    due = selection.get("due", [])
    reinforcement = selection.get("reinforcement", [])
    step_types = [step.get("type") for step in lesson.get("steps", [])]
    card_token_ids = {
        step.get("token", {}).get("token_id")
        for step in lesson.get("steps", [])
        if step.get("type") in {"review_card", "reinforcement"} and step.get("token", {}).get("token_id")
    }
    new_token_ids = {
        token.get("token_id") for token in selection.get("new", []) if token.get("token_id")
    }
    old_word_card_ids = sorted(card_token_ids - new_token_ids)

    log("next_fresh_user_no_due_selection", "PASS" if len(due) == 0 else "FAIL",
        f"due={len(due)}")
    log("next_fresh_user_no_reinforcement_selection", "PASS" if len(reinforcement) == 0 else "FAIL",
        f"reinforcement={len(reinforcement)}")
    log("next_fresh_user_no_reinforcement_steps", "PASS" if "reinforcement" not in step_types else "FAIL",
        f"step_types={step_types}")
    log("next_fresh_user_review_cards_only_from_new_words", "PASS" if card_token_ids <= new_token_ids else "FAIL",
        f"review_card_token_ids={sorted(card_token_ids)}, new_token_ids={sorted(new_token_ids)}")
    log("next_fresh_user_no_old_word_cards", "PASS" if not old_word_card_ids else "FAIL",
        f"old_word_card_ids={old_word_card_ids}")


# ═══════════════════════════════════════════════════════════════════════════
# TEST 10: Deferred SRS — answers do NOT update user_token_progress
# ═══════════════════════════════════════════════════════════════════════════

def test_deferred_srs_no_progress_on_answer():
    print("\n═══ TEST 10: Deferred SRS (No Progress on Answer) ═══")

    uid = "test_user_deferred"

    # Generate lesson
    r = client.get(f"/lessons/next?user_id={uid}&seed=77")
    lesson = r.json().get("data", {})
    lesson_id = lesson.get("lesson_id", "")
    steps = lesson.get("steps", [])

    # Check: no user_token_progress rows before answering
    db = TestSession()
    try:
        from api.models.orm import UserTokenProgress
        rows_before = db.query(UserTokenProgress).filter(
            UserTokenProgress.user_id == uid,
        ).count()
        log("deferred_no_progress_before_answer", "PASS" if rows_before == 0 else "FAIL",
            f"progress rows before answering={rows_before} (expected 0)")
    finally:
        db.close()

    # Answer ALL steps (completion guard requires all steps answered)
    for i, step in enumerate(steps):
        step_type = step.get("type", "")
        token_data = step.get("token", {})
        token_id = token_data.get("token_id", "") if token_data else ""
        if not token_id:
            pool = step.get("pool", [])
            if pool:
                token_id = pool[0].get("token_id", "")
            if not token_id:
                continue

        answer_payload = {}
        if step_type in {"meaning_choice", "review_card", "reinforcement",
                         "audio_to_meaning", "translation_to_word"}:
            answer_payload = {"selected_option": step.get("correct", "")}
        elif step_type.startswith("ayah_build"):
            answer_payload = {"ordered_token_ids": step.get("gold_order_token_ids", [])}
        else:
            answer_payload = {"acknowledged": True}

        client.post(
            f"/lessons/{lesson_id}/answer?user_id={uid}",
            json={
                "step_index": i,
                "step_type": step_type,
                "token_id": token_id,
                "answer": answer_payload,
                "telemetry": {"latency_ms": 2000, "attempt_count": 1},
            },
        )

    # Check: STILL no progress rows after answering (deferred SRS)
    db = TestSession()
    try:
        rows_after_answer = db.query(UserTokenProgress).filter(
            UserTokenProgress.user_id == uid,
        ).count()
        log("deferred_no_progress_after_answer", "PASS" if rows_after_answer == 0 else "FAIL",
            f"progress rows after answering={rows_after_answer} (expected 0)")

        # But review_history should exist
        from api.models.orm import ReviewHistory
        history_count = db.query(ReviewHistory).filter(
            ReviewHistory.user_id == uid,
            ReviewHistory.lesson_id == lesson_id,
        ).count()
        log("deferred_review_history_exists", "PASS" if history_count > 0 else "FAIL",
            f"review_history rows={history_count}")
    finally:
        db.close()

    # Complete lesson — NOW SRS should be applied
    r = client.post(f"/lessons/{lesson_id}/complete?user_id={uid}", json={})
    log("deferred_complete_status", "PASS" if r.status_code == 200 else "FAIL",
        f"status={r.status_code}")

    db = TestSession()
    try:
        rows_after_complete = db.query(UserTokenProgress).filter(
            UserTokenProgress.user_id == uid,
        ).count()
        log("deferred_progress_after_complete", "PASS" if rows_after_complete > 0 else "FAIL",
            f"progress rows after complete={rows_after_complete} (expected >0)")
    finally:
        db.close()


# ═══════════════════════════════════════════════════════════════════════════
# TEST 11: Lesson invalidation — abandoned lesson leaves no SRS trace
# ═══════════════════════════════════════════════════════════════════════════

def test_lesson_invalidation():
    print("\n═══ TEST 11: Lesson Invalidation ═══")

    uid = "test_user_invalidation"

    # Generate first lesson
    r = client.get(f"/lessons/next?user_id={uid}&seed=88")
    lesson1 = r.json().get("data", {})
    lesson_id_1 = lesson1.get("lesson_id", "")

    # Answer a few steps (but don't complete)
    steps = lesson1.get("steps", [])
    for i, step in enumerate(steps[:3]):
        step_type = step.get("type", "")
        token_data = step.get("token", {})
        token_id = token_data.get("token_id", "") if token_data else ""
        if not token_id:
            pool = step.get("pool", [])
            if pool:
                token_id = pool[0].get("token_id", "")
            if not token_id:
                continue

        answer_payload = {}
        if step_type in {"meaning_choice", "review_card", "reinforcement",
                         "audio_to_meaning", "translation_to_word"}:
            answer_payload = {"selected_option": step.get("correct", "")}
        elif step_type.startswith("ayah_build"):
            answer_payload = {"ordered_token_ids": step.get("gold_order_token_ids", [])}
        else:
            answer_payload = {"acknowledged": True}

        client.post(
            f"/lessons/{lesson_id_1}/answer?user_id={uid}",
            json={
                "step_index": i,
                "step_type": step_type,
                "token_id": token_id,
                "answer": answer_payload,
                "telemetry": {"latency_ms": 3000, "attempt_count": 1},
            },
        )

    # Generate second lesson — should invalidate first
    r = client.get(f"/lessons/next?user_id={uid}&seed=89")
    lesson2 = r.json().get("data", {})
    lesson_id_2 = lesson2.get("lesson_id", "")

    log("invalidation_new_lesson_generated", "PASS" if lesson_id_2 and lesson_id_2 != lesson_id_1 else "FAIL",
        f"lesson1={lesson_id_1}, lesson2={lesson_id_2}")

    # Check: first lesson should be invalidated
    db = TestSession()
    try:
        from api.models.orm import LessonRecord, ReviewHistory, UserTokenProgress
        rec1 = db.query(LessonRecord).filter(
            LessonRecord.lesson_id == lesson_id_1,
        ).first()
        log("invalidation_lesson1_invalidated", "PASS" if rec1 and rec1.is_invalidated else "FAIL",
            f"is_invalidated={rec1.is_invalidated if rec1 else 'NOT FOUND'}")

        # Check: review_history for lesson1 should be deleted
        history1 = db.query(ReviewHistory).filter(
            ReviewHistory.lesson_id == lesson_id_1,
        ).count()
        log("invalidation_history_cleaned", "PASS" if history1 == 0 else "FAIL",
            f"review_history for lesson1={history1} (expected 0)")

        # Check: no progress rows for this user (lesson1 was invalidated, lesson2 not completed)
        progress_count = db.query(UserTokenProgress).filter(
            UserTokenProgress.user_id == uid,
        ).count()
        log("invalidation_no_progress", "PASS" if progress_count == 0 else "FAIL",
            f"progress rows={progress_count} (expected 0)")
    finally:
        db.close()

    # Answering invalidated lesson should fail
    if steps:
        step = steps[0]
        token_data = step.get("token", {})
        token_id = token_data.get("token_id", "") if token_data else ""
        if token_id:
            r = client.post(
                f"/lessons/{lesson_id_1}/answer?user_id={uid}",
                json={
                    "step_index": 0,
                    "step_type": step.get("type", "review_card"),
                    "token_id": token_id,
                    "answer": {"selected_option": "test"},
                    "telemetry": {"latency_ms": 3000, "attempt_count": 1},
                },
            )
            log("invalidation_answer_rejected", "PASS" if r.status_code == 400 else "FAIL",
                f"status={r.status_code} (expected 400)")

    # Completing invalidated lesson should fail
    r = client.post(f"/lessons/{lesson_id_1}/complete?user_id={uid}", json={})
    log("invalidation_complete_rejected", "PASS" if r.status_code == 400 else "FAIL",
        f"status={r.status_code} (expected 400)")


# ═══════════════════════════════════════════════════════════════════════════
# TEST 12: Back-to-back lessons (Duolingo-like flow)
# ═══════════════════════════════════════════════════════════════════════════

def test_back_to_back_lessons():
    print("\n═══ TEST 12: Back-to-Back Lessons ═══")

    uid = "test_user_b2b"

    # Generate + complete lesson 1
    r = client.get(f"/lessons/next?user_id={uid}&seed=60")
    lesson1 = r.json().get("data", {})
    lid1 = lesson1.get("lesson_id", "")
    steps1 = lesson1.get("steps", [])

    # Answer all steps
    for i, step in enumerate(steps1):
        step_type = step.get("type", "")
        token_data = step.get("token", {})
        token_id = token_data.get("token_id", "") if token_data else ""
        if not token_id:
            pool = step.get("pool", [])
            if pool:
                token_id = pool[0].get("token_id", "")
            if not token_id:
                continue

        answer_payload = {}
        if step_type in {"meaning_choice", "review_card", "reinforcement",
                         "audio_to_meaning", "translation_to_word"}:
            answer_payload = {"selected_option": step.get("correct", "")}
        elif step_type.startswith("ayah_build"):
            answer_payload = {"ordered_token_ids": step.get("gold_order_token_ids", [])}
        else:
            answer_payload = {"acknowledged": True}

        client.post(
            f"/lessons/{lid1}/answer?user_id={uid}",
            json={
                "step_index": i,
                "step_type": step_type,
                "token_id": token_id,
                "answer": answer_payload,
                "telemetry": {"latency_ms": 1500, "attempt_count": 1},
            },
        )

    client.post(f"/lessons/{lid1}/complete?user_id={uid}", json={})

    # Immediately generate lesson 2
    r = client.get(f"/lessons/next?user_id={uid}&seed=61")
    lesson2 = r.json().get("data", {})
    lid2 = lesson2.get("lesson_id", "")
    dynamic2 = lesson2.get("dynamic", {})
    known2 = dynamic2.get("total_known_words", 0)

    log("b2b_second_lesson_generated", "PASS" if lid2 and lid2 != lid1 else "FAIL",
        f"lesson1={lid1}, lesson2={lid2}")
    log("b2b_progress_carried_forward", "PASS" if known2 > 0 else "FAIL",
        f"total_known_words in lesson2={known2} (expected >0)")


# ═══════════════════════════════════════════════════════════════════════════
# TEST 13: Timeline MVP endpoints
# ═══════════════════════════════════════════════════════════════════════════

def test_create_next_fresh_user():
    print("\n═══ TEST 13: create-next (fresh user) ═══")

    uid = "test_user_create_next_fresh"
    r = client.post(f"/lessons/create-next?user_id={uid}&seed=501")
    log("create_next_fresh_status", "PASS" if r.status_code == 200 else "FAIL", f"status={r.status_code}")

    lesson = r.json().get("data", {})
    lesson_id = lesson.get("lesson_id", "")
    log("create_next_fresh_has_lesson", "PASS" if lesson_id else "FAIL", f"lesson_id={lesson_id}")
    log("create_next_fresh_generated_status", "PASS" if lesson.get("status", "generated") == "generated" else "FAIL", f"status={lesson.get('status')}")


def test_create_next_reuses_active_lesson():
    print("\n═══ TEST 14: create-next reuses active lesson ═══")

    uid = "test_user_create_next_reuse"
    r1 = client.post(f"/lessons/create-next?user_id={uid}&seed=601")
    lesson1 = r1.json().get("data", {})
    lid1 = lesson1.get("lesson_id", "")

    r2 = client.post(f"/lessons/create-next?user_id={uid}&seed=602")
    lesson2 = r2.json().get("data", {})
    lid2 = lesson2.get("lesson_id", "")

    log("create_next_reuse_same_lesson", "PASS" if lid1 and lid1 == lid2 else "FAIL", f"lesson1={lid1}, lesson2={lid2}")

    db = TestSession()
    try:
        from api.models.orm import LessonRecord
        active_count = db.query(LessonRecord).filter(LessonRecord.user_id == uid).count()
        log("create_next_reuse_no_duplicates", "PASS" if active_count == 1 else "FAIL", f"lesson_records={active_count} (expected 1)")
    finally:
        db.close()


def test_timeline_returns_stored_lessons():
    print("\n═══ TEST 15: timeline returns stored lessons ═══")

    uid = "test_user_timeline"
    created_ids = []
    for seed in (701, 702):
        r = client.get(f"/lessons/next?user_id={uid}&seed={seed}")
        created_ids.append(r.json().get("data", {}).get("lesson_id"))

    r = client.get(f"/lessons/timeline?user_id={uid}&limit=20")
    log("timeline_status", "PASS" if r.status_code == 200 else "FAIL", f"status={r.status_code}")
    data = r.json().get("data", {})
    items = data.get("items", [])
    item_ids = [item.get("lesson_id") for item in items]
    expected_present = all(lid in item_ids for lid in created_ids if lid)
    log("timeline_contains_created_lessons", "PASS" if expected_present else "FAIL", f"item_ids={item_ids}")
    next_info = data.get("next_lesson", {})
    log("timeline_next_cta_present", "PASS" if "has_active_lesson" in next_info else "FAIL", f"next_lesson={next_info}")


def test_get_by_id_returns_exact_lesson():
    print("\n═══ TEST 16: get lesson by id returns exact stored lesson ═══")

    uid = "test_user_get_by_id"
    created = client.post(f"/lessons/create-next?user_id={uid}&seed=801")
    original = created.json().get("data", {})
    lesson_id = original.get("lesson_id", "")

    r = client.get(f"/lessons/{lesson_id}?user_id={uid}")
    log("get_by_id_status", "PASS" if r.status_code == 200 else "FAIL", f"status={r.status_code}")
    fetched = r.json().get("data", {})
    same_steps = fetched.get("steps") == original.get("steps")
    same_selection = fetched.get("selection") == original.get("selection")
    log("get_by_id_exact_steps", "PASS" if same_steps else "FAIL", f"steps_match={same_steps}")
    log("get_by_id_exact_selection", "PASS" if same_selection else "FAIL", f"selection_match={same_selection}")


def test_review_lesson_get_by_id_returns_full_payload():
    print("\n═══ TEST 16B: review lesson get by id returns full stored payload ═══")

    uid = "test_user_review_get_by_id"

    created = client.post(f"/lessons/create-next?user_id={uid}&seed=811")
    lesson = created.json().get("data", {})
    lesson_id = lesson.get("lesson_id", "")
    steps = lesson.get("steps", [])

    answered = 0
    for i, step in enumerate(steps):  # answer ALL steps for completion guard
        step_type = step.get("type", "")
        token_data = step.get("token", {})
        token_id = token_data.get("token_id", "") if token_data else ""
        if not token_id:
            pool = step.get("pool", [])
            if pool:
                token_id = pool[0].get("token_id", "")
            if not token_id:
                continue

        if step_type in {"meaning_choice", "review_card", "reinforcement", "audio_to_meaning", "translation_to_word"}:
            answer_payload = {"selected_option": step.get("correct", "")}
        elif step_type.startswith("ayah_build"):
            answer_payload = {"ordered_token_ids": step.get("gold_order_token_ids", [])}
        else:
            answer_payload = {"acknowledged": True}

        resp = client.post(
            f"/lessons/{lesson_id}/answer?user_id={uid}",
            json={
                "step_index": i,
                "step_type": step_type,
                "token_id": token_id,
                "answer": answer_payload,
                "telemetry": {"latency_ms": 1000, "attempt_count": 1},
            },
        )
        if resp.status_code == 200:
            answered += 1

    completed = client.post(f"/lessons/{lesson_id}/complete?user_id={uid}", json={})
    log("review_lesson_seed_complete_status", "PASS" if completed.status_code == 200 else "FAIL", f"status={completed.status_code}")

    review_resp = client.get(f"/progress/reviews-words?user_id={uid}&seed=812&limit=20")
    log("review_lesson_create_status", "PASS" if review_resp.status_code == 200 else "FAIL", f"status={review_resp.status_code}")
    original = review_resp.json().get("data", {})
    review_lesson_id = original.get("lesson_id", "")

    fetched_resp = client.get(f"/lessons/{review_lesson_id}?user_id={uid}")
    log("review_lesson_get_by_id_status", "PASS" if fetched_resp.status_code == 200 else "FAIL", f"status={fetched_resp.status_code}")
    fetched = fetched_resp.json().get("data", {})

    same_steps = fetched.get("steps") == original.get("steps")
    same_selection = fetched.get("selection") == original.get("selection")
    has_payload_shape = bool(fetched.get("steps")) and "selection" in fetched and "config" in fetched
    log("review_lesson_get_by_id_exact_steps", "PASS" if same_steps else "FAIL", f"steps_match={same_steps}")
    log("review_lesson_get_by_id_exact_selection", "PASS" if same_selection else "FAIL", f"selection_match={same_selection}")
    log("review_lesson_get_by_id_full_payload", "PASS" if has_payload_shape else "FAIL", f"keys={list(fetched.keys())}")

    db = TestSession()
    try:
        from api.models.orm import LessonRecord
        rec = db.query(LessonRecord).filter(LessonRecord.lesson_id == review_lesson_id).first()
        has_stored_payload = bool(rec and rec.lesson_payload and rec.lesson_payload.get("steps"))
        log("review_lesson_db_payload_persisted", "PASS" if has_stored_payload else "FAIL", f"stored={has_stored_payload}")
    finally:
        db.close()


def test_completed_lesson_read_only_and_no_reapply():
    print("\n═══ TEST 17: completed lesson is read-only / no reapply ═══")

    uid = "test_user_completed_readonly"
    r = client.post(f"/lessons/create-next?user_id={uid}&seed=901")
    lesson = r.json().get("data", {})
    lesson_id = lesson.get("lesson_id", "")
    steps = lesson.get("steps", [])

    answered = 0
    for i, step in enumerate(steps):  # answer ALL steps for completion guard
        step_type = step.get("type", "")
        token_data = step.get("token", {})
        token_id = token_data.get("token_id", "") if token_data else ""
        if not token_id:
            pool = step.get("pool", [])
            if pool:
                token_id = pool[0].get("token_id", "")
            if not token_id:
                continue

        if step_type in {"meaning_choice", "review_card", "reinforcement", "audio_to_meaning", "translation_to_word"}:
            answer_payload = {"selected_option": step.get("correct", "")}
        elif step_type.startswith("ayah_build"):
            answer_payload = {"ordered_token_ids": step.get("gold_order_token_ids", [])}
        else:
            answer_payload = {"acknowledged": True}

        resp = client.post(
            f"/lessons/{lesson_id}/answer?user_id={uid}",
            json={
                "step_index": i,
                "step_type": step_type,
                "token_id": token_id,
                "answer": answer_payload,
                "telemetry": {"latency_ms": 1200, "attempt_count": 1},
            },
        )
        if resp.status_code == 200:
            answered += 1

    log("completed_readonly_answered_all_steps", "PASS" if answered > 0 else "FAIL", f"answered={answered}")

    complete1 = client.post(f"/lessons/{lesson_id}/complete?user_id={uid}", json={})
    log("completed_readonly_first_complete_ok", "PASS" if complete1.status_code == 200 else "FAIL", f"status={complete1.status_code}")

    db = TestSession()
    try:
        from api.models.orm import UserTokenProgress, LessonRecord
        progress_count_before = db.query(UserTokenProgress).filter(UserTokenProgress.user_id == uid).count()
        rec = db.query(LessonRecord).filter(LessonRecord.lesson_id == lesson_id).first()
        status_value = rec.status.value if hasattr(rec.status, 'value') else rec.status
        log("completed_readonly_status_completed", "PASS" if status_value == "completed" else "FAIL", f"status={status_value}")
    finally:
        db.close()

    answer_again = client.post(
        f"/lessons/{lesson_id}/answer?user_id={uid}",
        json={
            "step_index": 0,
            "step_type": steps[0].get("type", "new_word_intro") if steps else "new_word_intro",
            "token_id": (steps[0].get("token") or {}).get("token_id", "") if steps else "",
            "answer": {"acknowledged": True},
            "telemetry": {"latency_ms": 1000, "attempt_count": 1},
        },
    )
    log("completed_readonly_answer_rejected", "PASS" if answer_again.status_code == 400 else "FAIL", f"status={answer_again.status_code}")

    complete2 = client.post(f"/lessons/{lesson_id}/complete?user_id={uid}", json={})
    log("completed_readonly_second_complete_rejected", "PASS" if complete2.status_code == 400 else "FAIL", f"status={complete2.status_code}")

    db = TestSession()
    try:
        from api.models.orm import UserTokenProgress
        progress_count_after = db.query(UserTokenProgress).filter(UserTokenProgress.user_id == uid).count()
        log("completed_readonly_no_reapply_progress", "PASS" if progress_count_after == progress_count_before else "FAIL", f"before={progress_count_before}, after={progress_count_after}")
    finally:
        db.close()


# ═══════════════════════════════════════════════════════════════════════════
# Runner
# ═══════════════════════════════════════════════════════════════════════════

def main():
    print("=" * 60)
    print("Integration Tests — API Full Cycle")
    print("=" * 60)

    try:
        setup_db()

        test_health_and_root()
        lesson_id, steps = test_full_lesson_cycle()
        test_review_history_consistency(lesson_id)
        test_progress_consistency()
        test_engagement()
        test_invalid_payloads()
        test_reviews_due()
        test_second_lesson_progress_aware()
        test_lessons_next_endpoint()
        test_deferred_srs_no_progress_on_answer()
        test_lesson_invalidation()
        test_back_to_back_lessons()
        test_create_next_fresh_user()
        test_create_next_reuses_active_lesson()
        test_timeline_returns_stored_lessons()
        test_get_by_id_returns_exact_lesson()
        test_review_lesson_get_by_id_returns_full_payload()
        test_completed_lesson_read_only_and_no_reapply()
    finally:
        teardown_db()

    # Summary
    passed = sum(1 for r in results if r["status"] == "PASS")
    failed = sum(1 for r in results if r["status"] == "FAIL")

    print(f"\n{'=' * 60}")
    print(f"INTEGRATION TESTS: {passed} passed, {failed} failed, {len(results)} total")
    print(f"{'=' * 60}")

    return 0 if failed == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
