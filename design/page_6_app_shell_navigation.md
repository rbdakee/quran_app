# Page 6 — App Shell & Navigation Blueprint

## Purpose
Определить общий каркас приложения для MVP Frontend: табы, переходы, глобальные состояния и единые паттерны интерфейса.

---

## Navigation Model (MVP)
Bottom Tab Navigation (3 tabs):
1. `Today`
2. `Progress`
3. `Reviews`

Причина:
- покрывает весь core learning loop,
- минимум сложности,
- высокая предсказуемость поведения.

---

## Route Map
- `/today`
- `/today/lesson` (active step flow)
- `/today/summary`
- `/progress`
- `/reviews`

Optional deep links (v2):
- `/reviews?filter=urgent`
- `/progress?focus=weak`

---

## Global Components

### 1) AppTopBar
Унифицированный header для экранов.

### 2) StatusBanner
Показывает offline/error/system messages.

### 3) PrimaryButton / SecondaryButton
Единая кнопочная система.

### 4) SurfaceCard
Базовый контейнер карточек.

### 5) LoadingSkeleton
Стандартный skeleton для всех страниц.

---

## Global States

### Auth/Session Ready
(если авторизация добавится позже) — пока не блокирует MVP

### Network Offline
- global banner
- disable network-dependent actions

### API Error (recoverable)
- local retry в пределах страницы

### Fatal Error
- full-screen fallback + action `Перезапустить`

---

## UX Rules Across Pages
1. Один основной CTA на экран.
2. Понятное название каждого шага.
3. Back action не должен ломать lesson state.
4. Все долгие операции имеют visible loading.
5. Ошибка всегда содержит путь восстановления (retry/alternate action).

---

## Design Tokens (Cross-App)
- spacing scale: 4/8/12/16/24/32
- radii: 8/12/16
- elevation: low/medium (минимально)
- motion: 150–220ms ease-out

---

## Handoff Notes for Frontend
- Реализовать screen-level state machines
- Step renderer сделать расширяемым по `step.type`
- Не хардкодить тексты типів шагов в одном месте — вынести mapping
- Все интеракции вести через typed contract models

---

## Definition of Done (Design)
- Есть карта навигации и route strategy
- Единые компоненты и global patterns описаны
- Команда frontend может начинать верстку без архитектурных догадок
