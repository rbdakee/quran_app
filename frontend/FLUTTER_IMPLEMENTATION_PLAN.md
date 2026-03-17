# Flutter Implementation Plan (Phase E)

## Progress Snapshot (2026-03-17)

- Foundation is implemented in `frontend_app` (router, riverpod, network layer, repositories, DTO models, feature modules).
- This plan remains valid as execution checklist for completion/hardening.
- Current stage: late Sprint 2 / Sprint 3 alignment (polish + validation + tests).

Цель: реализовать frontend MVP для Quran App на стабильном backend-контракте.

Основа:
- API контракт: `frontend/API_ENDPOINTS.md`
- Design docs: `design/*`
- Product context: `backend_contracts.md`, `roadmap.md`

---

## 1) Архитектура Flutter (MVP)

Рекомендуемый подход: **feature-first + Riverpod + go_router + Dio**.

### Структура папок

```text
frontend_app/
  lib/
    core/
      theme/
      network/
      router/
      constants/
      utils/
    shared/
      widgets/
      models/
    features/
      today/
        data/
        presentation/
      ayah/
        data/
        presentation/
      summary/
        data/
        presentation/
      progress/
        data/
        presentation/
      reviews/
        data/
        presentation/
      shell/
        presentation/
    main.dart
```

### Пакеты

- `flutter_riverpod`
- `go_router`
- `dio`
- `freezed_annotation`, `json_annotation`
- `build_runner`, `freezed`, `json_serializable` (dev)

---

## 2) Слои ответственности

### Core
- `network`: Dio client, interceptors, базовый error mapper.
- `theme`: design tokens + text styles + spacing constants.
- `router`: все route definitions и tab shell.

### Data
- DTO для всех endpoint-ов.
- Repository интерфейсы и имплементации.
- Mapping DTO -> UI models (если нужно).

### Presentation
- Screen-level state machine.
- Виджеты страниц и общие компоненты.
- Управление submit/feedback/loading/error.

---

## 3) Этапы реализации

## Sprint 1 — Foundation + Contracts

1. Инициализировать Flutter app.
2. Настроить `go_router` с route-map:
   - `/today`
   - `/today/summary`
   - `/progress`
   - `/reviews`
3. Поднять Dio client + базовую конфигурацию `baseUrl`.
4. Создать DTO модели по `frontend/API_ENDPOINTS.md`:
   - `LessonResponse`, `LessonStep`, `TokenPayload`, `AnswerRequest/Response`,
   - `ProgressSummary`, `DueReviewItem`, `EngagementSummary`, `LessonCompleteResponse`.
5. Реализовать repositories:
   - `LessonRepository`
   - `ProgressRepository`
   - `ReviewsRepository`
6. Сделать smoke-вызовы:
   - загрузка урока,
   - получение прогресса,
   - получение due queue.

**Definition of done (Sprint 1):**
- API интеграция работает,
- DTO и network слой стабильны,
- навигационный shell поднят.

---

## Sprint 2 — Today + Ayah Build + Summary

1. Реализовать `TodayLessonScreen`:
   - ProgressStrip,
   - step renderer,
   - option selection + submit,
   - feedback states.

2. Step renderer поддерживает:
   - `new_word_intro`
   - `meaning_choice`
   - `review_card`
   - `reinforcement`
   - `audio_to_meaning`
   - `translation_to_word`

3. Реализовать `AyahBuildWidget` (для `ayah_build_*`):
   - tap-to-add,
   - remove token,
   - ordered_token_ids submit.

4. Реализовать `LessonSummaryScreen`:
   - summary cards,
   - переходы в Progress/Reviews.

**Definition of done (Sprint 2):**
- пользователь проходит полный lesson flow,
- ответы отправляются корректно,
- lesson complete и summary работают.

---

## Sprint 3 — Progress + Reviews + Hardening

1. Реализовать `ProgressDashboardScreen`:
   - статусные карточки,
   - weak concepts,
   - engagement блок.

2. Реализовать `ReviewsDueScreen`:
   - due list,
   - приоритетный запуск review,
   - empty/error/offline states.

3. Довести app shell:
   - общие loading/error компоненты,
   - глобальный status banner,
   - consistent CTA behavior.

4. Тесты:
   - unit для repositories/error mapping,
   - widget tests для ключевых экранных состояний.

**Definition of done (Sprint 3):**
- 3 таба полностью рабочие,
- состояния loading/error/empty покрыты,
- UX соответствует `design/` документации.

---

## 4) State Machine (рекомендуемый шаблон)

Для экранов с async-данными:
- `idle`
- `loading`
- `data`
- `submitting` (для answer)
- `resultShown` (feedback)
- `error`

Критично:
- запретить double-submit,
- при network error сохранять локальный selection,
- retry не должен терять текущий step state.

---

## 5) Mapping step_type -> UI

- `new_word_intro` -> IntroCard + кнопка `Далее`
- `meaning_choice` -> MCQCard
- `review_card` -> MCQCard
- `reinforcement` -> MCQCard (или listening variant)
- `audio_to_meaning` -> AudioPrompt + MCQCard
- `translation_to_word` -> EN prompt + AR options
- `ayah_build_*` -> AyahBuildWidget

---

## 6) Error Handling Policy

Обязательные кейсы:
- `404 NOT_FOUND` (lesson отсутствует)
- `400 LESSON_EXPIRED` (урок завершен)
- `422 VALIDATION_ERROR` (невалидный body)
- network timeout/offline

UI правило:
- показывать user-friendly текст,
- всегда давать восстановление (retry / regenerate / go back).

---

## 7) Definition of Done (Phase E MVP)

1. Полный цикл работает через UI:
   - load lesson -> answer steps -> complete -> summary.
2. Progress + Reviews получают live данные из backend.
3. Все 6 страниц из design docs покрыты.
4. Контракты API реализованы по `frontend/API_ENDPOINTS.md`.
5. Нет блокирующих runtime ошибок на ключевом сценарии.

---

## 8) Технические риски и контроль

1. **Contract drift** между docs и runtime.
   - Контроль: ориентироваться на `frontend/API_ENDPOINTS.md` + `api/routers/*`.

2. **Ayah-build UX complexity**.
   - Контроль: MVP без drag-drop, только tap-to-add/remove.

3. **Нестабильные optional поля step payload**.
   - Контроль: null-safe DTO + defensive rendering.

4. **Состояние lesson в памяти**.
   - Контроль: provider-level session state, аккуратная обработка back/navigation.

---

Status: Approved plan ready for execution.
