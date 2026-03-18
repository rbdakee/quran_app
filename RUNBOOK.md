# RUNBOOK.md — Operational Runbook (v1)

> Практическое руководство: как запускать, проверять, диагностировать и сопровождать текущий проектный контур.

---

## 1) Environment prerequisites

## 1.1 Required
- Python 3.11+
- PostgreSQL (locally installed)
- Python packages: `fastapi`, `uvicorn`, `sqlalchemy`, `psycopg2`, `alembic`, `pydantic-settings`
- Доступ к `dataset.csv`
- Рабочая директория проекта: `~/Desktop/pet_projects/quran-app`
- `.env` file with `DATABASE_URL` (see `.env.example`)

---

## 2) Core commands (current phase)

## 2.1 Generate lesson
```bash
python -m engine.generate_lesson --dataset dataset.csv --out lesson.generated.json --seed 42
```

Expected output:
- `lesson.generated.json` создан,
- `Algorithm: v3-graduated-srs-dynamic-ratio`,
- `Steps: <target>`.

## 2.2 Run lesson with persistent progress (Phase B)
```bash
python -m engine.generate_lesson --dataset dataset.csv --out lesson.generated.json --progress user_progress.json
```
- Первый запуск: `user_progress.json` создаётся автоматически.
- Каждый запуск обновляет прогресс (`first_seen_at`, `state`, etc.).
- Для сброса: удалить `user_progress.json`.

## 2.3 Run SRS scenario tests (Phase B)
```bash
$env:PYTHONIOENCODING='utf-8'; python -m tests.test_srs_scenarios
```
Outputs: `TEST_RESULTS.md` with 16 checks (lapse, due/reinforcement, scale progression).

## 2.4 Run learning pace analysis
```bash
$env:PYTHONIOENCODING='utf-8'; python -m tests.test_learning_pace
```
Outputs: 30/60-day simulations showing review frequency, time-to-mastery, ratio dynamics.

## 2.5 Backend API (current state)

### First-time setup
```bash
# 1. Create PostgreSQL database
# psql -U postgres -c "CREATE DATABASE quran_app;"

# 2. Configure .env (copy from .env.example, set DATABASE_URL)

# 3. Import dataset into DB (one-time)
python -m api.import_dataset

# 4. Start API server
python -m uvicorn api.main:app --reload --port 8000
```

### API endpoints
| Method | Path | Description |
|---|---|---|
| GET | `/` | App info |
| GET | `/health` | Health check |
| GET | `/docs` | OpenAPI Swagger UI |
| POST | `/lessons/create-next?user_id=X` | Canonical progression path (create or reopen active lesson) |
| GET | `/lessons/timeline?user_id=X&limit=N` | Lesson history + active CTA state |
| GET | `/lessons/{id}?user_id=X` | Exact stored lesson instance |
| GET | `/lessons/next?user_id=X&seed=N` | Legacy/debug force-generate lesson |
| GET | `/lessons/today?user_id=X&seed=N` | Deprecated compatibility alias |
| POST | `/lessons/{id}/answer?user_id=X` | Submit answer |
| POST | `/lessons/{id}/complete?user_id=X` | Complete lesson |
| GET | `/progress/summary?user_id=X` | Progress summary |
| GET | `/progress/reviews-due?user_id=X` | Due tokens |
| GET | `/progress/engagement?user_id=X` | Engagement stats |
| GET | `/progress/reviews-words?user_id=X` | Secondary/additional review-only lesson |

### Re-import dataset (if needed)
```sql
-- In psql:
TRUNCATE quran_tokens CASCADE;
```
Then: `python -m api.import_dataset`

## 2.6 Full Test Suite (Phase D)

```bash
# Unit tests — SRS engine + generator logic (64 tests)
$env:PYTHONIOENCODING='utf-8'; python -m tests.test_unit_engine

# Integration tests — API E2E via TestClient + PostgreSQL (42 tests)
# Requires: quran_app_test database created in PostgreSQL
$env:PYTHONIOENCODING='utf-8'; python -m tests.test_integration_api

# Regression tests — seed determinism, contracts, quality, stability (30 tests)
$env:PYTHONIOENCODING='utf-8'; python -m tests.test_regression

# SRS scenario tests (legacy, 16 tests)
$env:PYTHONIOENCODING='utf-8'; python -m tests.test_srs_scenarios
```

