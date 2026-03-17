# backend_contracts.md — API & Payload Contracts (v2)

> Этот документ фиксирует точные контракты backend уровня для lesson generation, answer submission, progress и engagement.
> **Implementation:** FastAPI (`api/routers/`) + SQLAlchemy ORM (`api/models/orm.py`)
> **Status:** All endpoints implemented and E2E verified (Phase C complete)
> **OpenAPI docs:** `http://localhost:8000/docs` (auto-generated)

---

## 1) Contract Principles

1. Все `step`-ответы идентифицируются через `lesson_id + step_index + step_id`.
2. Проверка порядка для сборок всегда по `token_id`, а не по тексту.
3. Сигналы для SRS implicit всегда собираются независимо от step type.
4. Время хранится в UTC ISO-8601.
5. Любая ошибка API возвращает единый формат `error`.

---

## 2) Shared Response/Error Format

## Success envelope
```json
{
  "ok": true,
  "data": { }
}
```

## Error envelope
```json
{
  "ok": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Human readable message",
    "details": { }
  }
}
```

### Common error codes
- `VALIDATION_ERROR`
- `NOT_FOUND`
- `LESSON_EXPIRED`
- `STEP_ALREADY_ANSWERED`
- `ORDER_MISMATCH`
- `INTERNAL_ERROR`

---

## 3) GET /lessons/today

## 3.1 Purpose
Вернуть один lesson-план на текущий день пользователя, собранный по SRS + skill model.

## 3.2 Request
`GET /lessons/today`

Query params (optional):
- `tz=Asia/Qyzylorda`
- `target_steps=14`
- `dry_run=true|false`

`target_steps` трактуется как **плановый таргет**, а не жесткий лимит:
- backend не обязан обрезать lesson до `target_steps`,
- `reinforcement`-шаги не вырезаются,
- итоговый `steps.length` может быть больше `target_steps`.

`new_count` и `due_count` в конфиге — максимумы. Фактические значения определяются динамически через `compute_dynamic_counts()`:
- 0-10 known words: ratio ~1:1
- 10-30: ~2:1
- 30-60: ~3-4:1
- 60+: 5:1 (standard)

Каждое новое слово проходит 4 формата внутри одного урока:
1. `new_word_intro` (reading)
2. `meaning_choice` (ar→en MCQ)
3. `audio_to_meaning` (listening MCQ, if audio exists)
4. `translation_to_word` (en→ar, delayed recall at end of lesson)

## 3.3 Response (high-level)
```json
{
  "ok": true,
  "data": {
    "lesson_id": "lesson-20260316-031500",
    "user_id": "u_123",
    "generated_at_utc": "2026-03-15T22:15:00Z",
    "algorithm_version": "v3-graduated-srs-dynamic-ratio",
    "config": {
      "target_steps": 14,
      "due_count": 15,
      "new_count": 3,
      "reinforcement_count": 2,
      "ayah_assembly_count": 2,
      "new_word_formats": ["new_word_intro", "meaning_choice", "audio_to_meaning", "translation_to_word"]
    },
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
    "steps": [],
    "notes": {
      "quran_safe": true,
      "srs_mode": "implicit"
    }
  }
}
```

## 3.4 Step schema (base)
```json
{
  "step_id": "step_0007",
  "step_index": 7,
  "type": "meaning_choice",
  "skill_type": "ar_en",
  "token": {
    "token_id": "tok:2:10:1",
    "location": "2:10:1",
    "surah": 2,
    "ayah": 10,
    "word": 1,
    "ar": "فِى",
    "translation_en": "in",
    "audio_key": "002_010_001.mp3",
    "concept_key": "فِى",
    "concept_freq": 1098,
    "pos": "P",
    "pos_bucket": "preposition"
  }
}
```

---

## 4) Step-specific payloads

## 4.1 new_word_intro
```json
{
  "step_id": "step_0003",
  "type": "new_word_intro",
  "skill_type": "reading",
  "token": { "token_id": "tok:2:10:1", "concept_key": "فِى" }
}
```

## 4.2 meaning_choice / review_card / reinforcement
```json
{
  "step_id": "step_0004",
  "type": "meaning_choice",
  "skill_type": "ar_en",
  "token": { "token_id": "tok:2:10:1", "concept_key": "فِى" },
  "options": ["in", "on", "to", "from"],
  "correct": "in"
}
```

MCQ distractor policy:
- сначала берутся дистракторы из **знакомых пользователю токенов**,
- если не хватает — добираются из незнакомых,
- выбор внутри пулов рандомизирован,
- для местоимений (POS-bucket `pronoun`) дистракторы по возможности берутся из местоимений.

