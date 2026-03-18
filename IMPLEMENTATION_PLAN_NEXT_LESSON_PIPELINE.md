# Implementation Plan — Next Lesson Unified Learning Pipeline

_Last updated: 2026-03-18_

## Purpose

Этот документ фиксирует наш рабочий план по приведению Quran App к целевой модели:

> **Один понятный пользовательский pipeline через `Next Lesson`,**
> где пользователь стабильно двигается вперёд, чувствует прогресс и достижение,
> реально учит арабский и на практике увеличивает vocabulary.

Документ хранит:
- текущие проблемы,
- их причины,
- последствия для продукта,
- предлагаемые решения,
- порядок внедрения,
- ожидаемый эффект,
- риски.

---

## Product Goal

### What we want

Пользователь должен воспринимать систему так:

1. Я нажимаю **Next Lesson**.
2. Система сама решает, что мне нужно сейчас:
   - повторение due-материала,
   - немного нового,
   - закрепление,
   - иногда ayah practice.
3. Каждый урок ощущается как часть **одного пути**, а не набора разрозненных режимов.
4. Метрики прогресса честны и соответствуют реальному усилию.
5. Рост словаря происходит стабильно и педагогически осмысленно.

### What we explicitly do NOT want

- Параллельные «магистрали» обучения через `Next Lesson` и отдельный review-flow.
- Раздутые achievement-метрики.
- Скрытую внутреннюю логику, которую пользователь не может понять.
- Ситуации, когда один UI-шаг засчитывается как несколько независимых learning events.
- Completion без реального прохождения урока.

---

## Current Diagnosis

По результатам аудита текущая система создаёт активность, но ещё не создаёт чистый и доверяемый learning pipeline.

### Core problems

1. **Pipeline split**
   - `Next Lesson` не является единственным каноническим путём.
   - Отдельный review-flow фактически создаёт вторую основную траекторию.

2. **Ayah steps overcount progress**
   - Один ayah step в UI может приводить к нескольким review events в backend.
   - Из-за этого раздуваются `steps_answered`, `correct_count`, accuracy, review volume и SRS movement.

3. **Lesson completion integrity is broken**
   - Возможен `completed` статус при неполном прохождении урока.

4. **Concept-level learning fidelity is weak**
   - `concept_key` не сохраняется корректно в `user_token_progress`.

5. **Engagement metrics are inconsistent**
   - Streak / active days / completion counters не всегда согласованы.

6. **Review semantics are muddy**
   - due review, reinforcement и optional practice смешиваются.
   - API surface и реальное поведение не всегда совпадают.

7. **Review diversity is weak**
   - Система может чрезмерно гонять одни и те же ayah/token clusters.

---

## Guiding Principles

Все дальнейшие изменения должны проходить через эти принципы.

### 1. One visible action = one understandable result
Если пользователь сделал один шаг, система не должна создавать ощущение, что он сделал пять разных вещей.

### 2. Next Lesson is the product truth
Если пользователь хочет учиться, основной ответ продукта — **Next Lesson**.

### 3. Metrics must be earned
Любой progress signal должен соответствовать реальному effort.

### 4. Pedagogy over synthetic activity
Лучше меньше, но понятнее и полезнее, чем больше, но шумнее.

### 5. Explainability matters
Система должна быть внутренне объяснимой даже если UI пока минималистичный.

---

## Problem Map

## Problem 1 — Split pipeline between Next Lesson and review-only flow

### What happens now
- `Next Lesson` ведёт по daily path.
- `reviews-words` ведёт по special review path.
- В результате обучение идёт не по одному маршруту.

### Why this is bad
- Пользователь не получает одну понятную mental model.
- Продукт сам не знает, что является главным progression path.
- UX становится зависим от endpoint choice, а не от педагогической логики.

### Root cause
- Архитектурно review path оформлен как отдельная важная траектория, а не как часть канонического next-flow.

### Target state
- **`Next Lesson` — единый orchestrator обучения.**
- Он решает mix:
  - due review,
  - reinforcement,
  - controlled new words,
  - occasional ayah practice.
