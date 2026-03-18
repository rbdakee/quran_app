# Quran App — Master Roadmap (v4)

> Документ фиксирует **всю суть проекта**: принципы, алгоритм генерации уроков, типы заданий, skill-модель, SRS-модель, данные, backend-порядок, quality gate и только затем frontend.

---

## Progress Log

### 2026-03-17 — Frontend status audit (frontend_app)

**Текущая фаза:** Phase E — Frontend (in implementation)
**Состояние:** foundation уже реализован, работа не с нуля

Подтверждено по `frontend_app/`:
- `go_router` маршруты подняты (`/today`, `/progress`, `/reviews`, `/today/summary`)
- `Riverpod` подключен на уровне приложения
- network/data слой присутствует (`api_client`, repositories)
- typed модели для API присутствуют (`freezed/json`)
- реализованы feature-модули: today/progress/reviews/summary/shell
- есть набор shared widgets для lesson flow

**Следующий шаг:** Phase E completion/hardening (UX полировка, state/error handling, тесты фронта).

### 2026-03-16 — Phase C complete (FastAPI + PostgreSQL)

**Текущая фаза:** Phase D — Quality Gate PASSED ✅
**Следующая фаза:** Phase E — Frontend
**Тесты:** 152/152 pass (unit 64, integration 42, regression 30, SRS scenarios 16)
**Quality Gate:** PASS (2026-03-16)

#### Структура проекта
```
quran-app/
  engine/                      # core algorithm logic
    generate_lesson.py         # lesson generator (v3)
    srs_engine.py              # implicit SRS engine
    user_progress_store.py     # JSON-file progress (Phase B, still used by tests)
  api/                         # FastAPI backend (Phase C)
    main.py                    # app entrypoint, CORS, routers
    config.py                  # Settings from .env (pydantic-settings)
    import_dataset.py          # dataset.csv → PostgreSQL import script
    models/
      db.py                    # SQLAlchemy engine + session
      orm.py                   # ORM: 5 tables
      schemas.py               # Pydantic request/response
    routers/
      lessons.py               # GET /lessons/today, POST /answer, POST /complete
      progress.py              # GET /progress/summary, /reviews-due, /engagement
    services/
      lesson_service.py        # engine/ → API bridge
      answer_service.py        # answer eval + SRS update + history
      progress_service.py      # progress queries + engagement
    migrations/                # Alembic (configured)
  tests/                       # test scripts
    test_srs_scenarios.py      # 3 SRS scenario tests (16 checks)
    test_learning_pace.py      # learning pace analysis
    simulate_answers.py        # answer simulator
  dataset.csv                  # Quran token dataset (77k+)
  .env                         # DB credentials (not in git)
  .env.example                 # template
  .gitignore
  alembic.ini                  # Alembic config
  TEST_RESULTS.md
```

#### Phase C deliverables
- **PostgreSQL DB**: 5 tables — `quran_tokens` (77,336 rows), `user_token_progress`, `review_history`, `lesson_records`, `user_engagement`
- **FastAPI API**: 8 endpoints verified E2E
- **Import script**: `python -m api.import_dataset` — loads dataset.csv into DB
- **Full cycle tested**: generate lesson → answer steps → SRS update → complete → engagement update → progress query

#### Bug fixes
1. **Al-Muqatta'at filtering** — 29 сур с разъединёнными буквами (93 токена) полностью исключены из:
   - ayah assembly exercises
   - пула слов для new/review/reinforcement/distractors
   - Список: суры 2,3,7,10,11,12,13,14,15,19,20,26,27,28,29,30,31,32,36,38,40,41,42,43,44,45,46,50,68
2. **Reinforcement не вырезается** — `target_steps` = плановый таргет, reinforcement шаги никогда не удаляются
3. **Consecutive reinforcement** — защита от подряд идущих reinforcement шагов

#### Features (v3)
1. **Graduated learning steps** — 4h → 1d → 3d → 7d (слово проходит 4 шага до reviewing)
2. **Dynamic new/review ratio** — плавный ramp:
   - 0-10 known words: 1:1
   - 10-30: ~2:1
   - 30-60: ~3-4:1
   - 60+: 5:1 (standard)
3. **Early review boost** — слова с ≤4 reviews: +50 к due score
4. **Next-day priority** — fresh слова (≤2 дня, ≤3 reviews): +30 к due score
5. **Intra-lesson repetition** — каждое новое слово = 4 формата:
   - `new_word_intro` (reading)
   - `meaning_choice` (ar→en MCQ)
   - `audio_to_meaning` (listening MCQ)
   - `translation_to_word` (en→ar, delayed recall)
