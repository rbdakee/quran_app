# Frontend Agent Onboarding (Flutter)

Этот каталог — точка входа для фронтенд-агента.
Цель: быстро начать реализацию Flutter без лишнего чтения backend-тестов и внутренней кухни.

---

## 1) Что читать обязательно (в порядке)

1. **`frontend/API_ENDPOINTS.md`**
   - Полная актуальная документация по endpoint-ам (request/response/errors).

2. **`design/design_system_tokens.md`**
   - Цвета, типографика, spacing, радиусы, состояния.

3. **`design/components_spec.md`**
   - Контракты UI-компонентов и их states.

4. **Страницы дизайна (все 6):**
   - `design/page_1_today_lesson.md`
   - `design/page_2_ayah_build.md`
   - `design/page_3_lesson_summary.md`
   - `design/page_4_progress_dashboard.md`
   - `design/page_5_reviews_due.md`
   - `design/page_6_app_shell_navigation.md`

5. **`backend_contracts.md`**
   - Продуктовый контракт API (концептуально).
   - Внимание: для фактических полей использовать `frontend/API_ENDPOINTS.md` как source-of-truth для текущей реализации.

---

## 2) Что читать полезно, но не обязательно на старте

- `roadmap.md` — стратегический контекст фаз.
- `RUNBOOK.md` — как запускать backend локально.
- `DATA_SCHEMA.md` — полезно для понимания прогресса/SRS, но фронту не обязательно знать все детали БД.

---

## 3) Что **не обязательно** фронтендеру для полноценной работы

- `tests/test_unit_engine.py`
- `tests/test_integration_api.py`
- `tests/test_regression.py`
- `tests/test_srs_scenarios.py`
- `tests/test_learning_pace.py`
- `engine/*` (кроме случаев дебага бизнес-логики)

Фронту достаточно контрактов endpoint-ов и design docs.

---

## 4) Быстрый старт frontend-реализации

- Архитектура: feature-first + typed DTO models.
- Роутинг: `/today`, `/progress`, `/reviews`, `/today/summary`.
- Step renderer в `Today` должен поддержать:
  - `new_word_intro`
  - `meaning_choice`
  - `review_card`
  - `reinforcement`
  - `audio_to_meaning`
  - `translation_to_word`
  - `ayah_build_*`

---

## 5) Важно про контракт

В проекте есть легаси-расхождения между high-level документацией и текущим кодом.
Для frontend интеграции использовать приоритет:

1. `frontend/API_ENDPOINTS.md`
2. `api/routers/*.py` + `api/models/schemas.py`
3. `backend_contracts.md` (как продуктовый ориентир)

---

## Progress Update (2026-03-17)

- `frontend_app` is no longer empty; core implementation exists.
- Routing, feature modules, API layer, repositories, typed models, and shared widgets are already in place.
- Current work mode: finish/polish and validate UX + state handling, not start from scratch.

Status: In implementation (post-foundation).
