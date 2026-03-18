from __future__ import annotations

from datetime import datetime, timedelta, timezone
from pathlib import Path

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from api.models.db import Base
from api.models.orm import QuranToken, LessonRecord, LessonStatus, UserTokenProgress, TokenState
from api.services.answer_service import apply_deferred_srs
from api.services.progress_service import update_engagement_on_complete, get_engagement
from engine.generate_lesson import read_tokens, pick_due


TEST_DB_URL = "sqlite:///:memory:"


def _make_session():
    engine = create_engine(TEST_DB_URL)
    Base.metadata.create_all(bind=engine)
    Session = sessionmaker(bind=engine, autoflush=False, autocommit=False)
    return Session()


def _sample_tokens(limit: int = 120):
    dataset_path = Path(__file__).resolve().parent.parent / "dataset.csv"
    return read_tokens(dataset_path)[:limit]


def test_concept_key_persisted_when_deferred_srs_creates_progress_row():
    db = _make_session()
    try:
        token = _sample_tokens(1)[0]
        db.add(QuranToken(
            token_id=token.token_id,
            surah=token.surah,
            ayah=token.ayah,
            word=token.word,
            location=token.location,
            audio_key=token.audio_key,
            full_form_ar=token.full_form_ar,
            lemma_ar=token.lemma_ar,
            root_ar=token.root_ar,
            pos=token.pos,
            translation_en=token.translation_en,
            concept_key=token.concept_key,
            freq_global=token.freq_global,
            concept_freq=token.concept_freq,
        ))
        lesson_id = "lesson-phase3-concept"
        db.add(LessonRecord(
            lesson_id=lesson_id,
            user_id="u1",
            algorithm_version="v-test",
            status=LessonStatus.completed,
            lesson_payload={
                "selection": {"due": [], "new": [
                    {"token_id": token.token_id, "concept_key": token.concept_key}
                ], "reinforcement": []},
                "steps": [
                    {"type": "meaning_choice", "token": {"token_id": token.token_id, "concept_key": token.concept_key}}
                ],
            },
            total_steps=1,
            steps_answered=1,
            correct_count=1,
            started_at=datetime.now(timezone.utc),
            completed_at=datetime.now(timezone.utc),
            is_completed=True,
        ))
        from api.models.orm import ReviewHistory
        db.add(ReviewHistory(
            user_id="u1",
            lesson_id=lesson_id,
            step_index=0,
            step_type="meaning_choice",
            token_id=token.token_id,
            is_correct=True,
            attempt_count=1,
            latency_ms=1200,
            hint_used=False,
            outcome_bucket="correct",
            answered_at=datetime.now(timezone.utc),
        ))
        db.commit()

        apply_deferred_srs(db, "u1", lesson_id)

        row = db.query(UserTokenProgress).filter_by(user_id="u1", token_id=token.token_id).one()
        assert row.concept_key == token.concept_key
        assert row.first_seen_at is not None
        assert row.last_seen_at is not None
    finally:
        db.close()


def test_engagement_metrics_recomputed_from_completed_lessons_are_coherent():
    db = _make_session()
    try:
        now = datetime.now(timezone.utc).replace(hour=10, minute=0, second=0, microsecond=0)
        completed_offsets = [0, 0, 1, 3, 31]
        for idx, offset in enumerate(completed_offsets):
            completed_at = now - timedelta(days=offset)
            db.add(LessonRecord(
                lesson_id=f"lesson-eng-{idx}",
                user_id="u2",
                algorithm_version="v-test",
                status=LessonStatus.completed,
                lesson_payload={},
                total_steps=1,
                steps_answered=1,
                correct_count=1,
                started_at=completed_at,
                completed_at=completed_at,
                is_completed=True,
            ))
        db.commit()

        update_engagement_on_complete(db, "u2")
        data = get_engagement(db, "u2")

        assert data["lessons_completed_total"] == 5
        assert data["days_active_30d"] == 3
        assert data["current_streak_days"] == 2
        assert data["best_streak_days"] == 2
        assert data["last_active_at"] is not None
    finally:
        db.close()


def test_pick_due_prefers_ayah_spread_before_reusing_same_cluster():
    tokens = _sample_tokens(120)
    now = datetime.now(timezone.utc)
    same_ayah = [t for t in tokens if t.surah == 1 and t.ayah == 2][:4]
    other_ayahs = []
    seen = {(1, 2)}
    for t in tokens:
        key = (t.surah, t.ayah)
        if key not in seen:
            other_ayahs.append(t)
            seen.add(key)
        if len(other_ayahs) >= 3:
            break

    chosen = same_ayah + other_ayahs
    assert len(chosen) >= 5

    progress = {}
    tokens_by_id = {}
    for idx, token in enumerate(chosen):
        tokens_by_id[token.token_id] = token
        progress[token.token_id] = {
            "state": TokenState.reviewing.value,
            "next_review_at": (now - timedelta(hours=10 - idx)).isoformat(),
            "total_reviews": 5,
            "total_wrong": 1,
        }

    selected = pick_due(tokens_by_id, progress, count=4, now=now)
    ayahs = [(t.surah, t.ayah) for t in selected]

    assert len(selected) == 4
    assert len(set(ayahs)) >= 3
    assert ayahs.count((1, 2)) <= 2