6. **Mastered ceiling** — MAX_STABILITY = 90 дней (mastered слова всё равно повторяются)
7. **MCQ distractor policy** — known-first + randomized + pronoun-aware

#### Metrics (v2 → v3, 30-day simulation)
| Metric | v2 | v3 |
|---|---|---|
| Words with 1 review only | 45% | **0%** |
| Avg reviews/word | 2.2 | **6.4** |
| Reached reviewing | 1.7% | **56%** |
| Reached mastered | 0% | **3%** |
| Time to reviewing | ~17d | **~8d** |

## 0) Северная звезда проекта

Построить Quran-safe learning engine, где пользователь:
- учит слова Корана **системно и персонально**,
- чувствует ежедневный прогресс,
- удерживает знания через SRS,
- видит применение слов в аятах,
- возвращается в приложение из-за ясного прогресса и вовлечённости.

**Ключевая последовательность разработки (не нарушать):**
1. Алгоритм уроков (sandbox-скрипт).
2. Живой пользовательский прогресс + implicit SRS.
3. БД и backend API.
4. Тесты и quality gate (технический + продуктовый).
5. Только потом frontend wrapping (UI/UX/кнопки/экраны).

---

## 1) Неподвижные продуктовые принципы

## 1.1 Quran-safe (обязательный контур)
- Источник контента: только `dataset.csv` + derived-поля.
- Не генерировать вымышленные предложения вне Корана.
- Любая проверка порядка и ответа — только по `token_id/location`.
- Для переводов нельзя `split()` по пробелам: перевод хранится как **token-unit**.

## 1.2 Quality-first
- Приоритет №1: корректность алгоритма и качество уроков.
- UI/визуал не должен опережать качество генерации.
- Любая новая фича проходит вопрос: улучшает ли retention/learning quality?

## 1.3 Engagement-early (без фронт-шума)
- Уже на backend-этапах считать:
  - streak,
  - completion rate,
  - D1/D7 return.
- Сложные визуальные механики (ачивки, анимации, соц-механики) — после quality gate.

## 1.4 Разделение ответственности
- **SRS layer = WHAT/WHEN** (что показывать и когда повторять).
- **Skill layer = HOW** (каким типом задания тренировать).
- **Lesson Orchestrator** собирает финальную последовательность шагов.

---

## 2) Учебная модель (единицы знаний)

## 2.1 Сущности
- **Token** — конкретное слово в конкретной позиции аята (`surah:ayah:word`).
- **Concept** — объединение одинакового слова/леммы (`concept_key`).
- **Lemma/Root** — аналитические уровни для расширения персонализации.

## 2.2 Почему это важно
- Пользователь не должен видеть одно и то же слово как "новое" много раз в разных `location`.
- Поэтому new-intro идёт по **concept_key**, а не по каждому token.
- Но тот же concept может появляться в других заданиях (например ayah-сборка) в другом `location`.

---

## 3) Полный алгоритм генерации урока

## 3.1 Входы генератора
1. Контент:
   - `quran_tokens` (или `dataset.csv` на sandbox-фазе)
2. Прогресс:
   - `user_token_progress`
   - `user_skill_progress`
   - `review_history`
   - `user_engagement_stats`
3. Конфиг:
   - target_steps,
   - квоты корзин,
   - лимиты сегментации аятов,
   - правила distractors,
   - правила дедупликации.

## 3.2 Корзины урока
1. **Due** — токены, время повтора которых наступило.
2. **New** — новые concept-единицы.
3. **Reinforcement** — проблемные токены из недавних ошибок.
4. **Ayah Assembly** — задания сборки аята/перевода.

## 3.3 Отбор Due
Скоринг (примерно):
- `overdue_score` = `now - next_review_at`
- `wrong_rate`
- `last_seen_decay`
- `concept importance` (частота/полезность)

Ограничения:
- в карточных шагах не дублировать один `concept_key` (если есть альтернатива).
- fallback разрешает дубликат только если иначе не набирается квота.

## 3.4 Отбор New
Правила:
- только валидные токены с аудио и переводом,
- **1 concept_key = 1 new intro**,
- приоритет более частотных слов,
- POS-diversity: не отдавать подряд только предлоги/местоимения.

Идея скоринга:
`new_score = w1*concept_freq + w2*readiness_fit + w3*pos_diversity - w4*confusability`

