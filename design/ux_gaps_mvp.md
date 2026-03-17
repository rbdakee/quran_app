# UX Gaps — MVP Addendum

## Purpose
Короткие спецификации для UX-элементов, не покрытых основными page-документами,
но необходимых для полноценного MVP.

---

## 1) Splash / Launch Screen

### Назначение
Первый экран при холодном старте. Показывается пока Flutter engine инициализируется.

### Layout
- Background: `color.bg.primary` (#0F1115)
- Центр: логотип / название приложения
  - Текст: `Quran Learning` (или бренд-name)
  - Стиль: `type.display.lg` (32/40, 600)
  - Цвет: `color.text.primary`
- Под логотипом: subtle loading indicator
  - Circular spinner, 24px, `color.accent.primary`
  - Margin-top: 24px

### Duration
- Нативный splash: пока Flutter engine загружается (~1–2s)
- Flutter splash: показывать до завершения первого API call или timeout (5s)
- После готовности: fade out (200ms) → первый экран

### Platform
- Android: `launch_background.xml` + Flutter SplashScreen
- iOS: `LaunchScreen.storyboard`
- Оба: одинаковый визуал для consistency

---

## 2) First Launch / Onboarding

### MVP: Minimal Flow
Полный onboarding (туториал, выбор уровня) → v2.

MVP flow:
1. Splash
2. Сразу `/today` (первый урок)
3. Если `GET /lessons/today` возвращает данные → рендерим урок
4. Если нет данных → EmptyStateBlock: `Добро пожаловать! Ваш первый урок скоро будет готов.`

### Welcome Banner (optional, one-time)
При первом запуске — dismissible banner в верхней части Today:
- Text: `Добро пожаловать! Каждый день вы будете изучать новые слова из Корана.`
- Style: `color.info.bg` background, `color.info.default` accent
- Radius: 12px
- Dismiss: tap X → скрыть навсегда (local storage flag)

---

## 3) Toast / Snackbar (Global Notifications)

### Назначение
Короткие неблокирующие сообщения для событий вне lesson flow:
- Сеть восстановлена
- Данные обновлены
- Действие выполнено

### Anatomy
- Container: full-width с horizontal padding 16px
- Height: auto (min 48px)
- Radius: 12px
- Background: `color.surface.elevated`
- Border: 1px `color.border.default`
- Text: `type.body.md`, `color.text.primary`
- Optional icon left (16px)
- Optional action button right (text button)

### Position
- Bottom of screen, above bottom navigation
- Margin-bottom: 8px above tab bar

### Behavior
- Appear: slide up from bottom (150ms)
- Auto-dismiss: 3 секунды (default), 5 секунд (с action button)
- Manual dismiss: swipe down
- Queue: максимум 1 toast видим, следующий ждёт в очереди
- Не перекрывать: CTA buttons на активном экране

### Variants
| Variant | Icon | Use case |
|---------|------|----------|
| info | ℹ️ | Данные обновлены, нейтральное уведомление |
| success | ✅ | Действие выполнено |
| warning | ⚠️ | Нестабильное соединение |
| error | ❌ | Операция не удалась (если не покрыта inline error) |

---

## 4) Pull-to-Refresh

### Где используется
- Progress Dashboard
- Reviews Due

### Visual
- Trigger: потянуть вниз > 80px
- Indicator: circular progress (Material style)
  - Size: 36px
  - Color: `color.accent.primary`
  - Background: `color.surface.elevated` circle (40px)
- Position: центр, над контентом
- При release: indicator фиксируется, данные загружаются
- По завершении: indicator slide up + fade out (200ms)

### Behavior
- Во время refresh: контент остаётся видимым (не заменять skeleton)
- При ошибке: toast с сообщением `Не удалось обновить`
- Debounce: игнорировать повторный pull в течение 2 секунд после завершения
- Не применять на Today Lesson (lesson state не должен сбрасываться)

---

## 5) RTL / Bidirectional Text Guide

### Системное правило
Приложение в целом: **LTR layout** (UI-элементы, навигация, кнопки).
Арабский текст: **RTL rendering** внутри text-контейнеров.

### Когда RTL
- `token.ar` — всегда RTL, `textDirection: TextDirection.rtl`
- Ayah Build pool/slots с арабскими токенами — RTL per-chip text
- PromptCard с арабским prompt — RTL alignment

### Когда LTR
- Весь UI layout (padding, icons, navigation)
- English translations
- Labels, buttons, instructions
- Метрики и числа

### Mixed Content
Когда арабский и английский текст в одном контексте:
- Разделять в отдельные Text widgets с явным `textDirection`
- Не полагаться на Unicode bidi algorithm для layout (ненадёжно в сложных случаях)
- Padding/margin: всегда LTR-based (start = left)

### Arabic Typography Rules
- Font: `Noto Naskh Arabic` (primary), `Amiri` (fallback)
- Minimum size для арабского: 18px (читаемость диакритик)
- Line height: минимум 1.4x font size (диакритические знаки требуют пространства)
- Не использовать `letterSpacing` для арабского (ломает лигатуры)
- `textAlign: TextAlign.center` для standalone арабских слов
- `textAlign: TextAlign.right` для арабских предложений/сегментов

### Flutter Implementation
```dart
// Пример: арабский текст
Text(
  token.ar,
  textDirection: TextDirection.rtl,
  style: TextStyle(
    fontFamily: 'NotoNaskhArabic',
    fontSize: 32,
    height: 1.375, // 44/32
  ),
)
```

---

## 6) Connectivity Status

### Offline Detection
- Использовать `connectivity_plus` package
- Проверять: WiFi/cellular available + реальный reach (ping health endpoint)

### States

#### Online → Offline
1. StatusBanner появляется (slide down, 200ms)
2. Text: `Нет подключения к интернету`
3. Стиль: `color.warning.bg` background, `color.warning.default` text
4. Disable: submit buttons, refresh actions
5. Enable: просмотр текущего загруженного контента

#### Offline → Online
1. StatusBanner text меняется: `Подключение восстановлено` (success variant)
2. Auto-dismiss через 2 секунды (fade out)
3. Re-enable все actions
4. Не auto-refresh данные (пользователь сам решает)

---

## 7) Empty Data Variants

Конкретные тексты для EmptyStateBlock по контексту:

### Today — нет урока
- Icon: 📖 (book)
- Title: `На сегодня всё!`
- Body: `Вы прошли урок. Возвращайтесь завтра для нового.`
- CTA: `Открыть прогресс`

### Reviews — нет due
- Icon: ✨ (sparkle)
- Title: `Повторения не требуются`
- Body: `Все слова на месте. Проверьте позже сегодня.`
- CTA: `К уроку`

### Progress — нет данных (новый пользователь)
- Icon: 🌱 (seedling)
- Title: `Пока нет данных`
- Body: `Пройдите первый урок, чтобы увидеть прогресс.`
- CTA: `Начать урок`

---

## Definition of Done
- Splash screen специфицирован для обеих платформ
- Toast/snackbar: anatomy, variants, behavior, positioning
- Pull-to-refresh: trigger, visual, edge cases
- RTL: чёткие правила для layout vs text direction
- Connectivity: online/offline state transitions
- Empty states: конкретные тексты для каждого экрана
