# API Endpoints for Frontend (Current Implementation)

Документ фиксирует **текущую реализованную** API-схему для Flutter.
Собран по коду:
- `api/routers/lessons.py`
- `api/routers/progress.py`
- `api/models/schemas.py`

> Если есть конфликт с другими md-файлами — ориентироваться на этот документ и текущий backend-код.

---

## Base

- Base URL (local): `http://localhost:8000`
- Swagger: `GET /docs`
- Health: `GET /health`

Общий успешный envelope:
```json
{
  "ok": true,
  "data": {}
}
```

---

## 1) GET `/`

### Purpose
Проверка информации о приложении.

### Response
```json
{
  "app": "Quran Learning API",
  "version": "0.1.0",
  "algorithm": "v3-graduated-srs-dynamic-ratio",
  "docs": "/docs"
}
```

---

## 2) GET `/health`

### Purpose
Health-check backend.

### Response
```json
{
  "status": "ok"
}
```

---

## 3) GET `/lessons/next` (primary) / GET `/lessons/today` (deprecated alias)

Unified lesson endpoint (Duolingo-like). Generates optimal lesson based on current user progress.
- **No daily limit** — user can take multiple lessons back-to-back
- **Auto-invalidation** — any incomplete lesson for this user is discarded on new request
- **Deferred SRS** — progress only updates on lesson completion, not on answer submission

### Query params
- `user_id` (string, optional, default: `default_user`)
- `seed` (int, optional; если не передан — сервер генерирует автоматически)

Пример:
`GET /lessons/next?user_id=u_123&seed=42`

### Response `data`
```json
{
  "lesson_id": "lesson-20260316-064500-1234",
  "generated_at_utc": "2026-03-16T01:45:00+00:00",
  "algorithm_version": "v3-graduated-srs-dynamic-ratio",
  "config": { "target_steps": 14 },
  "dynamic": {
    "total_known_words": 49,
    "computed_new": 2,
    "computed_review": 7,
    "actual_new": 2,
    "actual_due": 7,
    "actual_reinforcement": 2
  },
  "selection": {
    "due": [],
    "new": [],
    "reinforcement": []
  },
  "steps": [
    {
      "step_id": "step_0000",
      "step_index": 0,
      "type": "review_card",
      "skill_type": "ar_en",
      "token": {
        "token_id": "tok:1:2:3",
        "location": "1:2:3",
        "surah": 1,
        "ayah": 2,
        "word": 3,
        "ar": "...",
        "translation_en": "..."
      },
      "options": ["...", "...", "...", "..."],
      "correct": "..."
    }
  ],
  "notes": {
    "quran_safe": true,
    "srs_mode": "implicit"
  }
}
```

### Step types, которые нужно поддержать на фронте
- `new_word_intro`
- `meaning_choice`
- `review_card`
- `reinforcement`
- `audio_to_meaning`
- `translation_to_word`
- `ayah_build_ar_from_translation`
- `ayah_build_ar_from_audio`
- `ayah_build_translation_from_ar`

---

## 4) POST `/lessons/{lesson_id}/answer`

### Query params
- `user_id` (string, optional, default: `default_user`)

### Path params
- `lesson_id` (string, required)

### Request body (текущая схема)
```json
{
  "step_index": 0,
  "step_type": "review_card",
  "token_id": "tok:1:2:3",
  "answer": {
    "selected_option": "the sky",
    "ordered_token_ids": ["tok:1:2:3", "tok:1:2:4"]
  },
  "telemetry": {
    "latency_ms": 3200,
    "attempt_count": 1,
    "used_hint": false,
    "client_ts": "2026-03-16T01:46:00Z"
  }
}
```

### Как заполнять `answer`
- MCQ-шаги (`meaning_choice`, `review_card`, `reinforcement`, `audio_to_meaning`, `translation_to_word`):
  - `answer.selected_option`
- Ayah-build шаги (`ayah_build_*`):
  - `answer.ordered_token_ids` (строго по порядку)
