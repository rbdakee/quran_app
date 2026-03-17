# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Project Overview

**Quran Learning App** — full-stack spaced repetition system (SRS) for learning Quranic Arabic.

- **Algorithm**: `v3-graduated-srs-dynamic-ratio` — implicit SRS with graduated learning steps (4h → 1d → 3d → 7d)
- **Backend**: FastAPI + PostgreSQL, fully complete (Phase D PASSED: 152/152 tests)
- **Frontend**: Flutter with Riverpod — foundation ready, currently in hardening (Phase E, ~60%)
- **Core principle**: Algorithm-first, Quality-first, Quran-safe

---

## Stack

| Layer | Tech |
|-------|------|
| Backend | FastAPI, SQLAlchemy ORM, Alembic, pydantic-settings |
| Database | PostgreSQL, 5 tables, 77,336 tokens |
| Engine | Python 3.11+, implicit SRS (FSRS-like) |
| Frontend | Flutter, Riverpod, go_router, Dio, Freezed |

---

## Architecture

### Backend (`api/`)

```
api/
  main.py                 — FastAPI app, CORS, router mount
  config.py               — Settings from .env (pydantic-settings)
  import_dataset.py       — One-time CSV→DB import
  cache.py                — In-memory lesson generation cache
  models/
    db.py                 — SQLAlchemy engine + session dependency
    orm.py                — ORM: quran_tokens, user_token_progress, review_history, lesson_records, user_engagement
    schemas.py            — Pydantic DTOs (matches backend_contracts.md)
  routers/
    lessons.py            — GET /lessons/today, POST /{id}/answer, POST /{id}/complete
    progress.py           — GET /progress/summary, /reviews-due, /engagement
  services/
    lesson_service.py     — bridges engine/ with DB
    answer_service.py     — evaluates answers, runs SRS engine, writes review_history
    progress_service.py   — progress queries + engagement update
  migrations/             — Alembic (reads DATABASE_URL from .env)
```

### Engine (`engine/`)

```
engine/
  srs_engine.py           — Core SRS: state machine, stability/difficulty, graduated steps
  generate_lesson.py      — Lesson generator (v3): step selection, dedup, segmentation, MCQ
  user_progress_store.py  — JSON-based store (Phase B legacy, still used by SRS scenario tests)
```

### Frontend (`frontend_app/lib/`)

```
lib/
  main.dart               — App entry (MaterialApp.router + Riverpod)
  core/
    constants/            — API base URL, app constants
    network/              — Dio client, error handling, interceptors
    router/               — GoRouter config (/today, /progress, /reviews, /today/summary)
    theme/                — Colors, typography, spacing tokens
  shared/
    models/               — Freezed DTOs (JSON serializable, match API_ENDPOINTS.md)
    widgets/              — Step renderers, state wrappers, reusable UI
  features/
    today/                — TodayLessonScreen, LessonNotifier, LessonRepository
    progress/             — ProgressDashboardScreen, ProgressRepository
    reviews/              — ReviewsDueScreen, ReviewsRepository
    summary/              — LessonSummaryScreen
    shell/                — App shell, bottom navigation
```

### Database Tables

