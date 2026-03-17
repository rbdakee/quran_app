# Audio Playback Specification (MVP)

## Purpose
Единая спецификация аудио-взаимодействия для всех step types, использующих звук:
- `new_word_intro` (pronunciation)
- `audio_to_meaning` (listening quiz)
- `ayah_build_ar_from_audio` (listen & build)

---

## 1) Audio Source Contract

### URL Pattern
```
{base_url}/audio/{audio_key}.mp3
```
- Format: MP3 (fallback: OGG если потребуется)
- Bitrate: 64–128 kbps (речь, не музыка)
- Duration: 1–8 секунд (одно слово или короткий сегмент)

### Availability
- `audio_key` приходит в `token` payload из `GET /lessons/today`
- Если `audio_key` пустой/null → аудио недоступно для этого токена
- Frontend должен gracefully handle отсутствие аудио

> **Note:** Точный URL-паттерн может измениться. Вынести `audioBaseUrl` в конфигурацию Dio client.

---

## 2) Audio Player Component

### Variants

#### A) Inline Mini Player
Используется внутри PromptCard для `new_word_intro`.

Anatomy:
- Круглая кнопка (48x48)
- Иконка: ▶ play / ⏸ pause / 🔄 replay
- Без timeline/scrubber

Specs:
- Size: 48x48
- Radius: pill (24)
- Background: `color.surface.elevated`
- Icon size: `size.icon.lg` (24)
- Icon color: `color.accent.primary`

#### B) Prompt Audio Player
Используется как основной prompt в `audio_to_meaning` и `ayah_build_ar_from_audio`.

Anatomy:
- Крупная кнопка play (64x64)
- Текст-hint: `Прослушайте и выберите ответ` / `Прослушайте и соберите`
- Replay button (отдельный, меньше)
- Optional: счётчик воспроизведений `▶ 2/3`

Specs:
- Play button: 64x64, radius pill
- Background: `color.surface.elevated`
- Icon: 28px, `color.accent.primary`
- Replay button: 36x36, ghost style
- Hint text: `type.body.md`, `color.text.secondary`
- Container padding: 20px
- Min height: 120px

---

## 3) States

### Idle
- Кнопка показывает ▶
- Ready to play

### Loading
- Spinner заменяет иконку play
- Кнопка не кликабельна
- Timeout: 10 секунд → переход в Error

### Playing
- Иконка меняется на ⏸ (pause)
- Optional: subtle pulse animation на кнопке
- По окончании → автоматически возврат в Idle (ready for replay)

### Paused
- Иконка: ▶
- При повторном tap: продолжение с текущей позиции

### Error
- Иконка: перечёркнутый динамик / ⚠
- Hint text: `Не удалось загрузить аудио`
- Tap → retry загрузки
- После 3 retry: показать persistent error, разрешить пропуск шага

### Unavailable
- `audio_key` отсутствует
- Компонент **не рендерится** (не показываем disabled кнопку)
- Для `audio_to_meaning` / `ayah_build_ar_from_audio`: fallback — показать текстовую подсказку вместо аудио

---

## 4) Behavior Rules

### Autoplay
| Step type | Autoplay | Replay limit |
|-----------|----------|--------------|
| `new_word_intro` | ✅ да, однократно при загрузке | unlimited |
| `audio_to_meaning` | ✅ да, однократно | 3 (MVP) |
| `ayah_build_ar_from_audio` | ✅ да, однократно | 3 (MVP) |

### Replay Limit (для quiz steps)
- Цель: имитировать реальное аудирование, не давать бесконечные переслушивания.
- После лимита: кнопка переходит в disabled, hint: `Лимит прослушиваний`
- Лимит сбрасывается при retry после ошибки.
- **v2:** сделать лимит настраиваемым через settings.

### Concurrent Playback
- Только одно аудио одновременно.
- При запуске нового — предыдущее останавливается.
- При уходе со step → остановить воспроизведение.

### Background / Navigation
- Уход с экрана → stop + release audio resources.
- Возврат назад → state сбрасывается в idle (не resume).

---

## 5) Preloading Strategy (MVP)

- **Текущий step:** preload при рендеринге step.
- **Следующий step:** preload в фоне после загрузки текущего (если тоже audio step).
- **Не preload** весь урок целиком (экономия трафика).

Cache:
- In-memory для текущей сессии.
- Нет persistent cache в MVP.
- v2: offline cache для downloaded lessons.

---

## 6) Error Handling

| Scenario | Behavior |
|----------|----------|
| Network timeout (>10s) | Show error state, allow retry |
| 404 (audio not found) | Show unavailable, allow skip |
| Decode error | Show error, retry once, then unavailable |
| Device audio error | System-level, show generic error |

### Fallback for Quiz Steps
Если аудио **критично** для шага (`audio_to_meaning`, `ayah_build_ar_from_audio`) и полностью недоступно:
- Показать fallback prompt: арабский текст вместо аудио
- Добавить badge: `Аудио недоступно — текстовый режим`
- Telemetry: `audio_fallback_used`

---

## 7) Accessibility

- Audio button: `aria-label` = `Прослушать` / `Воспроизвести аудио`
- Playing state: announce `Воспроизведение`
- Error state: announce `Ошибка загрузки аудио`
- Replay count (для quiz): announce `Осталось N прослушиваний`
- Не полагаться только на аудио для передачи смысла — всегда иметь текстовый fallback

---

## 8) Visual Summary

```
┌─────────────────────────────┐
│       Prompt Area           │
│                             │
│    ┌──────────────────┐     │
│    │  🔊 hint text    │     │
│    │                  │     │
│    │     [ ▶ ]        │     │  ← 64x64 play button
│    │                  │     │
│    │   [ 🔄 replay ]  │     │  ← 36x36 ghost
│    │   ▶ 1/3          │     │  ← replay counter
│    └──────────────────┘     │
│                             │
└─────────────────────────────┘
```

---

## 9) Telemetry

Events:
- `audio_play_started`
- `audio_play_completed`
- `audio_play_paused`
- `audio_play_error`
- `audio_fallback_used`
- `audio_replay_limit_reached`

Fields:
- `step_type`, `token_id`, `audio_key`
- `play_count`, `duration_ms`
- `error_type` (timeout / 404 / decode)

---

## 10) Platform Notes (Flutter)

- Пакет: `just_audio` или `audioplayers`
- Рекомендация: `just_audio` (лучше streaming, preload, error handling)
- Инициализация: lazy per-step, dispose on step change
- iOS: настроить audio session category (playback, mix with others)
- Android: handle audio focus корректно

---

## Definition of Done
- Два варианта player (inline mini + prompt audio) специфицированы
- States: idle / loading / playing / paused / error / unavailable
- Autoplay + replay limits определены
- Fallback для недоступного аудио в quiz steps
- Preload strategy для MVP
- Accessibility labels