- Отдельный review-mode может существовать только как optional extra mode.

### Solution
1. Переопределить `create-next` / daily lesson generation как **single canonical planner**.
2. Перенести review decision-making внутрь общего lesson builder policy.
3. Оставить review-only endpoint как:
   - debug/tooling,
   - optional extra practice,
   - admin/testing path,
   но не как равный core route.

### Consequences of solving
- Появится один главный пользовательский путь.
- Упростится reasoning про product behavior.
- Улучшится ощущение progression.

### Risks
- Нужно будет аккуратно пересобрать lesson selection rules.
- Возможны изменения контрактов и тестов.

---

## Problem 2 — Ayah steps inflate progress and SRS movement

### What happens now
- Один ayah build step может записывать несколько token-level answer events.
- Lesson counters и SRS advancement раздуваются.

### Why this is bad
- Метрики перестают быть честными.
- Пользовательский effort и progress signal расходятся.
- Возможен ложный рост mastery.

### Root cause
- Backend трактует ayah step как набор отдельных token answers вместо одного pedagogical step.

### Target state
- **Один UI step = один lesson progress event.**
- Внутренние token updates допустимы, но не должны ломать пользовательские counters.

### Solution options

#### Preferred
Разделить:
- `lesson_step_progress`
- `token_srs_updates`

То есть:
- lesson metrics считаются по шагам,
- token-level learning effect считается отдельно.

#### Minimal version
- Не увеличивать `steps_answered` и `correct_count` для каждого token внутри ayah step.
- Учитывать ayah step как один шаг.

### Why this approach
Потому что это сохраняет педагогический смысл: пользователь решал **одну задачу**, а не пять независимых карточек.

### Consequences of solving
- Accuracy станет честнее.
- Progress UI станет лучше соответствовать ощущению пользователя.
- Аналитика перестанет быть раздутой.

### Risks
- Потребуется пересмотр regression tests и summary logic.
- Может измениться текущая динамика mastery.

---

## Problem 3 — Lesson can be completed while incomplete

### What happens now
- Есть случаи, когда урок получает `completed`, хотя `steps_answered < total_steps`.

### Why this is bad
- Ломается доверие к completion.
- Стрик и достижения становятся нечестными.
- Система начинает награждать не обучение, а формальное завершение.

### Root cause
- В `complete_lesson()` нет жёсткого guardrail на фактическое прохождение урока.

### Target state
- Урок может стать `completed` только если действительно завершён.

### Solution
1. Ввести validation в `POST /lessons/{lesson_id}/complete`:
   - completed only if all required steps are answered.
2. Если нужен частичный выход:
   - использовать `in_progress`,
   - либо отдельное состояние `abandoned` / `paused`.

### Why this approach
Это восстанавливает целостность учебного объекта.

### Consequences of solving
- Completion станет значимым сигналом.
- Streak станет честнее.
- Product trust вырастет.

### Risks
- Нужно определить, как обрабатывать старые partially completed records.

---

## Problem 4 — `concept_key` is not persisted correctly

### What happens now
- В `user_token_progress` `concept_key` может быть пустым / `NULL`.

### Why this is bad
- Нельзя качественно строить concept-aware repetition.
- Слабеют weak concept analytics.
- Vocabulary growth анализируется слишком грубо на token-level.

### Root cause
- Persistence layer не сохраняет concept identity последовательно.

### Target state
- Каждый relevant progress row должен иметь корректный `concept_key`.

### Solution
1. Найти все точки записи в `user_token_progress`.
2. Гарантировать сохранение `concept_key` при create/update.
3. Сделать backfill для существующих строк, где это возможно.

### Why this approach
Без concept identity нельзя качественно управлять реальным словарным ростом.

### Consequences of solving
- Улучшится quality of review selection.
- Улучшится аналитика слабых мест.
- Легче строить roadmap к real vocabulary growth.

### Risks
- Понадобится migration/backfill logic.

---

## Problem 5 — Engagement metrics are inconsistent

