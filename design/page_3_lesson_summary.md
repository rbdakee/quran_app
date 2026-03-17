# Page 3 — Lesson Complete / Summary

## Purpose
Закрывающий экран урока. Закрепляет достижение, показывает результат и задаёт следующий полезный шаг (прогресс/повторения).

---

## User Goal
"Понять, как я прошёл урок, увидеть прогресс и мотивацию продолжать".

---

## API Contract
Источник: `POST /lessons/{id}/complete`

Отображаем:
- `summary.steps_done`
- `summary.accuracy`
- `summary.new_concepts_learned`
- `summary.reviews_done`
- `summary.ayah_tasks_done`
- `engagement.streak_days`
- `engagement.lessons_completed_total`
- `engagement.completion_rate_7d`

---

## Layout Structure

### 1) Success Hero
- Large icon/checkmark
- Headline: `Урок завершён`
- Subtext: краткое reinforcement-сообщение

### 2) Key Metrics Grid
2x3 карточки метрик:
1. Шаги
2. Accuracy
3. Новые слова
4. Повторения
5. Ayah tasks
6. Streak

Card style:
- compact, однородная высота
- value крупно, label вторично

### 3) Engagement Block
- `Серия дней: X`
- `Уроков всего: Y`
- `7-дневная completion rate: Z%`

### 4) Action Buttons
- Primary: `К прогрессу`
- Secondary: `К повторениям`
- Tertiary/text: `На главный`

---

## Visual Direction
Тон: спокойная гордость, не геймифицированный шум.

Цель:
- отметить успех,
- не перегрузить эмодзи/анимациями,
- быстро перенаправить к следующему действию.

---

## Microcopy (examples)
- Headline: `Отличная работа`
- Support: `Вы завершили урок и укрепили словарную базу.`
- Streak line: `Серия: 9 дней подряд`

Никакой манипулятивной риторики. Только факт + мягкая мотивация.

---

## States

### Loading
- skeleton метрик

### Success
- все блоки доступны

### Partial data fallback
Если часть полей отсутствует:
- показываем `—` вместо значения
- экран всё равно рендерится без падения

### Error
Если complete не отработал:
- экран-ошибка с retry
- не теряем локальную summary (если уже есть)

---

## Accessibility
- Контраст текста и цифр по WCAG
- Метрики читаются screen reader как `label + value`
- CTA расположены с достаточными отступами

---

## Telemetry
- `lesson_summary_viewed`
- `lesson_summary_action_click` (`progress` | `reviews` | `home`)

---

## Definition of Done (Design)
- Готов full layout + states
- Понятный hierarchy: success -> metrics -> next action
- Микрокопи утверждены
