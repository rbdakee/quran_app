# Page 4 — Progress Dashboard

## Purpose
Единая точка, где пользователь видит обучение в динамике: что уже освоено, что слабо, и что делать дальше.

---

## User Goal
"Быстро понять свой текущий уровень и приоритетные зоны повторения".

---

## API Contracts
- `GET /progress/summary`
- `GET /engagement/summary`

Ожидаемые группы данных:
- due counts
- learned / in-learning / mastered
- weak concepts
- 7d snapshot
- streak / best streak / active days

---

## Layout Structure

### 1) Header
- Title: `Прогресс`
- Date range hint: `последние 7 дней`

### 2) Learning Status Cards
Три ключевые карточки:
- `Изучается`
- `Закреплено`
- `Освоено`

Плюс отдельная карточка `К повторению сегодня` (due).

### 3) Trend Section (7d)
- Mini chart (line or bars)
- Метрики: completion, accuracy trend, lessons completed

### 4) Weak Concepts Section
Список проблемных концептов:
- Arabic token/concept
- error signal / confidence indicator
- CTA: `Повторить`

### 5) Engagement Section
- Current streak
- Best streak
- Active days (30d)
- Completion rate (7d)

---

## Information Hierarchy
1. Что делать сегодня (due/weak)
2. Где я сейчас (in-learning/mastered)
3. Как иду в динамике (trends/engagement)

---

## Visual Specs
- Card radius: 14–16 px
- Grid gap: 12 px
- Section gap: 20 px
- Chart height: 140–180 px

Типографика:
- Section title: 18/20 px
- Metric value: 24–28 px
- Labels: 13–14 px

---

## Interaction Notes
- Tap weak concept -> открывает Reviews с pre-filter
- Tap due card -> переходит в Reviews
- Pull-to-refresh для обновления статистики

---

## States

### Loading
- skeleton карточек + chart placeholder

### Empty (new user)
- friendly onboarding state:
  - `Пока нет данных прогресса`
  - CTA: `Начать первый урок`

### Error
- non-blocking message + retry button

---

## Accessibility
- Charts должны иметь текстовую альтернативу
- Цвета трендов дополняются символами/подписями
- Все key metrics доступны screen reader

---

## Telemetry
- `progress_dashboard_viewed`
- `progress_due_clicked`
- `progress_weak_concept_clicked`
- `progress_refresh`

---

## Definition of Done (Design)
- Dashboard отражает actionable insight, не только цифры
- Есть версия для empty/new-user состояния
- Ясная навигация в Reviews/Today