Prerequisites for integration tests:
```sql
-- Create test database (one-time):
CREATE DATABASE quran_app_test;
```

## 2.7 Generate multiple seeds (manual loop)
Проверка стабильности:
```bash
python -m engine.generate_lesson --dataset dataset.csv --out lesson.seed.1.json --seed 1
python -m engine.generate_lesson --dataset dataset.csv --out lesson.seed.2.json --seed 2
python -m engine.generate_lesson --dataset dataset.csv --out lesson.seed.3.json --seed 3
```

Рекомендуется минимум 20 seed-прогонов на quality check.

## 2.8 Frontend app (Phase E)

Текущий статус: `frontend_app` уже содержит рабочий каркас (router + riverpod + repositories + screens).

```bash
cd frontend_app
flutter pub get
flutter run
```

Если backend локальный:
- API ожидается на `http://127.0.0.1:8000`
- Перед запуском фронта поднять backend:

```bash
python -m uvicorn api.main:app --reload --port 8000
```

---

## 3) Manual QA checklist per generated lesson

1. Есть ли required step types?
   - new/review/reinforcement/ayah.
2. Нет ли duplicate new-intro concept?
3. Есть ли минимум 1-2 ayah steps?
4. Соблюдены ли segment limits?
5. Нет ли явной POS-монотонности?
6. Card dedup соблюдён?
7. Payload формально валиден (required fields присутствуют)?

---

## 4) Troubleshooting guide

## 4.1 Symptom: ayah steps отсутствуют
Possible causes:
- core steps заняли target slots,
- нет eligible ayah (не покрыты все токены),
- config ayah count = 0.

Actions:
1. проверить `selection` и `steps` в JSON,
2. проверить ayah eligibility logic,
3. проверить trimming policy (должна сохранять ayah steps).

## 4.2 Symptom: одно слово повторяется как new
Possible causes:
- dedup по concept не сработал,
- concept_key заполняется неверно,
- fallback агрессивен.

Actions:
1. проверить `concept_key` в token payload,
2. проверить new selection filter,
3. проверить consistency concept derivation.

## 4.3 Symptom: broken translation assembly
Possible causes:
- split по пробелам на переводах,
- потеря token-level mapping.

Actions:
1. проверить `translation_unit_policy`,
2. убедиться, что pool собирается из token-unit переводов.

## 4.4 Symptom: long ayah overload
Possible causes:
- segmentation thresholds не применились,
- wrong segment config.

Actions:
1. проверить `segment_tokens_default/min/max`,
2. проверить поля `segment_start_word/end_word`.

---

## 5) Regression operation

## 5.1 Baseline snapshot flow
1. Выбрать fixed seed-set (например 1..20).
2. Сгенерировать lesson JSON для каждого seed.
3. Сохранить в `regression/`.
4. После изменений сравнить структурно:
   - step types,
   - counts,
   - dedup invariants,
   - ayah constraints.

## 5.2 What is acceptable drift
- Изменения рейтинга шагов допустимы, если:
  - инварианты не нарушены,
  - quality metrics не ухудшились.

---

## 6) Backend transition runbook (next phases)

## 6.1 Before backend coding
- зафиксировать `backend_contracts.md`,
- зафиксировать `DATA_SCHEMA.md`,
- зафиксировать quality thresholds.

## 6.2 During backend coding
- поддерживать parity с генератором,
- при изменении payload сразу обновлять контракты,
- не менять алгоритм silently.

## 6.3 Before frontend start
- пройти `QUALITY_GATE.md` полностью,
- оформить PASS sign-off.

---

## 7) Incident handling protocol

Если обнаружен критичный дефект:
1. classify (critical/major/minor),
2. freeze non-essential work,
3. fix + test,
4. rerun affected + full regression,
5. update docs/decisions.

---

## 8) Documentation synchronization checklist

После любого значимого изменения:
- [ ] обновлён `roadmap.md`
- [ ] обновлён `AGENTS.md`
- [ ] обновлён `backend_contracts.md` (если API/payload)
- [ ] обновлён `DATA_SCHEMA.md` (если DB/model)
- [ ] обновлён `QUALITY_GATE.md` (если thresholds)
- [ ] обновлён `RUNBOOK.md` (если команды/операции)

Документация и код должны оставаться синхронными.
