# DATA_SCHEMA.md — Data Model Specification (v2)

> Полная схема данных для Quran learning engine.
> **Implementation:** PostgreSQL via SQLAlchemy ORM (`api/models/orm.py`)
> **Status:** All tables created and verified (Phase C complete)

---

## 1) Design goals

1. Поддержать lesson generation + implicit SRS + skill tracking.
2. Сохранить Quran-safe целостность контента.
3. Обеспечить быстрые выборки due/new/reinforcement.
4. Поддержать аналитики качества и engagement.

---

## 2) Core content tables

## 2.1 `quran_tokens`
Источник токенов Корана + derived-поля.

### Key fields
- `token_id` (PK, text) — `tok:surah:ayah:word`
- `surah` (int)
- `ayah` (int)
- `word` (int)
- `location` (text, unique) — `surah:ayah:word`

### Raw content fields
- `full_form_ar` (text)
- `lemma_ar` (text, nullable)
- `root_ar` (text, nullable)
- `pos` (text, nullable)
- `translation_en` (text, nullable)
- `audio_key` (text, nullable)

### Derived fields
- `concept_key` (text, indexed)
- `concept_freq` (int)
- `freq_global` (int)
- `pos_bucket` (text)
- `normalized_ar` (text, indexed)
- `dataset_version` (text)

### Constraints
- unique(`location`)
- check `surah >= 1`, `ayah >= 1`, `word >= 1`

### Indexes
- idx_quran_tokens_surah_ayah_word
- idx_quran_tokens_concept_key
- idx_quran_tokens_pos_bucket
- idx_quran_tokens_normalized_ar

---

## 3) User learning progress tables

## 3.1 `user_token_progress`
Главная таблица прогресса по token.

### PK/Keys
- composite unique: (`user_id`, `token_id`)

### Fields
- `user_id` (text)
- `token_id` (FK -> quran_tokens.token_id)
- `concept_key` (text, denormalized for speed)
- `state` (enum: new|learning|reviewing|mastered|lapsed)
- `learning_step` (int, default 0) — index into graduated steps [4h, 1d, 3d, 7d]
- `stability` (float) — current interval in days
- `difficulty_user` (float, 0..1)
- `next_review_at` (timestamptz, indexed)
- `last_seen_at` (timestamptz)
- `first_seen_at` (timestamptz)
- `total_reviews` (int)
- `total_correct` (int)
- `total_wrong` (int)
- `consecutive_wrong` (int, default 0)
- `last_outcome_bucket` (text)
- `last_latency_ms` (int, nullable)
- `suspended_until` (timestamptz, nullable)
- `updated_at` (timestamptz)

### Indexes
- idx_utp_user_next_review (`user_id`, `next_review_at`)
- idx_utp_user_concept (`user_id`, `concept_key`)
- idx_utp_user_state (`user_id`, `state`)

---

## 3.2 `user_skill_progress`
Прогресс на уровне skill-канала.

### Unique
- (`user_id`, `skill_type`, `token_id`) или (`user_id`, `skill_type`, `concept_key`) — выбрать одну стратегию.

### Fields
- `user_id`
- `skill_type` (enum: listening|reading|ar_en|en_ar)
- `token_id` (nullable, если выбран concept-level)
- `concept_key` (nullable/required в зависимости от стратегии)
- `stability`
- `difficulty_user`
- `next_review_at`
- `last_seen_at`
- `total_reviews`
- `total_correct`
- `total_wrong`
- `last_outcome_bucket`

### Indexes
- idx_usp_user_skill_next_review
- idx_usp_user_skill_accuracy

---

## 3.3 `review_history`
Сырые события ответов (audit + analytics).

### Fields
- `id` (bigserial PK)
- `user_id`
- `lesson_id`
- `step_id`
- `step_type`
- `skill_type`
- `token_id` (nullable)
- `ayah` metadata (nullable): `surah`, `ayah`, `segment_index`
- `is_correct` (bool)
- `attempt_count` (int)
- `latency_ms` (int)
- `hint_used` (bool)
- `score` (float)
- `answered_at` (timestamptz, indexed)
- `raw_answer_json` (jsonb)

### Indexes
- idx_rh_user_answered_at
- idx_rh_user_skill
- idx_rh_user_token
- idx_rh_lesson

