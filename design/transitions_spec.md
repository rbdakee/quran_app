# Transitions & Motion Specification (MVP)

## Purpose
Единая спецификация анимаций и переходов между состояниями, шагами и страницами.
Цель: предсказуемость, плавность, отсутствие визуального шума.

---

## 1) Motion Tokens (reference)

Из `design_system_tokens.md`:
- `motion.duration.fast` = 150ms
- `motion.duration.normal` = 200ms
- `motion.duration.slow` = 260ms
- `motion.easing.standard` = `cubic-bezier(0.2, 0, 0, 1)`

Дополнительно:
- `motion.easing.enter` = `cubic-bezier(0.0, 0, 0.2, 1)` — для появления элементов
- `motion.easing.exit` = `cubic-bezier(0.4, 0, 1, 1)` — для исчезновения

---

## 2) Step-to-Step Transitions (Lesson Flow)

### Контекст
Внутри Today Lesson: переход от step N к step N+1 после ответа.

### Анимация: Horizontal Slide

```
[Current Step] ──slide out left──→  ←──slide in from right── [Next Step]
```

- Direction: LTR (forward = slide left)
- Duration: `motion.duration.normal` (200ms)
- Easing: `motion.easing.standard`
- Элементы участвующие: PromptCard + Options / AyahBuild area
- Элементы **НЕ** участвующие (остаются на месте):
  - AppTopBar
  - ProgressStrip (анимирует fill отдельно)

### Progress Bar Fill
- Анимация: width transition
- Duration: `motion.duration.normal` (200ms)
- Easing: `motion.easing.standard`
- Trigger: одновременно с slide нового step

### Feedback → Next Step
1. Ответ отправлен → FeedbackBanner появляется (fade in, 150ms)
2. Пользователь нажал `Далее`
3. FeedbackBanner fade out (100ms)
4. Step slide transition (200ms)

---

## 3) Answer Feedback Animations

### Correct Answer
1. Selected OptionTile:
   - Border color → `color.success.default` (150ms)
   - Background → `color.success.bg` (150ms)
   - Checkmark icon fade in (100ms)
2. FeedbackBanner slide down from top of action area (150ms)
3. CTA morphs: `Проверить` → `Далее` (cross-fade, 150ms)

### Wrong Answer
1. Selected OptionTile:
   - Border → `color.error.default` (150ms)
   - Background → `color.error.bg` (150ms)
   - X icon fade in (100ms)
2. Correct OptionTile (reveal):
   - Border → `color.success.default` (150ms, delay 200ms)
   - Subtle pulse (scale 1.0 → 1.02 → 1.0, 300ms)
3. FeedbackBanner slide down (150ms)

### Ayah Build — Check Result
1. Correct tokens: border → success (150ms, sequential left-to-right, 50ms stagger)
2. Wrong tokens: border → error (150ms, same stagger)
3. FeedbackBanner appears after last token animation

---

## 4) Page-to-Page Transitions

### Tab Navigation (Bottom Tabs)
Between Today / Progress / Reviews:

- Type: **Cross-fade**
- Duration: `motion.duration.normal` (200ms)
- Easing: `motion.easing.standard`
- Нет slide — табы равноправны, нет "направления"

### Today → Summary (Lesson Complete)
- Type: **Fade + Scale Up**
- Incoming: opacity 0 → 1, scale 0.95 → 1.0
- Duration: `motion.duration.slow` (260ms)
- Easing: `motion.easing.enter`
- Цель: ощущение "достижения", мягкий reveal

### Summary → Tab (любой)
- Type: **Fade**
- Duration: `motion.duration.normal` (200ms)

### Reviews → Lesson Step (если запускается review flow)
- Type: **Slide from right**
- Duration: 200ms
- Back gesture: slide back left

---

## 5) Component-Level Animations

### OptionTile — Selection
- Tap: scale 0.98 → 1.0 (fast, 100ms) + border highlight
- Не использовать: opacity change (выглядит как disabled)

### TokenChip — Ayah Build
#### Add to slot
- Chip в pool: fade out + scale down (100ms)
- Chip в slot: fade in + scale up (150ms)

#### Remove from slot
- Обратная анимация: slot fade out, pool fade in (100ms each)

### PrimaryButton — Loading
- Text cross-fade → spinner (150ms)
- Spinner: continuous rotation

### FeedbackBanner — Appear/Disappear
- Appear: slide down + fade in (150ms)
- Disappear: fade out (100ms)

### StatusBanner (Global)
- Appear: slide down from under AppTopBar (200ms)
- Disappear: slide up (200ms)

### LoadingSkeleton — Shimmer
- Pulse animation: opacity 0.3 → 0.7 → 0.3
- Duration: 1500ms loop
- Easing: ease-in-out
- Respect `prefers-reduced-motion` → disable shimmer, show static skeleton

---

## 6) Gesture-Driven Transitions

### Back Gesture (iOS swipe-from-edge)
- Для pushed routes (Today → Summary, Reviews → Review Flow)
- Interactive: finger controls position
- Threshold: 30% screen width → commit, else snap back
- Tabs: **нет** swipe between tabs (конфликт с horizontal content)

### Pull-to-Refresh (Progress / Reviews)
- Trigger: pull down > 80px
- Indicator: circular spinner at top
- Release → refresh data
- Spinner: visible until data loaded, then slide up (200ms)

---

## 7) Reduced Motion

Если пользователь включил `Reduce Motion` (system accessibility):
- Все slide/scale анимации → заменить на instant cross-fade (100ms)
- Shimmer → static skeleton (no pulse)
- Stagger animations → instant batch apply
- Token chip add/remove → instant swap

Flutter: `MediaQuery.of(context).disableAnimations`

---

## 8) Performance Rules

- Все анимации на GPU-friendly свойствах: `transform`, `opacity`
- Не анимировать: `padding`, `margin`, `height`, `width` (layout thrash)
- Max одновременных анимаций: 3–4
- При слабом устройстве: duration → 0 (fallback)
- Step transition: preload следующий step widget до начала анимации

---

## 9) Summary Table

| Transition | Type | Duration | Easing |
|---|---|---|---|
| Step → Step | Slide horizontal | 200ms | standard |
| Progress fill | Width | 200ms | standard |
| Feedback appear | Slide down + fade | 150ms | enter |
| Feedback disappear | Fade out | 100ms | exit |
| Option correct/wrong | Border + bg color | 150ms | standard |
| Tab → Tab | Cross-fade | 200ms | standard |
| Today → Summary | Fade + scale | 260ms | enter |
| Ayah chip add | Fade + scale | 150ms | enter |
| Ayah chip remove | Fade + scale | 100ms | exit |
| StatusBanner | Slide vertical | 200ms | standard |
| Skeleton shimmer | Opacity pulse | 1500ms | ease-in-out |
| Pull-to-refresh spinner | Slide up | 200ms | standard |

---

## Definition of Done
- Step-to-step, page-to-page, component-level анимации специфицированы
- Reduced motion fallback определён
- Performance constraints заданы
- Все durations/easings привязаны к motion tokens
