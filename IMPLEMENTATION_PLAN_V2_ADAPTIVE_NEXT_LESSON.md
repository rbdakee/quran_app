# Implementation Plan v2 — Adaptive Next Lesson Progression

_Last updated: 2026-03-18_

## Purpose

Этот документ фиксирует следующий этап развития learning pipeline после повторного многодневного теста.

Главная цель:

> Сделать `Next Lesson` реально главным и достаточным путём обучения,
> где новые слова добавляются адаптивно,
> повторение имеет приоритет,
> а рост словаря происходит только вместе с закреплением,
> а не вместо него.

Этот план опирается на:
- уже выполненные фазы 1–4,
- результаты повторного 8-дневного теста,
- новый продуктовый принцип от Сэра:
  - если следующий урок делается **скоро после предыдущего**, усиливать **повторение**;
  - если повторение прошло **очень хорошо**, постепенно увеличивать объём новых слов;
  - если следующий урок делается **позже**, можно давать микс review + new;
  - но всегда следить, чтобы слова **закреплялись**, а не просто рос словарный объём.

---

# 1. New Product Direction

## Core idea

`Next Lesson` должен стать **адаптивным темпоритмом обучения**.

Решение о составе следующего урока должно зависеть не только от due/review-pressure, но и от:

1. **времени с прошлого завершённого урока**
2. **качества прохождения последних повторений**
3. **сигнала закрепления уже введённых слов**
4. **темпа текущего расширения словаря**

---

## Desired user experience

Пользователь должен чувствовать:

- если я учусь подряд и активно — система не закидывает меня новыми словами бездумно,
  а сначала помогает закрепить материал;
- если я хорошо справляюсь с повторением — система постепенно открывает больше нового;
- если я возвращаюсь позже — система мягко балансирует review и new;
- каждое новое слово ощущается **заслуженным**, а не просто добавленным ради объёма.

---

# 2. Main Problems This Plan Addresses

## Problem A — `Next Lesson` ещё не стал достаточным самостоятельным path

### Current issue
Даже после прошлых улучшений реальное поведение всё ещё выглядит как:
- `Next Lesson`
- плюс отдельные `Review Lessons`

### Why this matters
Это мешает продуктовой цели одного coherent pipeline.

### Plan direction
`Next Lesson` должен стать настолько адаптивным, чтобы **основной пользовательский режим почти не нуждался в отдельном review-mode**.

---

## Problem B — New words still risk outpacing consolidation

### Current issue
Даже если due pressure частично учитывается, система всё ещё может расширять токеновый объём быстрее, чем формируется устойчивое закрепление.

### Why this matters
Пользователь может ощущать активность и рост списка слов, но не реальное удержание и понимание.

### Plan direction
Ввод новых слов должен зависеть от **сигнала качества закрепления**, а не только от отсутствия перегруза.

---

## Problem C — Progress truth remains too token-centric

### Current issue
Даже после исправлений distinct token rows всё ещё могут создавать ощущение большего роста vocabulary, чем есть на concept-level.

### Why this matters
Продукт должен ощущаться как рост знания языка, а не как накопление token instances.

### Plan direction
При принятии решения о том, сколько нового давать в `Next Lesson`, опираться не только на token pressure, но и на **concept-level consolidation signals**.

---

## Problem D — Reinforcement is still too weak in observed behavior

### Current issue
В наблюдаемом тесте reinforcement почти не проявлялся как отдельный meaningful layer.

### Why this matters
Без reinforcement pipeline становится слишком бинарным:
- либо review,
- либо new,
вместо качественного промежуточного закрепления.

### Plan direction
Встроить reinforcement прямо в адаптивную логику `Next Lesson`.

---

# 3. New Adaptive Learning Policy

## High-level policy

Следующий урок должен собираться по такому правилу:

1. Сначала система оценивает:
   - сколько времени прошло с прошлого completed lesson,
   - насколько хорошо были пройдены недавние review-heavy steps,
   - есть ли непроработанный review pressure,
   - есть ли слабые/нестабильные concepts.
2. Затем определяет режим следующего урока:
   - **consolidation-heavy**
   - **balanced**
   - **progressive expansion**
3. И только после этого назначает:
   - сколько due,
   - сколько reinforcement,
   - сколько new words.

---

## Mode 1 — Consolidation-heavy