| Table | Purpose |
|-------|---------|
| `quran_tokens` | Source content (77,336 rows, minus 93 Al-Muqatta'at) |
| `user_token_progress` | Per-user SRS state: stability, difficulty, state, next_review_at |
| `review_history` | Answer audit trail (lesson+step references) |
| `lesson_records` | Lesson metadata + completion |
| `user_engagement` | Streak, days active, lessons completed |

Key indexes: `(user_id, next_review_at)` for fast due-list queries, `(user_id, state)` for progress queries.

---

## SRS Algorithm

- **States**: `new` → `learning` → `reviewing` → `mastered`, with `lapsed` recovery
- **Graduated steps**: [4h, 1d, 3d, 7d] — must pass each step with correct answer to advance
- **Implicit signals** (no manual grading): `is_correct`, `attempt_count`, `latency_ms`, `hint_used`
- **Dynamic ratio**: new/review ratio ramps from 1:1 → 5:1 as known word count grows
- **Intra-lesson**: each new word = 4 formats (intro, MCQ, audio, delayed recall)
- **Due scoring**: early review boost (≤4 reviews), next-day fresh priority
- **Mastery ceiling**: max 90 days between reviews

---

## Immutable Product Rules

1. **Quran-safe**: Only use data from Quran dataset + derived fields. No invented sentences. Token order only by `token_id/location`. No split-by-space on translations.
2. **Ayah types**: only `ayah_build_ar_from_translation`, `ayah_build_ar_from_audio`, `ayah_build_translation_from_ar`. Long ayahs segmented (7–8 tokens, max 10).
3. **Al-Muqatta'at**: 29 surahs (93 tokens) excluded from all exercises.
4. **Implicit SRS**: No Again/Hard/Good/Easy buttons in MVP.
5. **Quality before UI**: Never skip quality gate to start frontend faster. If algorithm vs UI speed conflict — always choose algorithm quality.

---

## Common Commands

### Backend — First-time Setup
```bash
# 1. Create PostgreSQL database
psql -U postgres -c "CREATE DATABASE quran_app;"

# 2. Set DATABASE_URL in .env (copy from .env.example)

# 3. Import Quran dataset (one-time)
python -m api.import_dataset

# 4. Start API server
python -m uvicorn api.main:app --reload --port 8000
```

### Backend — Daily Dev
```bash
# Start server
python -m uvicorn api.main:app --reload --port 8000

# Health check
curl http://127.0.0.1:8000/health
# Swagger: http://127.0.0.1:8000/docs

# Re-import dataset (clears and reimports)
# In psql: TRUNCATE quran_tokens CASCADE;
python -m api.import_dataset
```

### Engine — Standalone
```bash
# Generate single lesson
python -m engine.generate_lesson --dataset dataset.csv --out lesson.generated.json --seed 42

# Generate with persistent progress
python -m engine.generate_lesson --dataset dataset.csv --out lesson.generated.json --progress user_progress.json
```

### Tests
```bash
# Unit tests (64 tests) — SRS engine + generator logic
$env:PYTHONIOENCODING='utf-8'; python -m tests.test_unit_engine

# Integration tests (42 tests) — requires quran_app_test database
psql -U postgres -c "CREATE DATABASE quran_app_test;"  # one-time setup
$env:PYTHONIOENCODING='utf-8'; python -m tests.test_integration_api

# Regression tests (30 tests) — seed determinism, contracts, quality
$env:PYTHONIOENCODING='utf-8'; python -m tests.test_regression

# SRS scenario tests (16 tests)
$env:PYTHONIOENCODING='utf-8'; python -m tests.test_srs_scenarios

# Learning pace analysis (30/60-day simulations)
$env:PYTHONIOENCODING='utf-8'; python -m tests.test_learning_pace

# All via pytest
python -m pytest tests/ -v
```

### Frontend
```bash
cd frontend_app
flutter pub get
flutter run

# Regenerate Freezed models after any model changes
flutter pub run build_runner build
```

---

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/health` | Health check |
| GET | `/docs` | Swagger UI |
| GET | `/lessons/today?user_id=X&seed=N` | Generate lesson |
| POST | `/lessons/{id}/answer?user_id=X` | Submit step answer |
| POST | `/lessons/{id}/complete?user_id=X` | Complete lesson, update SRS |
| GET | `/progress/summary?user_id=X` | Progress summary |
| GET | `/progress/reviews-due?user_id=X` | Due tokens list |
| GET | `/progress/engagement?user_id=X` | Engagement stats |

**Source of truth for request/response shapes**: `frontend/API_ENDPOINTS.md`
Priority: `frontend/API_ENDPOINTS.md` > `api/routers/*.py` > `backend_contracts.md`

---

## Frontend Step Types

All 9 step types implemented in `shared/widgets/`:

| Step Type | Description |
|-----------|-------------|
| `new_word_intro` | Present new word with translation + context |
| `meaning_choice` | MCQ — select translation for Arabic word |
| `review_card` | Spaced review prompt |
| `reinforcement` | Non-consecutive reinforcement (never trimmed) |
| `audio_to_meaning` | Listen → select translation |
| `translation_to_word` | See translation → select Arabic word |
| `ayah_build_ar_from_translation` | Build Arabic ayah from translation |
| `ayah_build_ar_from_audio` | Build Arabic ayah from audio |
| `ayah_build_translation_from_ar` | Build translation from Arabic ayah |

Each renderer tracks user signals: `latency_ms`, `hint_used`, `is_correct`, `attempt_count`.

---

## Current Status (Phase E)

**Backend**: ✅ Complete — 152/152 tests passing
**Frontend**: 🔄 In progress (~60%)

### Done
- Routing, feature modules, Riverpod providers, repositories
- All 9 step renderers implemented
- DTO models (Freezed + JSON serializable)
- Network layer (Dio + error handling)
- Design tokens + shared theme

### Remaining
- [ ] Loading/error/empty states hardening across all screens
- [ ] Widget tests for key journeys (>80% coverage target)
- [ ] Audio playback (just_audio integration)
- [ ] Ayah assembly UX validation (tap mechanics)
- [ ] Offline/error recovery (connectivity_plus)

### Phase E DoD
- Full cycle: load → answer steps → complete → summary
- Progress/Reviews receive live backend data
- All 6 design screens implemented
- No runtime errors on happy path
- Widget tests covering main flows

---

## Documentation Map

### Frontend dev
1. `frontend/API_ENDPOINTS.md` — current API contracts (source of truth)
2. `design/design_system_tokens.md` — colors, typography, spacing
3. `design/components_spec.md` — UI component contracts
4. `design/page_1_today_lesson.md` through `page_6_app_shell_navigation.md` — 6 page specs
5. `frontend/FLUTTER_IMPLEMENTATION_PLAN.md` — tech plan, sprint breakdown
6. `frontend/README.md` — onboarding checklist

### Backend dev
1. `backend_contracts.md` — product-level API model (v2)
2. `DATA_SCHEMA.md` — database schema, ORM fields, indexes
3. `RUNBOOK.md` — commands, troubleshooting, migration procedures
4. `roadmap.md` — master strategic document, algorithm decisions

### Not needed for frontend
- `tests/test_unit_engine.py`, `tests/test_integration_api.py`
- `engine/srs_engine.py` (unless debugging SRS behavior)

---

## Documentation Update Protocol

When making code changes, update these docs:
1. `roadmap.md` — if algorithm/product decision changes
2. `backend_contracts.md` — if API payload/schema changes
3. `DATA_SCHEMA.md` — if DB tables/fields change
4. `RUNBOOK.md` — if commands/operational steps change
5. `frontend/API_ENDPOINTS.md` — if API response shapes change

Code changes without documentation sync are considered incomplete.

---

## Quality Gate (Phase D — PASSED ✅)

Sign-off: 2026-03-16 — Unit: 64/64, Integration: 42/42, Regression: 30/30, SRS Scenarios: 16/16, 50-seed stability: 0 crashes.

### Critical release blockers
- Quran-safe violation
- Wrong order validation for ayah tasks
- Broken SRS update path
- Data corruption / duplicate progress rows
- API contract break without version bump

---

## Troubleshooting

**"API returns 500"**: Check PostgreSQL is running → check `.env` DATABASE_URL → verify `SELECT COUNT(*) FROM quran_tokens;` (expect 77,336) → check server logs.

**"Lesson has no steps / missing ayah"**: Verify dataset imported → check seed is valid integer → inspect ayah eligibility logic in `engine/generate_lesson.py`.

**"Flutter models don't deserialize"**: Run `flutter pub run build_runner build` → verify response shape against `frontend/API_ENDPOINTS.md` → check Swagger at `http://127.0.0.1:8000/docs`.
