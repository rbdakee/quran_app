# Components Specification (MVP v1)

## Purpose
Подробная спецификация UI-компонентов для экранов:
- Today Lesson
- Ayah Build
- Lesson Summary
- Progress Dashboard
- Reviews Due

Документ только про дизайн/поведение компонентов. Без frontend-реализации.

---

## 1) AppTopBar

### Role
Глобальный верхний бар страницы.

### Anatomy
- Left: title
- Optional right: icon buttons (pause/close/settings)

### Specs
- Height: 56
- Padding X: 16
- Title style: `type.title.sm`

### States
- default
- withBanner (если сверху status banner)

---

## 2) ProgressStrip

### Role
Показывает текущий шаг урока.

### Anatomy
- Meta text: `Шаг X из Y`
- Linear track + fill

### Specs
- Text style: `type.body.sm`
- Bar height: 8
- Radius: pill

### States
- normal
- completed (100%)

---

## 3) StepTypeBadge

### Role
Маркер типа задания (`AR→EN`, `Listening`, `Review`, `Ayah Build`).

### Specs
- Height: 24–28
- Padding X: 10
- Radius: pill
- Text: `type.label.sm`

### Variants
- neutral
- accent
- listening (info)

---

## 4) PromptCard

### Role
Основная зона задания.

### Anatomy
- Badge (optional)
- Primary prompt (arabic or instruction)
- Secondary helper text
- Optional media control (audio)

### Specs
- Radius: 16
- Padding: 20
- Min height: 140

### States
- default
- loading (skeleton)
- error-inline

---

## 5) OptionTile

### Role
Один вариант ответа для MCQ.

### Specs
- Height: 52
- Radius: 12
- Padding X: 14
- Border: 1px default

### States
- default
- hover
- pressed
- selected
- correct
- wrongSelected
- disabled

### Behavior
- Single-select only in MVP
- Submit отдельно, не auto-submit

---

## 6) PrimaryButton

### Role
Главное действие экрана (`Проверить`, `Далее`, `Начать`).

### Specs
- Height: 52
- Radius: 12
- Full-width
- Label: `type.label.md`

### States
- enabled
- disabled
- loading
- success-context (optional)

---

## 7) SecondaryButton / GhostButton

### Role
Вторичные действия (`Повторить`, `Назад`, `К прогрессу`).

### Variants
- secondary (outline)
- ghost (text)

### States
- enabled
- disabled
- pressed

---

## 8) FeedbackBanner

### Role
Показывает результат проверки ответа.

### Types
- success
- error
- warning
- info

### Anatomy
- Icon
- Message text
- Optional helper

### Specs
- Radius: 12
- Padding: 12–14

---

## 9) TokenChip (Ayah Build)

### Role
Токен в пуле/слоте для сборки последовательности.

### Specs
- Height: 40–44
- Radius: pill/10
- Padding X: 10–12

### States
- available
- selected/inSlot
- correct
- wrong
- disabled

### Notes
- Внутренний ключ всегда `token_id`
- Текст может совпадать визуально, id не должен теряться

---

## 10) AnswerSlot (Ayah Build)

### Role
Позиция порядка в конструкторе.

### Anatomy
- Index label
- Drop/tap zone
- Filled content (token)

### Specs
- Height: 44–48
- Radius: 10
- Border dashed для empty

### States
- empty
- filled
- active
- correct
- wrong

---

## 11) AudioControl

### Role
Управление воспроизведением для listening шагов.

### Controls (MVP)
- Play/Pause
- Replay

### Optional v2
- Speed 0.75x/1x/1.25x

### States
- idle
- loading
- playing
- paused
- error

---

## 12) MetricCard

### Role
Карточка метрики на Summary/Progress.

### Anatomy
- Value
- Label
- Optional delta/icon

### Specs
- Radius: 14
- Padding: 14–16
- Value style: 24–28 semibold

---

## 13) WeakConceptRow

### Role
Строка слабого концепта на Progress.

### Anatomy
- Arabic/concept title
- Error/confidence meta
- CTA icon/button

### States
- default
- pressed
- focused

---

## 14) DueReviewRow

### Role
Элемент очереди повторений.

### Anatomy
- Token/concept
- Priority chips (`weak`, `overdue`)
- Right chevron/action

### Specs
- Height: 64–72
- Divider bottom optional

---

## 15) StatusBanner (Global)

### Role
Глобальное сообщение о сети/ошибке.

### Types
- offline
- apiError
- maintenance

### Behavior
- Sticky top (под top bar)
- Non-blocking, но заметный

---

## 16) LoadingSkeleton

### Role
Унифицированный скелетон для всех страниц.

### Rules
- Повторяет реальную геометрию компонентов
- Пульсация мягкая, не агрессивная
- Отключать при reduce-motion

---

## 17) EmptyStateBlock

### Role
Показывается при отсутствии данных.

### Anatomy
- Icon/illustration placeholder
- Title
- Body text
- Primary CTA

### Usage
- no lesson today
- no reviews due
- no progress yet

---

## 18) ErrorStateBlock

### Role
Recoverable error with retry action.

### Anatomy
- Error icon
- Message
- Primary `Повторить`
- Optional secondary action

---

## 19) Component Usage Matrix

- Today Lesson: `AppTopBar`, `ProgressStrip`, `StepTypeBadge`, `PromptCard`, `OptionTile`, `FeedbackBanner`, `PrimaryButton`
- Ayah Build: `AppTopBar`, `ProgressStrip`, `PromptCard`, `AudioControl`, `TokenChip`, `AnswerSlot`, `FeedbackBanner`, `PrimaryButton`
- Summary: `AppTopBar`, `MetricCard`, `PrimaryButton`, `SecondaryButton`
- Progress: `AppTopBar`, `MetricCard`, `WeakConceptRow`, `StatusBanner`, `EmptyStateBlock`
- Reviews: `AppTopBar`, `DueReviewRow`, `PrimaryButton`, `EmptyStateBlock`, `ErrorStateBlock`

---

## 20) Handoff Quality Checklist
- У каждого компонента есть role + anatomy + states
- Нет конфликтов размеров между экранами
- States cover loading/error/empty/success
- Компоненты совместимы с token-системой