### Trigger
Используется, если пользователь делает `Next Lesson` **относительно скоро** после последнего урока.

### Product intuition
Если человек вернулся быстро, это хороший момент не для агрессивного расширения, а для **укрепления недавнего материала**.

### Composition intent
- основной акцент: review + reinforcement
- новые слова: минимум или 0

### Default new-word policy
- baseline: `0–1 new`
- если недавнее review качество очень высокое — можно `1 new`
- если качество неубедительное — `0 new`

### Why
Быстрый повтор должен работать как закрепление, а не как новый когнитивный долг.

---

## Mode 2 — Balanced

### Trigger
Используется, если пользователь пришёл **чуть позже**, но не настолько, чтобы система считала это long-gap return.

### Product intuition
Это нормальный основной режим: немного review, немного reinforcement, немного нового.

### Composition intent
- due review: обязательно, если есть
- reinforcement: заметная часть
- new words: ограниченно

### Default new-word policy
- `1–2 new`
- увеличивать до `2`, если recent review quality хорошее
- не давать `2`, если есть явные слабые concepts или свежий backlog

### Why
Это основной кандидат на “нормальный ежедневный lesson mode”.

---

## Mode 3 — Progressive expansion

### Trigger
Используется, если:
- review pressure под контролем,
- недавние повторения пройдены очень хорошо,
- есть подтверждение закрепления,
- пользователь не накапливает слабые хвосты.

### Product intuition
Новые слова должны открываться как **награда за качественное закрепление**.

### Composition intent
- due review: если есть
- reinforcement: всё ещё присутствует
- new words: растут постепенно

### Ladder for new words
Новые слова увеличиваются **постепенно**, а не скачком:

- сначала `+1`
- затем `+2`
- затем `+3`
- затем дальше только при устойчивом подтверждении качества

### Important rule
Переход вверх по ladder возможен только если recent review quality действительно высокая, а не просто because due=0.

---

# 4. New Control Variables for Planner

## Variable 1 — `time_since_last_completed_lesson`

### Purpose
Определяет ритм следующего урока.

### Planned buckets
Примерная схема:
- **very_recent** → consolidation-heavy
- **recent** → balanced leaning review
- **normal_gap** → balanced
- **long_gap** → balanced with stronger due handling

### Note
Точные пороги надо определить экспериментально и закрепить в конфиге.

---

## Variable 2 — `recent_review_quality_score`

### Purpose
Определяет, заслуживает ли пользователь рост new-word budget.

### Candidate inputs
Можно считать из последних N completed lessons:
- accuracy on review-like steps
- качество на due/reinforcement
- ошибки на слабых concepts
- возможно, весить review steps сильнее, чем new-word intro success

### Important rule
Высокая общая accuracy сама по себе недостаточна, если она достигнута mostly на простых/new steps. Нужна оценка именно **качества закрепления**.

---

## Variable 3 — `concept_consolidation_state`

### Purpose
Понять, закрепился ли материал достаточно, чтобы давать больше нового.

### Needed behavior
Система должна видеть:
- есть ли recent concepts, которые ещё слишком хрупкие
- нет ли слишком быстрого перехода к expansion без стабилизации

### Why
Это помогает бороться с token-row inflation и делает growth более concept-driven.

---

## Variable 4 — `expansion_level`

### Purpose
Хранить текущую ступень new-word ladder.

### Example states
- level 0 → `0–1 new`
- level 1 → `1 new`
- level 2 → `2 new`
- level 3 → `3 new`
- etc.

### Advancement rule
Поднимается только если:
- recent review quality high,
- no meaningful unresolved due pressure,
- no concentration on weak concepts,
- previous level was handled stably over several lessons.

### Regression rule
Понижается, если:
- review quality падает,
- backlog растёт,
- слабые concepts повторяются плохо,
- recent lessons показывают, что expansion outruns consolidation.

---

# 5. Revised Canonical `Next Lesson` Planner

## Core architectural update — Weighted scoring layer

В этом плане мы **не** идём в нейросетевые weights или обучаемую ML-модель.

Вместо этого вводится **weighted scoring layer** внутри planner-а:
- explainable,
- rule-guided,
- tunable,
- пригодный для многодневных симуляций и product-debugging.

### Why this is the right level now
Сейчас системе важнее:
- объяснимость,
- контроль над product behavior,
- быстрая калибровка,
- прозрачный дебаг,
чем “умность” в стиле black-box model.

