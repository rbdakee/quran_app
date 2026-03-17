# Design System Tokens (MVP v1)

## Purpose
Единый источник визуальных токенов для всех экранов MVP.

Цель:
- исключить ad-hoc значения,
- ускорить handoff в frontend,
- сохранить консистентность UI.

---

## 1) Color Tokens

### Core Surfaces
- `color.bg.primary` = `#0F1115`
- `color.bg.secondary` = `#131722`
- `color.surface.default` = `#171A21`
- `color.surface.elevated` = `#1E2430`
- `color.surface.muted` = `#222A38`

### Text
- `color.text.primary` = `#F5F7FA`
- `color.text.secondary` = `#A7B0C0`
- `color.text.tertiary` = `#7E8798`
- `color.text.inverse` = `#0F1115`

### Brand / Action
- `color.accent.primary` = `#5B8CFF`
- `color.accent.primaryHover` = `#6C98FF`
- `color.accent.primaryPressed` = `#4D7DF2`

### Semantic
- `color.success.default` = `#23C16B`
- `color.success.bg` = `#163526`
- `color.warning.default` = `#F5B83D`
- `color.warning.bg` = `#3B2B12`
- `color.error.default` = `#FF5D5D`
- `color.error.bg` = `#3F1D24`
- `color.info.default` = `#4DA3FF`
- `color.info.bg` = `#14283E`

### Borders & Dividers
- `color.border.default` = `#2A3140`
- `color.border.strong` = `#3A4356`
- `color.border.focus` = `#7AA2FF`
- `color.divider.default` = `#232A36`

### Interaction overlays
- `color.overlay.hover` = `rgba(255,255,255,0.04)`
- `color.overlay.pressed` = `rgba(255,255,255,0.08)`
- `color.overlay.scrim` = `rgba(0,0,0,0.48)`

---

## 2) Typography Tokens

### Font Families
- `font.family.sans` = `Inter, system-ui, -apple-system, Segoe UI, Roboto, sans-serif`
- `font.family.arabic` = `Noto Naskh Arabic, Amiri, serif`

### Type Scale
- `type.display.lg` = `32/40, 600`
- `type.title.lg` = `24/32, 600`
- `type.title.md` = `20/28, 600`
- `type.title.sm` = `18/24, 600`
- `type.body.lg` = `16/24, 400`
- `type.body.md` = `14/20, 400`
- `type.body.sm` = `13/18, 400`
- `type.label.md` = `14/18, 500`
- `type.label.sm` = `12/16, 500`

### Arabic-specific
- `type.arabic.word` = `32/44, 600`
- `type.arabic.segment` = `24/36, 500`
- `type.arabic.inline` = `18/28, 500`

---

## 3) Spacing Tokens

Base scale (4pt):
- `space.1` = 4
- `space.2` = 8
- `space.3` = 12
- `space.4` = 16
- `space.5` = 20
- `space.6` = 24
- `space.8` = 32
- `space.10` = 40

Screen defaults:
- `layout.page.paddingX` = 16
- `layout.page.paddingTop` = 12
- `layout.section.gap` = 20
- `layout.block.gap` = 16

---

## 4) Radius Tokens
- `radius.sm` = 8
- `radius.md` = 12
- `radius.lg` = 16
- `radius.xl` = 20
- `radius.pill` = 999

Usage:
- Buttons/options: `radius.md`
- Cards: `radius.lg`
- Badges/chips: `radius.pill`

---

## 5) Elevation Tokens
- `elevation.none` = `none`
- `elevation.sm` = `0 1px 2px rgba(0,0,0,0.25)`
- `elevation.md` = `0 6px 18px rgba(0,0,0,0.24)`

MVP правило: использовать минимально, приоритет на контраст и границы.

---

## 6) Motion Tokens
- `motion.duration.fast` = `150ms`
- `motion.duration.normal` = `200ms`
- `motion.duration.slow` = `260ms`
- `motion.easing.standard` = `cubic-bezier(0.2, 0, 0, 1)`

Transitions:
- hover/press: fast
- state change (correct/wrong): normal
- panel reveal: normal/slow

---

## 7) Component Size Tokens
- `size.button.height` = 52
- `size.input.height` = 48
- `size.option.height` = 52
- `size.progress.height` = 8
- `size.touch.min` = 44
- `size.icon.sm` = 16
- `size.icon.md` = 20
- `size.icon.lg` = 24

---

## 8) Z-Index Tokens
- `z.base` = 0
- `z.sticky` = 10
- `z.overlay` = 100
- `z.modal` = 1000
- `z.toast` = 1100

---

## 9) Accessibility Rules
- Body text contrast >= 4.5:1
- Large text contrast >= 3:1
- Не использовать только цвет как носитель смысла
- Focus ring обязателен для keyboard/navigation contexts

Focus token:
- `focus.ring.color` = `#7AA2FF`
- `focus.ring.width` = `2px`
- `focus.ring.offset` = `2px`

---

## 10) Theming Notes
MVP: только темная тема.

v2-ready:
- оставить токены в semantic naming,
- не привязывать компоненты к raw hex,
- предусмотреть light theme mapping отдельным файлом.
