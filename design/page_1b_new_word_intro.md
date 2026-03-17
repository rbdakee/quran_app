# Page 1b — New Word Intro Step

## Purpose
Экран знакомства с новым словом. Появляется перед первым MCQ-тестом на это слово.
Задача: дать пользователю спокойно рассмотреть и запомнить слово без давления на ответ.

---

## User Goal
"Увидеть новое слово, понять его значение и звучание, перейти к практике когда готов".

---

## API Context
Step type: `new_word_intro`

Данные из `GET /lessons/today` → `steps[].token`:
- `token.ar` — арабское написание
- `token.translation_en` — перевод (EN)
- `token.location` — surah:ayah:word
- `token.audio_key` — ключ аудио (если доступен)

Submit: `POST /lessons/{id}/answer` с `{ "acknowledged": true }`

---

## Layout Structure (Top → Bottom)

### 1) Header + Progress
Идентично Today Lesson:
- `Шаг X из Y`
- Progress bar

### 2) Step Meta
- Badge: `Новое слово` (accent variant)
- Instruction: `Запомните это слово`

Spacing:
- Margin-top: 16 px
- Gap badge → instruction: 8 px

### 3) Word Presentation Card
Основная карточка — центральный элемент экрана.

Содержимое (сверху вниз, по центру):

#### Arabic Word
- Текст: `token.ar`
- Стиль: `type.arabic.word` (32/44, 600)
- Цвет: `color.text.primary`
- Alignment: center

#### Translation
- Текст: `token.translation_en`
- Стиль: `type.title.md` (20/28, 600)
- Цвет: `color.accent.primary`
- Alignment: center
- Margin-top: 16 px

#### Location Tag
- Текст: `Сура {surah}, аят {ayah}`
- Стиль: `type.label.sm` (12/16, 500)
- Цвет: `color.text.tertiary`
- Margin-top: 12 px

#### Audio Button (если `audio_key` доступен)
- Иконка: speaker / play
- Размер: 48x48
- Radius: pill
- Background: `color.surface.elevated`
- Margin-top: 16 px
- Поведение: tap → воспроизведение произношения слова

Card specs:
- Radius: 16 px
- Padding: 24 px vertical, 20 px horizontal
- Min height: 200 px
- Background: `color.surface.default`
- Border: 1px `color.border.default`

### 4) Mnemonic Hint (optional, v2)
Зарезервированная зона для подсказки/ассоциации.
MVP: не отображать. Оставить в layout для будущего расширения.

### 5) Bottom Action Area
- Primary CTA: `Далее`
- Состояние: всегда enabled (нет проверки ответа)
- При нажатии: отправить `acknowledged: true`, перейти к следующему шагу

Button specs:
- Height: 52 px
- Radius: 12 px
- Full width
- Safe bottom padding: 16–24 px

---

## Interaction Flow

### Load
1. Step рендерится.
2. Если `audio_key` доступен — **автовоспроизведение** произношения (однократно).
3. Пользователь изучает слово.

### Audio
- Tap audio button → повторное воспроизведение.
- Если аудио недоступно (`audio_key` пустой/null) — кнопка скрыта.
- Если загрузка аудио failed — кнопка показывает error state (иконка перечёркнутого динамика), tap → retry.

### Advance
1. Tap `Далее`.
2. `POST /lessons/{id}/answer` с `{ "acknowledged": true }`.
3. Переход к следующему шагу (обычно `meaning_choice` на это же слово).

### Timing
- Нет таймера. Пользователь сам решает, когда готов.
- Telemetry фиксирует `latency_ms` (время от показа до нажатия «Далее»).

---

## State Matrix

### Default
- Карточка со словом, перевод, audio button, CTA `Далее`

### Audio Loading
- Audio button показывает spinner (заменяет иконку play)
- CTA остаётся active (аудио не блокирует навигацию)

### Audio Error
- Audio button: иконка ошибки
- Tooltip/hint: `Аудио недоступно`
- Остальной экран работает нормально

### Network Error (submit)
- CTA показывает retry state
- Локальное состояние не теряется

---

## Visual Direction
Тон: **спокойное знакомство**, не тест.

- Больше воздуха вокруг слова, чем на MCQ-экранах.
- Arabic word — визуальный якорь экрана.
- Нет таймера, нет давления, нет оценки.
- Цвет перевода (accent) помогает связать слово и значение визуально.

---

## Accessibility
- Arabic word: `aria-label` с транслитерацией (если доступна)
- Audio button: label `Прослушать произношение`
- Screen reader читает: слово → перевод → location → кнопка аудио → CTA
- Min touch target: 48x48 для audio button, 52 для CTA

---

## Telemetry
- `new_word_intro_viewed`
- `new_word_audio_played` (count)
- `new_word_acknowledged`
- Fields: `token_id`, `latency_ms`, `audio_played_count`

---

## Definition of Done (Design)
- Layout полностью описан
- Audio autoplay + manual replay определены
- States: default, audio loading, audio error, network error
- Нет оценки — только ознакомление + acknowledge