То есть мы добавляем не ML-weights, а **весовые коэффициенты принятия решений**.

---

## Weighted planner concept

Planner должен сначала вычислять несколько отдельных score-сигналов, а затем принимать решение о режиме урока и его составе.

### Candidate score families

#### 1. `due_pressure_score`
Отражает:
- объём due reviews,
- срочность due,
- накопление review backlog.

#### 2. `recency_score`
Отражает:
- насколько быстро пользователь пришёл после последнего completed lesson.

#### 3. `review_quality_score`
Отражает:
- качество прохождения недавних review/reinforcement-heavy lessons,
- качество именно закрепления, а не просто accuracy на лёгких шагах.

#### 4. `consolidation_need_score`
Отражает:
- есть ли fragile recent concepts,
- есть ли признаки, что новый материал начинает обгонять закрепление.

#### 5. `expansion_readiness_score`
Отражает:
- готовность открыть больше new words,
- основанную на recent review quality + concept stability + low unresolved pressure.

#### 6. `diversity_penalty_score`
Штрафует:
- переэкспозицию одних и тех же ayah/token clusters,
- перегрев повторяющихся high-frequency concepts,
- слабое покрытие review space.

---

## Example decision shape

Условно planner может опираться на такую логику:

```text
mode_score_consolidation =
  w_due * due_pressure_score
+ w_recency * recency_score
+ w_cons * consolidation_need_score
- w_expand * expansion_readiness_score

mode_score_balanced =
  w_mix_due * due_pressure_score
+ w_mix_quality * review_quality_score
+ w_mix_expand * expansion_readiness_score
- w_mix_penalty * diversity_penalty_score

mode_score_progressive =
  w_prog_quality * review_quality_score
+ w_prog_expand * expansion_readiness_score
- w_prog_due * due_pressure_score
- w_prog_cons * consolidation_need_score
```

Точные формулы не должны быть жёстко зашиты в этом документе; важен сам принцип:
- решение принимает **взвешенный explainable planner**,
- а не набор несвязанных `if/else` правил.

---

## Target decision order

`Next Lesson` должен принимать решение в таком порядке:

### Step 1 — Evaluate rhythm context
- Когда был последний завершённый урок?
- Какой сейчас tempo of study?

### Step 2 — Compute planner scores
- due pressure
- recency
- review quality
- consolidation need
- expansion readiness
- diversity penalty

### Step 3 — Choose lesson mode
На основе weighted scores выбрать:
- consolidation-heavy
- balanced
- progressive expansion

### Step 4 — Assign composition
- due count
- reinforcement count
- new count
- ayah practice presence

### Step 5 — Explain internally why
Планировщик должен сохранять диагностические metadata, чтобы потом можно было объяснить:
- почему урок получился таким,
- какие scores повлияли сильнее всего,
- почему new words ограничены или увеличены,
- почему включён акцент на review.

---

# 6. Concrete Product Rules

## Rule A — Very recent lesson => more consolidation

Если пользователь делает `Next Lesson` слишком скоро после предыдущего урока:

- не разгонять новые слова,
- давать больше review/reinforcement,
- использовать lesson как закрепляющую сессию.

### Intended effect
Пользователь быстрее переводит материал в более устойчивое знание.

---

## Rule B — New words are unlocked by strong review performance

Если review-heavy recent lessons пройдены **очень хорошо**:

- сначала разрешить `1 new`
- затем `2`
- затем `3`
- и так далее осторожно

### Intended effect
Новое ощущается как earned progression.

---

## Rule C — Delayed return => review + new mix

Если пользователь пришёл позже:

- due review должен учитываться обязательно,
- но можно дать микс с новыми словами,
- если consolidation state это позволяет.

### Intended effect
Пользователь не чувствует, что после паузы система либо заваливает review-only, либо бездумно даёт новое.

---

## Rule D — Never expand vocabulary without consolidation proof

Даже если due count маленький, это ещё не значит, что нужно расширять new budget.

Перед ростом нового система должна проверить:
- review quality,
- fragile concepts,
- recent reinforcement need.

### Intended effect
Vocabulary growth становится педагогически честнее.

---

# 7. What Must Change in Backend

## Backend Change 1 — Add adaptive planner inputs

### Needed
В canonical planner нужно добавить вычисление:
- `time_since_last_completed_lesson`
- `recent_review_quality_score`
- `concept_consolidation_state`
- `expansion_level`