---

## 3.4 `user_engagement_stats`
Ежедневная вовлечённость и агрегаты.

### Fields
- `user_id` (PK)
- `current_streak_days` (int)
- `best_streak_days` (int)
- `last_active_at` (timestamptz)
- `last_active_local_date` (date)
- `lessons_completed_total` (int)
- `days_active_30d` (int)
- `completion_rate_7d` (float)
- `d1_return_flag` (bool)
- `d7_return_flag` (bool)
- `updated_at` (timestamptz)

### Notes
- Пересчёт streak делается в TZ пользователя.

---

## 3.5 (Optional) `user_lemma_progress`
Агрегация по lemma/concept для аналитики.

### Fields
- `user_id`
- `concept_key` / `lemma_id`
- `coverage_tokens_seen`
- `coverage_tokens_total`
- `retention_score`
- `updated_at`

---

## 4) Lesson runtime tables

## 4.1 `lessons`
Метаданные сгенерированного урока.

### Fields
- `lesson_id` (PK)
- `user_id`
- `algorithm_version`
- `config_json` (jsonb)
- `selection_json` (jsonb)
- `generated_at_utc`
- `started_at` (nullable)
- `completed_at` (nullable)
- `status` (generated|in_progress|completed|expired)

---

## 4.2 `lesson_items`
Нормализованные шаги урока.

### Unique
- (`lesson_id`, `step_index`)

### Fields
- `lesson_id` (FK)
- `step_id`
- `step_index`
- `step_type`
- `skill_type`
- `payload_json` (jsonb)
- `is_answered` (bool)
- `answered_at` (nullable)

### Indexes
- idx_lesson_items_lesson
- idx_lesson_items_step_type

---

## 5) Data flow (end-to-end)

1. `quran_tokens` наполняется из dataset и derived-полей.
2. Generator читает token table + user progress.
3. Создаёт запись `lessons` + `lesson_items`.
4. Клиент отправляет `/answer`.
5. Backend пишет `review_history`.
6. Backend обновляет `user_token_progress` + `user_skill_progress`.
7. При `/complete` обновляется `user_engagement_stats`.

---

## 6) Critical invariants

1. Нельзя иметь 2 progress-строки на один (`user_id`, `token_id`).
2. `next_review_at` не может быть null для состояний reviewing/mastered.
3. Ayah order check всегда по token_id sequence.
4. Переводные units не дробятся backend-логикой.
5. `concept_key` должен быть заполнен у каждого token.

---

## 7) Migration plan (recommended)

1. Create `quran_tokens`.
2. Create progress tables.
3. Create lesson tables.
4. Create history + engagement tables.
5. Add indexes.
6. Backfill derived fields (`concept_key`, `pos_bucket`, frequencies).
7. Validate constraints.

---

## 8) SRS model parameters (v3)

### Graduated learning steps
Steps: [0.17d (~4h), 1.0d, 3.0d, 7.0d]
- Each correct answer advances `learning_step` by 1.
- Wrong answer decrements `learning_step` by 1 (min 0).
- After all 4 steps → state = reviewing.

### Stability bounds
- `INITIAL_STABILITY` = 0.17 days (~4 hours)
- `MIN_STABILITY` = 0.1 days
- `MAX_STABILITY` = 90 days (mastered ceiling)
- `MASTERED_STABILITY_THRESHOLD` = 21 days

### Due scoring
- Base: `overdue_hours * 1.2 + wrong_rate * 3.0 + difficulty`
- Early review boost: `+50 * (1 - total_reviews / 5)` when total_reviews ≤ 4
- Fresh boost: `+30` when first_seen ≤ 2 days ago and total_reviews ≤ 3

### Dynamic ratio
- Computed by `compute_dynamic_counts(total_known_words)`
- Ramp: 0-10 words → 1:1, 10-30 → 2:1, 30-60 → 3-4:1, 60+ → 5:1

### Content exclusions
- Al-Muqatta'at: 29 surahs, ayah 1 tokens excluded from all pools (93 tokens)

---

## 9) Open points
- Выбрать гранулярность `user_skill_progress`: token-level vs concept-level.
- Уточнить retention_score формулу для `user_lemma_progress`.
- Добавить materialized views для analytics dashboards.