### What happens now
- `current_streak_days`, `best_streak_days`, `days_active_30d`, `lessons_completed_total` могут жить в разных логиках и расходиться.

### Why this is bad
- Achievement layer становится ненадёжным.
- Пользователь начинает сомневаться в достоверности прогресса.

### Root cause
- Engagement обновляется частично и не всегда пересчитывается как целостная модель активности.

### Target state
- Все engagement metrics должны быть консистентны между собой и выводиться из понятных правил.

### Solution
1. Явно определить source of truth для каждого engagement field.
2. Вынести вычисление streak / active days в одну согласованную функцию.
3. Добавить regression tests на multi-day progression.

### Consequences of solving
- Достижения и streak будут вызывать больше доверия.
- QA по time-travel сценариям станет проще.

### Risks
- Потребуется стабилизировать timezone/date-boundary semantics.

---

## Problem 6 — Review semantics are not clear enough

### What happens now
- due reviews, reinforcement и extra practice могут смешиваться в одном ощущении.
- Параметры вроде `word_limit` не всегда честно отражают фактическое поведение.

### Why this is bad
- Пользователь не понимает, что обязательно, а что опционально.
- Команда не может точно тюнить product behavior.

### Root cause
- API surface и selection policy слабо выровнены.

### Target state
Система должна различать 3 уровня:
1. **Due now** — обязательно к повторению.
2. **Recommended reinforcement** — желательно, но не срочно.
3. **Optional extra practice** — дополнительная практика.

### Solution
1. Явно типизировать review intent внутри lesson planning.
2. Привести endpoint semantics в соответствие реальной logic.
3. В timeline/lesson metadata при желании отражать состав урока понятнее.

### Consequences of solving
- Pipeline станет понятнее.
- Review UX станет менее шумным.

---

## Problem 7 — Review diversity is weak

### What happens now
- Некоторые короткие ayah/token clusters повторяются слишком часто.

### Why this is bad
- Создаётся ощущение зацикленности.
- Vocabulary growth становится неравномерным.
- Пользователь может терять ощущение ширины прогресса.

### Root cause
- Selection logic переиспользует удобные/доступные группы слишком агрессивно.

### Target state
- Повторение должно быть распределённым.
- Один и тот же кластер не должен доминировать много уроков подряд без причины.

### Solution
1. Ввести anti-concentration heuristics.
2. Ограничить повтор одного и того же ayah cluster в коротком окне.
3. Добавить diversity pressure в selector.

### Consequences of solving
- Review станет ощущаться более умно.
- Vocabulary coverage улучшится.

---

## Target Product Model

## Canonical lesson model

Каждый `Next Lesson` строится из одного planner-а, который на вход получает:
- текущий progress,
- due reviews,
- reinforcement needs,
- new-word budget,
- fatigue/load heuristics,
- optional ayah practice rules.

На выходе он собирает **один coherent lesson**.

### Lesson composition policy
В приоритете:
1. due reviews,
2. limited reinforcement,
3. controlled new words,
4. optional ayah practice as pedagogical spice, not metric multiplier.

### User mental model
Пользователь должен чувствовать:
- Сегодняшний урок уже сбалансирован за меня.
- Я не выбираю между competing routes.
- Если у меня есть review pressure, система учитывает это автоматически.
- Новые слова приходят тогда, когда это педагогически уместно.

---

## Implementation Roadmap

## Phase 0 — Stabilization prerequisites

### Goal
Зафиксировать базовые инварианты, без которых дальнейшая работа опасна.

### Tasks
1. Защитить `complete_lesson()` от partial completion.
2. Исправить ayah overcount в lesson metrics.
3. Добавить regression tests на:
   - exact steps answered,
   - no completion when incomplete,
   - honest summary counters.

### Why first
Пока completion и counters нечестны, любые дальнейшие product-выводы будут загрязнены.

### Expected outcome
- Метрики снова начинают что-то значить.
- QA и симуляции становятся надёжнее.

---

## Phase 1 — Unify progression under Next Lesson

### Goal
Сделать `Next Lesson` единственным каноническим pipeline.