### Why
Сейчас planner уже частично учитывает review pressure, но этого недостаточно для desired adaptive flow.

---

## Backend Change 1.5 — Introduce weighted scoring layer

### Needed
Нужно формализовать planner decision-making через набор explainable weights/scoring signals, а не только через разрозненные heuristic branches.

### Minimum scoring block
- `due_pressure_score`
- `recency_score`
- `review_quality_score`
- `consolidation_need_score`
- `expansion_readiness_score`
- `diversity_penalty_score`

### Needed outputs
Weighted layer должна влиять на:
- выбор lesson mode,
- ограничение или рост new-word budget,
- силу reinforcement,
- штрафы за однообразный review mix.

### Why
Это лучший следующий шаг между простым rule-based planner и избыточной ML-моделью:
- explainable,
- debuggable,
- tunable,
- пригодно для быстрой продуктовой итерации.

---

## Backend Change 2 — Add expansion ladder state

### Needed
Нужно хранить/вычислять текущую ступень допуска к новым словам.

### Candidate storage
Возможные варианты:
- derived from recent performance history,
- stored in engagement/profile state,
- stored in a dedicated lightweight progression state.

### Why
Без этого нельзя аккуратно реализовать `1 -> 2 -> 3` growth logic.

---

## Backend Change 3 — Strengthen reinforcement layer

### Needed
Reinforcement должен стать реальным composition layer, а не почти отсутствующим побочным эффектом.

### Why
Иначе pipeline всё ещё будет бинарным: review vs new.

---

## Backend Change 4 — Improve planner diagnostics

### Needed
В lesson metadata стоит сохранять explainability fields, например:
- selected_mode
- expansion_level_before
- expansion_level_after
- review_quality_score
- consolidation_reason
- why_new_count_was_capped

### Why
Это позволит:
- дебажить planner,
- анализировать поведение в многодневных тестах,
- позже объяснять пользователю, почему урок такой.

---

# 8. What Must Change in Product Metrics

## Metric split needed
Нужно чётко разделить:

### 1. Activity metrics
- сколько было шагов
- сколько было review events
- сколько lesson completions

### 2. Learning metrics
- сколько distinct concepts укреплено
- сколько новых concepts действительно добавлено
- насколько стабильно держатся recent concepts

### Why
Пока этого разделения нет, продукт может показывать активность вместо реального learning gain.

---

# 9. What Must Change in UX

## UX Goal
Пользователь должен видеть не просто “ещё один урок”, а ощущать:

- сейчас у меня урок на закрепление
- я хорошо справился, поэтому система открывает больше нового
- я вернулся позже, и система сбалансировала review + new

## Desired future surface behavior
Даже если UI остаётся минималистичным, ему стоит передавать ясные сигналы:
- “Акцент на закрепление”
- “Новых слов сегодня: 1”
- “Новых слов сегодня: 2, потому что прошлые повторения были сильными”

### Note
Это не обязательно делать немедленно в UI, но planner должен уметь это объяснить уже на backend уровне.

---

# 10. Remaining Problems from Latest Audit To Include

Новый adaptive plan должен прямо учитывать выводы из последнего анализа.

## Still relevant issue 1 — split pipeline
### Plan response
Сделать так, чтобы основной пользователь почти всё мог проходить через `Next Lesson`, а review-only был реально secondary.

## Still relevant issue 2 — ayah semantics still too strong internally
### Plan response
При дальнейших улучшениях не позволять одному ayah pedagogical action слишком агрессивно двигать mastery/review effects.

## Still relevant issue 3 — token-centric vocabulary growth
### Plan response
Решения о новом материале должны учитывать concept-level consolidation, а growth reporting должен смещаться к concept truth.

## Still relevant issue 4 — weak review diversity
### Plan response
Нужно сильнее ограничить переэкспозицию high-frequency repeated concepts и расширять review spread.

## Still relevant issue 5 — reinforcement almost invisible
### Plan response
Reinforcement должен стать обязательным meaningful layer inside `Next Lesson`.

---

# 11. Implementation Phases for v2

## Phase A — Adaptive planner foundation

### Scope
- добавить новые planner inputs
- ввести lesson mode selection
- внедрить базовую логику tempo-aware planning
- подготовить диагностические metadata для explainability