- `new_word_intro`:
  - можно отправить `{"acknowledged": true}`

### Response `data`
```json
{
  "step_index": 0,
  "is_correct": true,
  "outcome_bucket": "correct",
  "feedback": {
    "type": "success",
    "message": "Correct!"
  },
  "progress_update": null
}
```

> **Note**: `progress_update` is always `null` — SRS updates are deferred until lesson completion.

### Error responses
- `404` — lesson not found
- `400 LESSON_INVALIDATED` — lesson was invalidated (user started a new lesson)
  ```json
  {"detail": {"code": "NOT_FOUND", "message": "Lesson not found"}}
  ```
- `400` — lesson completed/expired
  ```json
  {"detail": {"code": "LESSON_EXPIRED", "message": "Lesson already completed"}}
  ```
- `422` — validation error (невалидный body)

---

## 5) POST `/lessons/{lesson_id}/complete`

### Query params
- `user_id` (string, optional, default: `default_user`)

### Body
```json
{
  "completed_at": "2026-03-16T01:55:00Z"
}
```
> Поле optional, backend сам ставит timestamp завершения.

### Response `data`
```json
{
  "summary": {
    "lesson_id": "lesson-...",
    "steps_done": 14,
    "accuracy": 0.82,
    "new_concepts_learned": 4,
    "reviews_done": 6,
    "ayah_tasks_done": 0
  },
  "engagement": {
    "streak_updated": true
  }
}
```

### Error responses
- `404` — lesson not found
- `400` — already completed

---

## 6) GET `/progress/summary`

### Query params
- `user_id` (string, optional)

### Response `data`
```json
{
  "total_tokens": 120,
  "by_state": {
    "new": 0,
    "learning": 30,
    "reviewing": 70,
    "mastered": 20,
    "lapsed": 0
  },
  "due_count": 15,
  "weak_concepts": ["...", "..."]
}
```

---

## 7) GET `/progress/reviews-due`

### Query params
- `user_id` (string, optional)
- `limit` (int, optional, default `50`, min `1`, max `200`)

### Response `data` (array)
```json
[
  {
    "token_id": "tok:1:2:3",
    "concept_key": "...",
    "state": "reviewing",
    "stability": 3.4,
    "next_review_at": "2026-03-15T20:00:00+00:00",
    "due_score": 87.5
  }
]
```

Список уже отсортирован backend-ом по `due_score desc`.

---

## 8) GET `/progress/engagement`

### Query params
- `user_id` (string, optional)

### Response `data`
```json
{
  "current_streak_days": 9,
  "best_streak_days": 14,
  "lessons_completed_total": 41,
  "days_active_30d": 20,
  "last_active_at": "2026-03-16T01:55:00+00:00"
}
```

---

## DTO Notes for Flutter

1. Поля некоторых step-ов опциональны, поэтому модели должны быть tolerant к `null`.
2. `answer` для submit лучше держать как union/sealed model по `step_type`.
3. В `TokenPayload` возможны пустые строки (`lemma_ar`, `root_ar`, `audio_key`).
4. `step_id` и `step_index` приходят от backend — использовать их как ключи UI-состояния.

---

## Known Contract Drift (важно)

1. В `backend_contracts.md` встречается `GET /engagement/summary`,
   а в текущем коде реализовано: **`GET /progress/engagement`**.

2. В high-level контракте `POST /answer` может быть schema через `step_id`,
   а текущий runtime-контракт использует:
   - `step_index`
   - `step_type`
   - `token_id`

Для интеграции Flutter использовать **runtime-контракт из этого файла**.

---

## Source Links

- Product contracts: `backend_contracts.md`
- Runtime routers:
  - `api/routers/lessons.py`
  - `api/routers/progress.py`
- Schemas: `api/models/schemas.py`
- Service behavior:
  - `api/services/answer_service.py`
  - `api/services/progress_service.py`