### Tasks
1. Спроектировать unified lesson planner.
2. Перенести due/reinforcement/new selection в одну orchestration logic.
3. Перевести review-only path в optional/debug mode.
4. Обновить API/contracts, если нужно.

### Why second
Это центральное продуктовое изменение. Оно должно опираться на уже честные counters и completion semantics.

### Expected outcome
- Один главный learning flow.
- Меньше когнитивного шума.
- Прозрачнее progression logic.

---

## Phase 2 — Restore learning fidelity

### Goal
Сделать progress genuinely pedagogical.

### Tasks
1. Починить `concept_key` persistence.
2. Нормализовать token-vs-concept progression.
3. Ввести diversity heuristics для review selection.
4. Снизить переэкспозицию одних и тех же ayah clusters.

### Expected outcome
- Более реальный рост vocabulary.
- Более качественное распределённое повторение.

---

## Phase 3 — Repair progress trust layer

### Goal
Сделать achievement/streak layer честным и понятным.

### Tasks
1. Починить engagement recomputation.
2. Согласовать streak, active days, completed totals.
3. Вычистить misleading counters.
4. При необходимости добавить internal audit endpoints/tests.

### Expected outcome
- Прогресс вызывает доверие.
- Симуляции на 7–14 дней дают консистентные результаты.

---

## Phase 4 — UX/communication layer

### Goal
Сделать pipeline не только логически правильным, но и субъективно понятным.

### Tasks
1. Уточнить copy и states вокруг Next Lesson.
2. При необходимости пометить внутри lesson summary:
   - reviewed today,
   - new words introduced,
   - reinforcement done.
3. Явно отделить optional practice от core progression.

### Expected outcome
- Пользователь не просто проходит уроки, а понимает, зачем именно этот урок сейчас.

---

## Decision Log

## Decision A — Keep review-only mode, but demote it

### Decision
Не удалять review-only path полностью, но убрать его из роли core progression rail.

### Why
- Полезен для debug, testing, optional extra practice.
- Вредит, если конкурирует с `Next Lesson` как равный магистральный путь.

---

## Decision B — Preserve ayah practice, but stop metric inflation

### Decision
Не удалять ayah tasks.

### Why
Они важны педагогически и эмоционально, но не должны раздувать пользовательские метрики.

---

## Decision C — Prefer honest progress over prettier numbers

### Decision
Если после фиксов прогресс визуально станет «медленнее», это нормально.

### Why
Медленнее, но честнее — лучше, чем быстро, но фальшиво.

---

## Success Criteria

План считается успешно реализованным, когда выполняются следующие условия:

### Learning flow
- `Next Lesson` — основной и понятный путь обучения.
- Пользователю не нужно думать, какой mode выбрать для нормального прогресса.

### Metrics integrity
- `steps_answered <= total_steps` по педагогическому смыслу шага.
- `completed` означает реально завершённый урок.
- Streak и active days консистентны.

### Learning quality
- due review встроен в основной pipeline.
- новые слова приходят дозированно.
- одни и те же token clusters не доминируют без причины.
- vocabulary growth ощущается и реально подтверждается данными.

### Product trust
- Пользовательские цифры соответствуют реальному ощущению effort.
- Прогресс не выглядит «накрученным».

---

## Immediate Next Actions

### Recommended first execution batch
1. Fix incomplete lesson completion guard.
2. Fix ayah overcount in lesson metrics.
3. Add multi-day regression tests for honest counters.
4. Design unified `Next Lesson` planner contract.

### Why this batch first
Это минимальный набор, который:
- убирает самые опасные искажения,
- не даёт дальше строить product decisions на испорченных метриках,
- готовит основу для главного перехода к unified pipeline.

---

## Final Note

Наша цель — не просто «починить баги».

Наша цель — сделать так, чтобы пользователь:
- чувствовал понятный путь,
- видел честный прогресс,
- реально учил арабский,
- и возвращался не из-за искусственных цифр, а из-за ощущения настоящего роста.

Этот документ — рабочая карта именно к этой цели.
