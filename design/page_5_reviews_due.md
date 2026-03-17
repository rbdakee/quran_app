# Page 5 — Reviews Due Queue

## Purpose
Экран очереди повторений. Позволяет пользователю быстро увидеть, что пора повторить, и запустить focused review flow.

---

## User Goal
"Запустить повторение без лишних шагов и закрыть наиболее важные due-элементы".

---

## API Contract
Источник: `GET /progress/reviews-due`

Каждый элемент списка должен включать минимум:
- token/concept identity
- приоритет/срочность
- optional last seen / difficulty cues

---

## Layout Structure

### 1) Header
- Title: `Повторения`
- Subtext: `Доступно к повторению: N`

### 2) Queue Summary Bar
- Badges:
  - `Срочные`
  - `Обычные`
  - `Сложные`

### 3) Reviews List
Каждая строка:
- Arabic token/concept
- secondary meta (например: overdue time / weak flag)
- right action icon

### 4) Quick Actions
- Primary: `Начать повторение`
- Secondary: `Сначала срочные`
- Optional: `Повторить 10`

---

## Prioritization UX
Порядок по умолчанию:
1. overdue + weak
2. overdue normal
3. due soon

Пользователь должен понимать почему элемент выше в очереди.

---

## Row Design
- Height: 64–72 px
- Left: token/concept
- Middle: status chips (`weak`, `overdue`)
- Right: chevron / quick-start icon

Selection mode (optional v2):
- multi-select for batch review

---

## Empty/Zero State
Если due=0:
- Message: `Сейчас нет слов для повторения`
- CTA: `Вернуться к уроку`
- Secondary note: `Проверьте позже сегодня`

---

## Error/Offline State
- Error block + retry
- Если есть cached due list, показать stale data с маркером

---

## Accessibility
- Каждая строка имеет label с priority context
- Не полагаться только на цвет для срочности
- Крупные touch targets

---

## Telemetry
- `reviews_due_viewed`
- `reviews_due_start_clicked`
- `reviews_due_priority_filter_used`
- `reviews_due_item_opened`

---

## Definition of Done (Design)
- Очередь визуально объясняет приоритет
- Empty/error/offline состояния проработаны
- Быстрый старт review занимает 1 тап