## 3.5 Отбор Reinforcement
- берём слова с высоким error-signal,
- избегаем `concept_key`, уже взятых в due/new,
- reinforcement — коррекционный слой для слабых зон.

## 3.6 Ayah Assembly отбор
Сначала eligibility:
- аят допускается только если все его токены уже есть в прогрессе пользователя.

Длинные аяты:
- не давать целиком сверхдлинные (напр. 2:282),
- сегментировать последовательно,
- target длина сегмента 7–8 токенов (max 10).

Distractors:
- только из уже seen токенов пользователя.

## 3.7 Сборка порядка шагов
Порядок по умолчанию:
- due → new blocks → reinforcement → ayah assembly.

Ограничения последовательности:
- минимум 1–2 ayah шага в уроке,
- не допускать монотонных длинных серий одного типа,
- new-intro не повторяет concept,
- карточки due/reinforcement без лишнего дубля concept.

---

## 4) Типы заданий: скиллы, цель, когда и payload

> Ниже перечислены все ключевые step types, что развивают, когда используются и в каком JSON-виде приходят.

## 4.1 `new_word_intro`
**Развивает:** первичное знакомство (reading + semantic anchor).

**Когда выдаётся:**
- только для новых `concept_key`,
- до первых проверочных шагов.

**Формат (пример):**
```json
{
  "type": "new_word_intro",
  "skill_type": "reading",
  "token": {
    "token_id": "tok:2:10:1",
    "location": "2:10:1",
    "ar": "فِى",
    "translation_en": "in",
    "audio_key": "002_010_001.mp3",
    "concept_key": "فِى"
  }
}
```

---

## 4.2 `meaning_choice` (AR -> EN)
**Развивает:** связь арабского слова и значения.

**Когда выдаётся:**
- после new intro,
- в review-блоках,
- в reinforcement при необходимости.

**Формат:**
```json
{
  "type": "meaning_choice",
  "skill_type": "ar_en",
  "token": { "token_id": "tok:2:10:1", "ar": "فِى", "translation_en": "in" },
  "options": ["in", "on", "with", "for"],
  "correct": "in"
}
```

---

## 4.3 `review_card`
**Развивает:** долговременное удержание по SRS.

**Когда выдаётся:**
- из due queue,
- как добивка до target_steps,
- как регулярный повтор.

**Формат:**
```json
{
  "type": "review_card",
  "skill_type": "ar_en",
  "task": "meaning_choice",
  "token": { "token_id": "tok:2:22:10", "ar": "ٱلسَّمَآءِ", "concept_key": "سَمَآء" },
  "options": ["the sky", "the earth", "the day", "light"],
  "correct": "the sky"
}
```

---

## 4.4 `reinforcement`
**Развивает:** коррекцию слабых мест.

**Когда выдаётся:**
- если по concept/token высокий wrong-rate,
- если были recent failures,
- между new-блоками и before summary.

**Формат:**
```json
{
  "type": "reinforcement",
  "skill_type": "listening",
  "task": "audio_to_meaning",
  "token": { "token_id": "tok:2:10:2", "ar": "قُلُوبِهِم", "audio_key": "002_010_002.mp3" },
  "options": ["their hearts", "their eyes", "their hands", "their homes"],
  "correct": "their hearts"
}
```

---

## 4.5 `ayah_build_ar_from_translation`
**Развивает:**
- понимание перевода,
- восстановление арабского порядка токенов,
- контекстное узнавание.

**Когда выдаётся:**
- если весь аят уже покрыт прогрессом,
- как контекстный слой после базовой проработки слов.

**Формат:**
```json
{
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
    {"token_id": "tok:1:6:2", "text": "ٱلصِّرَٰطَ", "is_distractor": false},
    {"token_id": "tok:1:6:1", "text": "ٱهْدِنَا", "is_distractor": false},
    {"token_id": "tok:1:6:3", "text": "ٱلْمُسْتَقِيمَ", "is_distractor": false}
  ],
  "constraints": {"verify_by": "token_id", "translation_unit_policy": "no_split"}
}
```

---

## 4.6 `ayah_build_ar_from_audio`
**Развивает:**
- listening comprehension в контексте,
- mapping audio -> correct arabic order.

**Когда выдаётся:**
- при наличии аудио,
- после достаточного token familiarity.