### Deliverable
Planner умеет различать:
- very_recent lesson,
- recent lesson,
- delayed return,
и строит composition accordingly.

---

## Phase B — Weighted scoring layer

### Scope
- внедрить explainable weighted scoring block
- определить initial weights and caps
- связать scores с mode selection и lesson composition
- заложить telemetry/debug output для последующего тюнинга

### Deliverable
Planner принимает ключевые решения через weighted scores, а не только через разрозненные heuristic branches.

---

## Phase C — New-word expansion ladder

### Scope
- реализовать growth ladder:
  - 1 new
  - 2 new
  - 3 new
- сделать advancement/regression rules

### Deliverable
New-word intake становится earned and adaptive.

---

## Phase D — Reinforcement as first-class layer

### Scope
- встроить reinforcement в реальный canonical mix
- не оставлять его случайным/редким эффектом

### Deliverable
`Next Lesson` начинает реально использовать reinforcement, а не в основном oscillate между review and new.

---

## Phase E — Concept-truth and diagnostics

### Scope
- добавить concept-aware planner gating
- усилить diagnostics metadata
- подготовить понятные metrics для последующего UX слоя

### Deliverable
Planner становится explainable и опирается на более честную learning truth.

---

# 12. Recommended Subagent Plan

## Subagent 1 — `adaptive-planner-foundation`
### Model recommendation
Opus or strongest coding model available

### Scope
- tempo-aware next-lesson policy
- mode selection
- planner metadata diagnostics

---

## Subagent 2 — `weighted-scoring-implementation`
### Model recommendation
Opus or strongest coding model available

### Context requirement
Этому субагенту нужно дать **расширенный контекст**, потому что он должен понимать не только локальный backend-код, но и весь product intent:
- все выводы из прошлых фаз,
- результаты многодневных тестов,
- причины split pipeline,
- проблему token-centric growth,
- слабость reinforcement,
- необходимость explainability,
- и почему мы сознательно выбираем weighted heuristics, а не ML / neural-network weights.

### Scope
- внедрить explainable weighted scoring layer
- определить initial weights and caps
- связать scores с mode selection, reinforcement strength и new-word gating
- сохранить planner diagnostics для последующего тюнинга

---

## Subagent 3 — `adaptive-expansion-ladder`
### Model recommendation
Default coding model

### Scope
- unlock new words via strong review performance
- 1 → 2 → 3 progression logic
- regression logic when consolidation weakens

---

## Subagent 4 — `reinforcement-and-concept-truth`
### Model recommendation
Default coding model

### Scope
- reinforcement as real composition layer
- stronger concept-aware gating
- concept-first learning signals where needed

---

## Subagent 5 — `audit-and-tuning-pass`
### Model recommendation
Default coding model

### Scope
- rerun multi-day simulation
- compare before/after
- tune thresholds, weights and caps

---

# 13. Success Criteria

План считается успешным, когда:

## Pipeline behavior
- обычный пользователь может в основном жить через `Next Lesson`
- review-only больше не нужен как обязательная daily rail

## New-word policy
- новые слова растут постепенно и заслуженно
- нет ощущения бесконтрольного расширения без закрепления

## Learning trust
- пользователь ощущает, что система сначала помогает закрепить,
  а потом открывает больше нового
- vocabulary growth выглядит реалистично и объяснимо

## Observability
- по lesson metadata можно понять, почему урок был собран именно так
- multi-day audits показывают понятную динамику progression

---

# 14. Immediate Next Actions

## Recommended first batch
1. Спроектировать planner inputs для tempo-aware decision making.
2. Определить initial thresholds для `very_recent / recent / delayed`.
3. Спроектировать `recent_review_quality_score`.
4. Внедрить explainable weighted scoring layer с initial weights.
5. Определить storage/derivation для `expansion_level`.
6. Внедрить базовый consolidation-heavy mode.

### Why first
Это минимальный шаг, который позволит сразу приблизиться к новой цели без полного redesign всего остального — и одновременно даст нам explainable control over planner behavior.

---

# Final Note

Этот этап уже не просто про починку багов.

Он про то, чтобы сделать progression **умным по ритму обучения**:
- сначала закрепление,
- потом заслуженное расширение,
- всегда с контролем реального усвоения.

Именно это должно приблизить Quran App к состоянию, где `Next Lesson` ощущается как настоящий персональный learning path, а не просто как генератор следующей активности.