## 4.3 ayah_build_ar_from_translation
```json
{
  "step_id": "step_0012",
  "type": "ayah_build_ar_from_translation",
  "skill_type": "reading",
  "surah": 1,
  "ayah": 6,
  "ayah_segment_index": 1,
  "segment_start_word": 1,
  "segment_end_word": 3,
  "gold_order_token_ids": ["tok:1:6:1", "tok:1:6:2", "tok:1:6:3"],
  "prompt_translation_units": ["Guide us", "(to) the path", "the straight"],
  "pool": [
    {"token_id": "tok:1:6:2", "text": "ٱلصِّرَٰطَ", "is_distractor": false}
  ],
  "constraints": {
    "verify_by": "token_id",
    "translation_unit_policy": "no_split",
    "distractors_from_seen_only": true
  }
}
```

## 4.4 ayah_build_ar_from_audio
```json
{
  "step_id": "step_0013",
  "type": "ayah_build_ar_from_audio",
  "skill_type": "listening",
  "surah": 1,
  "ayah": 5,
  "ayah_segment_index": 1,
  "gold_order_token_ids": ["tok:1:5:1", "tok:1:5:2", "tok:1:5:3", "tok:1:5:4"],
  "prompt_audio_keys": ["001_005_001.mp3", "001_005_002.mp3"],
  "pool": [
    {"token_id": "tok:1:5:1", "text": "إِيَّاكَ", "is_distractor": false}
  ]
}
```

## 4.5 ayah_build_translation_from_ar
```json
{
  "step_id": "step_0014",
  "type": "ayah_build_translation_from_ar",
  "skill_type": "ar_en",
  "surah": 1,
  "ayah": 7,
  "ayah_segment_index": 1,
  "prompt_ar_tokens": ["صِرَٰطَ", "ٱلَّذِينَ", "أَنْعَمْتَ"],
  "gold_order_token_ids": ["tok:1:7:1", "tok:1:7:2", "tok:1:7:3"],
  "pool": [
    {"token_id": "tok:1:7:1", "text": "(The) path", "is_distractor": false}
  ],
  "constraints": {
    "verify_by": "token_id",
    "translation_unit_policy": "no_split"
  }
}
```

---

## 5) POST /lessons/{id}/answer

## 5.1 Purpose
Принять ответ пользователя на шаг, оценить корректность, обновить прогресс и SRS.

## 5.2 Request body (unified)
```json
{
  "step_id": "step_0012",
  "step_index": 12,
  "answer": {
    "selected_option": "in",
    "ordered_token_ids": ["tok:1:6:1", "tok:1:6:2", "tok:1:6:3"],
    "used_hint": false
  },
  "telemetry": {
    "latency_ms": 4200,
    "attempt_count": 1,
    "client_ts": "2026-03-15T22:20:12Z"
  }
}
```

## 5.3 Server-evaluated signals (for implicit SRS)
- `is_correct`
- `attempt_count`
- `latency_ms`
- `hint_used`

## 5.4 Response
```json
{
  "ok": true,
  "data": {
    "step_id": "step_0012",
    "is_correct": true,
    "score": 1.0,
    "feedback": {
      "type": "success",
      "message": "Correct order"
    },
    "progress_update": {
      "token_ids_affected": ["tok:1:6:1", "tok:1:6:2", "tok:1:6:3"],
      "next_review_at_preview": "2026-03-18T22:20:12Z",
      "outcome_bucket": "perfect_fast"
    },
    "next_step_index": 13
  }
}
```

---

## 6) POST /lessons/{id}/complete

## 6.1 Purpose
Завершить урок, зафиксировать итоговую статистику, обновить engagement.

## 6.2 Request
```json
{
  "completed_at": "2026-03-15T22:25:00Z"
}
```

## 6.3 Response
```json
{
  "ok": true,
  "data": {
    "lesson_id": "lesson-20260316-031500",
    "summary": {
      "steps_done": 14,
      "accuracy": 0.82,
      "new_concepts_learned": 4,
      "reviews_done": 6,
      "ayah_tasks_done": 2
    },
    "engagement": {
      "streak_days": 9,
      "lessons_completed_total": 41,
      "completion_rate_7d": 0.78
    }
  }
}
```

---

## 7) Progress & Engagement APIs

## 7.1 GET /progress/summary
Возвращает:
- due counts,
- learned/in-learning/mastered counts,
- weak concepts,
- last 7d performance snapshot.

## 7.2 GET /progress/reviews-due
Возвращает список due-token/concept для review queue.

## 7.3 GET /engagement/summary
Возвращает:
- current streak,
- best streak,
- active days 30d,
- completion rate 7d,
- return signals D1/D7.

---

## 8) Validation rules (must)

1. `step_id` должен принадлежать `lesson_id`.
2. Нельзя дважды отправить финальный ответ на один шаг.
3. Для ayah build проверка только по `ordered_token_ids`.
4. Для translation build нельзя дробить `translation_en` unit.
5. При несоответствии — `ORDER_MISMATCH`/`VALIDATION_ERROR`.

---

## 9) Versioning

- Любое изменение step payload — bump `contract_version`.
- Рекомендуемый заголовок ответа:
  - `x-contract-version: 1.0.0`

---

## 10) Next contract tasks
- Добавить OpenAPI YAML.
- Прописать idempotency для `/answer`.
- Добавить pagination для history endpoints.