**Формат:**
```json
{
  "type": "ayah_build_ar_from_audio",
  "skill_type": "listening",
  "surah": 1,
  "ayah": 5,
  "ayah_segment_index": 1,
  "gold_order_token_ids": ["tok:1:5:1", "tok:1:5:2", "tok:1:5:3", "tok:1:5:4"],
  "prompt_audio_keys": ["001_005_001.mp3", "001_005_002.mp3", "001_005_003.mp3", "001_005_004.mp3"],
  "pool": [
    {"token_id": "tok:1:5:3", "text": "وَإِيَّاكَ", "is_distractor": false},
    {"token_id": "tok:1:5:1", "text": "إِيَّاكَ", "is_distractor": false}
  ],
  "constraints": {"verify_by": "token_id"}
}
```

---

## 4.7 `ayah_build_translation_from_ar`
**Развивает:**
- контекстный перевод (AR -> EN),
- правильный порядок смысловых единиц.

**Когда выдаётся:**
- после покрытия слов аята,
- когда нужно проверить перенос знаний из карточек в контекст.

**Формат:**
```json
{
  "type": "ayah_build_translation_from_ar",
  "skill_type": "ar_en",
  "surah": 1,
  "ayah": 7,
  "ayah_segment_index": 1,
  "prompt_ar_tokens": ["صِرَٰطَ", "ٱلَّذِينَ", "أَنْعَمْتَ"],
  "gold_order_token_ids": ["tok:1:7:1", "tok:1:7:2", "tok:1:7:3"],
  "pool": [
    {"token_id": "tok:1:7:2", "text": "(of) those", "is_distractor": false},
    {"token_id": "tok:1:7:1", "text": "(The) path", "is_distractor": false},
    {"token_id": "tok:1:7:3", "text": "You have bestowed (Your) Favors", "is_distractor": false}
  ],
  "constraints": {"verify_by": "token_id", "translation_unit_policy": "no_split"}
}
```

---

## 4.8 `lesson_summary`
**Развивает:** мета-осознание прогресса и мотивацию.

**Когда выдаётся:**
- в конце урока.

**Формат:**
```json
{
  "type": "lesson_summary",
  "stats": {
    "steps_done": 14,
    "accuracy": 0.82,
    "new_concepts": 4,
    "reviews_done": 6,
    "ayah_tasks_done": 2,
    "streak_after_completion": 9
  }
}
```

---

## 5) Implicit SRS: как обновляется память

## 5.1 Почему implicit
- Не заставляем пользователя вручную оценивать Again/Hard/Good/Easy.
- Оценка строится из поведения в задаче.

## 5.2 Входные сигналы
- `is_correct`
- `attempt_count`
- `latency_ms`
- `hint_used`
- (опц.) `step_type`, `skill_type`

## 5.3 Выход обновления
- `next_review_at`
- `stability`
- `difficulty_user`
- `last_outcome_bucket`
- `total_reviews/total_correct/total_wrong`

## 5.4 MVP-правило интервалов (концептуально)
- Correct + fast + no hints → интервал ↑
- Correct but slow/multi-attempt → умеренный интервал
- Wrong / hint-heavy → короткий интервал

---

## 6) Прогресс и engagement-модель

## 6.1 Таблицы
- `quran_tokens`
- `user_token_progress`
- `user_skill_progress`
- `review_history`
- `user_engagement_stats`
- (опц.) `user_lemma_progress`

## 6.2 `user_engagement_stats` (минимум)
- `user_id`
- `current_streak_days`
- `best_streak_days`
- `last_active_at`
- `lessons_completed_total`
- `days_active_30d`
- `completion_rate_7d`

## 6.3 Что считаем активностью дня
- День считается активным, если завершён минимум 1 lesson или threshold по valid answers.
- Таймзона пользователя обязательна для корректного streak.

---

## 7) Что важно / что вторично

## Важно
- Quran-safe корректность.
- Качество lesson generation.
- Консистентность SRS и прогресса.
- Реальная персонализация (ошибки, latency, skill-gap).
- Engagement метрики (streak, D1/D7) как контроль retention.

## Вторично до quality gate
- Полиш UI.
- Визуальные ачивки и эффекты.
- Социальные/комьюнити фичи.
- Любые модули, не влияющие на core learning loop.

---

## 8) Пошаговый план реализации

## Phase A — Generator Sandbox
**Что делаем:**
- дорабатываем `generate_lesson.py` как эталон алгоритма,
- seed-batch прогоны и автодиагностика,
- фиксируем JSON-контракт урока.

