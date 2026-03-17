# Page 1 — Today Lesson (MCQ Step)

## Purpose
Главный экран ежедневного обучения. Пользователь проходит шаги урока по одному, с мгновенной проверкой ответа и понятным прогрессом.

Экран должен:
- минимизировать когнитивную нагрузку,
- удерживать фокус на одном действии,
- давать быстрый feedback,
- визуально подтверждать прогресс к завершению урока.

---

## User Goal
"Сделать один шаг урока быстро и без путаницы, понять правильно/неправильно, перейти дальше".

---

## Primary API Contracts
- `GET /lessons/today` — получение lesson + steps
- `POST /lessons/{id}/answer` — отправка ответа на текущий шаг

Поддерживаемые step types на этой странице:
- `meaning_choice`
- `review_card` (MCQ-представление)
- `reinforcement` (MCQ/audio-to-meaning вариант)

---

## Layout Structure (Top → Bottom)

### 1) App Header
- Title: `Сегодня`
- Optional right actions:
  - `Пауза` (если потребуется в будущем)
  - `Выход` (подтверждение перед выходом)

Height: 56 px  
Horizontal padding: 16 px

### 2) Progress Block
- Text: `Шаг {current} из {total}`
- Linear progress bar
- Optional secondary metric: `% completion`

Spacing:
- Margin-top: 8 px
- Gap (text -> bar): 8 px
- Progress bar height: 8 px

### 3) Step Meta
- Badge skill type: `AR → EN` / `Listening` / `Review`
- Instruction text:
  - пример: `Выберите правильный перевод`

Spacing:
- Margin-top: 16 px
- Gap badge -> instruction: 8 px

### 4) Main Prompt Card
Содержит ядро задания:
- Arabic token (`token.ar`) — крупно и по центру
- Optional transliteration/help (если включим позже)
- Optional audio mini-control (для listening-варианта)

Card:
- Radius: 16 px
- Internal padding: 20 px
- Min height: 140 px

Typography:
- Arabic: 32 px / SemiBold / center
- Helper text: 14 px / Regular / secondary color

### 5) Options List
4 карточки-ответа (`options[]`), вертикально.

Option tile:
- Height: min 52 px
- Radius: 12 px
- Padding: 14 px horizontal
- Gap between options: 10 px

States:
- `default`
- `pressed`
- `selected`
- `correct`
- `wrong-selected`
- `disabled`

### 6) Bottom Action Area
- Primary CTA:
  - до ответа: `Проверить`
  - после успеха: `Далее`
  - после ошибки (зависит от policy): `Попробовать снова` или `Далее`

Button:
- Height: 52 px
- Radius: 12 px
- Full width

Safe bottom padding: 16–24 px

---

## Color Tokens (v1)
- `bg`: `#0F1115`
- `surface`: `#171A21`
- `surface-2`: `#1E2430`
- `text-primary`: `#F5F7FA`
- `text-secondary`: `#A7B0C0`
- `accent`: `#5B8CFF`
- `success`: `#23C16B`
- `error`: `#FF5D5D`
- `border`: `#2A3140`

Contrast targets:
- body text >= 4.5:1
- large text >= 3:1

---

## Interaction Flow

### Initial Load
1. Страница открыта.
2. Пока нет данных: показываем skeleton.
3. После загрузки lesson: рендерим `step_index = 0`.

### Answer Submission
1. Пользователь выбирает option.
2. CTA `Проверить` становится активной.
3. На tap:
   - disable inputs,
   - show loading state на CTA,
   - `POST /lessons/{id}/answer`.
4. При ответе:
   - подсветка correct/wrong,
   - feedback message,
   - CTA меняется на следующий action.

### Next Step
1. Tap `Далее`.
2. Переход на следующий step без полного reload.
3. Обновляется progress + header metrics.

---

## State Matrix

### Loading
- Skeleton для prompt card + 4 options + button

### Empty
- Нет lesson на сегодня: блок `На сегодня урок завершён`
- CTA: `Открыть Progress`

### Error
- Message: `Не удалось загрузить урок`
- CTA: `Повторить`
- Secondary: `Назад`

### Offline
- Top banner: `Нет сети. Попробуйте позже.`
- Блокируем submit

### Answer Errors
- `VALIDATION_ERROR`: показать локальную ошибку формы
- `STEP_ALREADY_ANSWERED`: синхронизировать state и перейти дальше
- `LESSON_EXPIRED`: предложить перезагрузить урок

---

## Accessibility
- Min touch target: 44x44 (цель: 52 высота)
- Focus visible для всех интерактивов
- Screen reader labels:
  - token card,
  - each option with index,
  - button action state
- Не завязывать смысл только на цвет (добавить иконку/текст feedback)

---

## Telemetry
События:
- `lesson_step_viewed`
- `lesson_option_selected`
- `lesson_answer_submitted`
- `lesson_answer_result`
- `lesson_step_advanced`

Собирать:
- `lesson_id`, `step_id`, `step_index`, `step_type`
- `latency_ms`
- `attempt_count`
- `is_correct`

---

## Definition of Done (Design)
- Полный макет экрана (default + all states)
- Ясная спецификация spacing/typography/colors
- Интеракции submit/feedback/next визуально определены
- Готово к handoff во frontend implementation
