# Page 2 — Ayah Build Step (Order Construction)

## Purpose
Экран для самых ценных контекстных упражнений:
- `ayah_build_ar_from_translation`
- `ayah_build_ar_from_audio`
- `ayah_build_translation_from_ar`

Задача UX: дать пользователю собрать последовательность без фрустрации, с высокой читаемостью и четкой обратной связью.

---

## User Goal
"Понять подсказку (перевод или аудио), собрать правильный порядок токенов и получить ясный результат".

---

## API Fields Used
Общие:
- `surah`, `ayah`, `ayah_segment_index`
- `gold_order_token_ids`
- `pool[]` (token_id, text, is_distractor)

Вариативные:
- `prompt_translation_units[]` (для AR from translation)
- `prompt_audio_keys[]` (для AR from audio)
- `prompt_ar_tokens[]` (для translation from AR)

Ответ:
- `ordered_token_ids[]` в `POST /lessons/{id}/answer`

---

## Core UX Principle
Проверка по `token_id`, а не по визуальному тексту.

Это значит:
- внутренняя модель выбора хранит id,
- UI обязан стабильно отражать порядок,
- duplicate-looking tokens не должны ломать логику.

---

## Layout Structure

### 1) Header + Progress
Аналогично Today Lesson:
- `Шаг X из Y`
- progress bar

### 2) Task Prompt Panel
В зависимости от типа:

#### A) AR from translation
- Заголовок: `Соберите арабскую фразу по переводу`
- Chips/lines из `prompt_translation_units`

#### B) AR from audio
- Заголовок: `Соберите по аудио`
- Audio controls (play/pause/replay)
- optional playback speed

#### C) Translation from AR
- Заголовок: `Соберите перевод`
- Строка из `prompt_ar_tokens`

### 3) Answer Slots Area
Горизонтально/переносом по строкам.
Пустые слоты с нумерацией позиции:
- Slot 1, Slot 2, Slot 3...

Заполненный слот показывает:
- token text
- индекс
- action `remove`

### 4) Token Pool Area
Карточки токенов из `pool[]`.
Два режима взаимодействия:
1. Tap-to-add (MVP, обязательный)
2. Drag-and-drop (optional enhancement)

### 5) CTA Area
- `Проверить` (активна только если заполнены все необходимые слоты)
- После проверки: `Далее`

---

## Interaction Rules

### Assembly
- Tap token -> добавляется в первый пустой слот.
- Tap filled slot token -> удаляется и возвращается в pool.
- Reorder:
  - MVP: через swap-кнопки (← →) или remove+reinsert
  - v2: drag within slots

### Validation UX
До submit:
- если слоты не заполнены: CTA disabled + helper text

После submit:
- correct: зелёная подсветка всех слотов
- wrong: подсветка неверных позиций
- optional hint: `Некоторые токены стоят не на месте`

---

## Visual Specs
- Slot height: 44–48 px
- Slot radius: 10 px
- Pool chip height: 40–44 px
- Section spacing: 16 px
- Instruction text width: max readable (не растягивать в одну длинную строку)

Arabic display rules:
- RTL rendering корректный
- достаточный line-height
- не смешивать LTR/RTL без визуального разделения

---

## Error Handling
- `ORDER_MISMATCH`: показать понятный feedback без технических кодов
- `VALIDATION_ERROR`: подсветить недостающие/некорректные данные
- network error: сохранить локальную сборку и предложить retry

---

## Accessibility
- Все chips доступны с клавиатуры/assistive tech
- У слотов есть aria-label `Позиция N`
- Audio controls имеют текстовые labels
- Для ошибок — текст + иконка, не только цвет

---

## Telemetry
- `ayah_step_viewed`
- `ayah_token_added`
- `ayah_token_removed`
- `ayah_answer_submitted`
- `ayah_answer_result`

Поля:
- `step_type`, `attempt_count`, `latency_ms`, `pool_size`, `segment_length`

---

## Definition of Done (Design)
- Есть версии для 3 типов ayah build
- Прописан fallback без drag-and-drop
- Все states задокументированы (loading/error/success)
- Четкая спецификация для фронтенда по token_id-driven поведению