**DoD:**
- стабильно валидный урок,
- соблюдены all rules (dedup, ayah eligibility, segment limits),
- качество предсказуемо на серии прогонов.

## Phase B — Progress + Implicit SRS
**Что делаем:**
- заменяем симуляцию прогресса на реальное хранение,
- реализуем implicit SRS update pipeline,
- считаем streak/completion/D1-D7 signals.

**DoD:**
- обновления прогресса корректны,
- интервалы SRS обновляются автоматически,
- engagement данные доступны аналитике.

## Phase C — DB + Backend
**Что делаем:**
- PostgreSQL + миграции + индексы,
- импорт контента + derived-поля,
- API:
  - `GET /lessons/today`
  - `POST /lessons/{id}/answer`
  - `POST /lessons/{id}/complete`
  - `GET /progress/summary`
  - `GET /progress/reviews-due`
  - `GET /engagement/summary`

**DoD:**
- lesson engine работает через API end-to-end,
- данные консистентны,
- миграции надёжны.

## Phase D — Tests + Quality Gate
**Технические:**
- unit: scoring/dedup/segmentation/SRS update,
- integration: lesson→answer→progress,
- regression: seed snapshots.

**Продуктовые:**
- concept/POS diversity,
- duplicate ratio,
- ayah-step passability,
- completion rate,
- retention proxy,
- streak stability, D1/D7.

**DoD:**
- quality gate пройден,
- критичных дефектов нет,
- готово к frontend-wrapping.

## Phase E — Frontend Wrapping
**Что делаем:**
- финализируем UX-контракты под стабильный API,
- строим Lesson Flow/Review/Ayah Assembly/Progress,
- QA UX-потока без изменения core-алгоритма.

**DoD:**
- пользователь проходит полный цикл обучения в приложении.

---

## 9) Milestones
1. **M1:** Генератор уроков стабилен (Phase A)
2. **M2:** Живой прогресс + implicit SRS (Phase B)
3. **M3:** Backend API + DB core (Phase C)
4. **M4:** Пройден quality gate (Phase D)
5. **M5:** Frontend MVP wrapping (Phase E)

---

## 10) Current state snapshot (2026-03-18)

### What we have now
- `POST /lessons/create-next` закреплён как canonical progression entry point.
- `GET /lessons/timeline` и `GET /lessons/{lesson_id}` работают как source-of-truth для history + exact stored lesson instance.
- Lesson lifecycle поддерживает:
  - `generated`
  - `in_progress`
  - `completed`
  - `invalidated`
- Completed lessons read-only.
- Active lesson reuse работает и предотвращает дублирование.
- Lesson completion integrity усилена:
  - нельзя завершить lesson, если он реально не пройден.
- Ayah step lesson-metric inflation исправлен на lesson-level counters.
- Progress trust усилен:
  - `concept_key` persistence исправлен
  - engagement/streak metrics пересчитываются согласованно
  - review distribution улучшен на уровне ayah spread
- Frontend выровнен под canonical `/lessons` flow:
  - `/today` demoted to redirect compatibility
  - review-only UX demoted to additional practice
  - summary возвращает пользователя в canonical next-flow

### Brief note on bug fixes since previous push
- fixed migration/persistence issues for lesson timeline payloads
- fixed create-next / get-by-id contract mismatches
- fixed incomplete lesson completion bug
- fixed lesson metric inflation from ayah multi-token steps
- fixed progress trust issues (`concept_key`, engagement coherence)

## 11) Current strategic focus

Основной фокус больше не на legacy cleanup, а на **Adaptive Next Lesson v2**:
- tempo-aware planning
- stronger consolidation emphasis when lessons are taken soon after each other
- gradual new-word unlocking (1 → 2 → 3 ...)
- reinforcement as a meaningful first-class layer
- concept-aware learning truth
- explainable weighted scoring instead of black-box ML

Primary planning docs:
- `IMPLEMENTATION_PLAN_NEXT_LESSON_PIPELINE.md`
- `IMPLEMENTATION_PLAN_V2_ADAPTIVE_NEXT_LESSON.md`

## 12) Immediate next actions
1. Спроектировать adaptive planner inputs для tempo-aware decision making.
2. Внедрить explainable weighted scoring layer в canonical planner.
3. Добавить expansion ladder для новых слов (`1 -> 2 -> 3`).
4. Усилить reinforcement как отдельный meaningful layer внутри `Next Lesson`.
5. Повторно прогонять multi-day simulations и тюнить thresholds/weights.
