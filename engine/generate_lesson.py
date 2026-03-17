#!/usr/bin/env python3
"""
Generate one Quran lesson JSON from dataset.csv using an adaptive lesson algorithm.

Usage:
  python generate_lesson.py
  python generate_lesson.py --dataset dataset.csv --out lesson.generated.json --seed 42

Notes:
- This script does NOT persist lesson history.
- It creates a single lesson file each run.
- Content is Quran-safe: only dataset.csv tokens are used.
"""

from __future__ import annotations

import argparse
import csv
import json
import random
from dataclasses import dataclass
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Dict, List, Tuple


LESSON_CONFIG = {
    "target_steps": 14,
    "due_count": 15,            # max; actual computed dynamically
    "new_count": 3,             # max; actual computed dynamically
    "reinforcement_count": 2,
    "ayah_assembly_count": 2,
    "review_choices": 4,
    # Intra-lesson repetition formats for new words
    "new_word_formats": ["new_word_intro", "meaning_choice", "audio_to_meaning", "translation_to_word"],
    # Long-ayah policy
    "max_ayah_tokens_full": 10,
    "segment_tokens_default": 8,
    "segment_tokens_min": 7,
    "segment_tokens_max": 10,
    # Distractors for ayah assembly
    "distractor_count_easy": 0,
    "distractor_count_medium": 2,
    "distractor_count_hard": 4,
}

STATE_NEW = "new"
STATE_LEARNING = "learning"
STATE_REVIEWING = "reviewing"
STATE_MASTERED = "mastered"
STATE_LAPSED = "lapsed"

# Al-Muqatta'at: surahs whose first ayah consists of disconnected letters.
# Ayah 1 of these surahs is excluded from ayah assembly AND the learning pool
# (they are single/few letter symbols, not learnable vocabulary).
MUQATTAAT_SURAHS: set[int] = {
    2, 3, 7, 10, 11, 12, 13, 14, 15, 19, 20, 26, 27, 28, 29, 30, 31, 32,
    36, 38, 40, 41, 42, 43, 44, 45, 46, 50, 68,
}


def is_muqattaat_token(t) -> bool:
    """Check if a token belongs to a Muqatta'at opening (surah X, ayah 1)."""
    return t.ayah == 1 and t.surah in MUQATTAAT_SURAHS

AYAH_TASK_TYPES = [
    "ayah_build_ar_from_translation",
    "ayah_build_ar_from_audio",
    "ayah_build_translation_from_ar",
]


@dataclass
class Token:
    token_id: str
    surah: int
    ayah: int
    word: int
    location: str
    audio_key: str
    full_form_ar: str
    lemma_ar: str
    root_ar: str
    pos: str
    translation_en: str
    freq_global: int = 1
    concept_key: str = ""
    concept_freq: int = 1


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Generate one Quran lesson JSON")
    parser.add_argument("--dataset", default="dataset.csv", help="Path to dataset CSV")
    parser.add_argument("--out", default="lesson.generated.json", help="Output JSON path")
    parser.add_argument("--seed", type=int, default=7, help="Random seed for reproducibility")
    parser.add_argument("--progress", default=None, help="Path to user_progress.json (enables persistent progress)")
    return parser.parse_args()


def make_token_id(location: str) -> str:
    return f"tok:{location}"


def concept_key_for_token(t: Token) -> str:
    # "new word" identity: prefer lemma, fallback to exact surface form.
    return t.lemma_ar or t.full_form_ar or t.token_id


def pos_bucket(pos: str) -> str:
    p = (pos or "").upper()
    if p == "V":
        return "verb"
    if p in {"N", "ADJ", "PN"}:
        return "nounish"
    if p in {"PRON", "DEM", "REL"}:
        return "pronoun"
    if p == "P":
        return "preposition"
    return "other"


def read_tokens(dataset_path: Path) -> List[Token]:
    tokens: List[Token] = []
    with dataset_path.open("r", encoding="utf-8", newline="") as f:
        reader = csv.DictReader(f)
        for row in reader:
            try:
                surah = int(row["surah"])
                ayah = int(row["ayah"])
                word = int(row["word"])
            except (KeyError, ValueError):
                continue

            location = row.get("location", "") or f"{surah}:{ayah}:{word}"
            token = Token(
                token_id=make_token_id(location),
                surah=surah,
                ayah=ayah,
                word=word,
                location=location,
                audio_key=row.get("audio_key", ""),
                full_form_ar=row.get("full_form_ar", "").strip(),
                lemma_ar=row.get("lemma_ar", "").strip(),
                root_ar=row.get("root_ar", "").strip(),
                pos=row.get("pos", "").strip(),
                translation_en=row.get("translation_en", "").strip(),
            )
            tokens.append(token)

    by_surface: Dict[str, int] = {}
    by_concept: Dict[str, int] = {}

    for t in tokens:
        surface_key = t.full_form_ar or t.lemma_ar or t.token_id
        by_surface[surface_key] = by_surface.get(surface_key, 0) + 1

        ckey = concept_key_for_token(t)
        by_concept[ckey] = by_concept.get(ckey, 0) + 1

    for t in tokens:
        surface_key = t.full_form_ar or t.lemma_ar or t.token_id
        t.freq_global = by_surface.get(surface_key, 1)
        t.concept_key = concept_key_for_token(t)
        t.concept_freq = by_concept.get(t.concept_key, 1)

    # Filter out Muqatta'at tokens (disconnected letters, not learnable vocab)
    before = len(tokens)
    tokens = [t for t in tokens if not is_muqattaat_token(t)]
    filtered = before - len(tokens)
    if filtered > 0:
        print(f"Filtered {filtered} Muqatta'at tokens from {before} total.")

    return tokens


def build_ayah_index(tokens: List[Token]) -> Dict[Tuple[int, int], List[Token]]:
    ayah_index: Dict[Tuple[int, int], List[Token]] = {}
    for t in tokens:
        ayah_index.setdefault((t.surah, t.ayah), []).append(t)
    for k in ayah_index:
        ayah_index[k].sort(key=lambda x: x.word)
    return ayah_index


def progress_row_for_token(token_id: str, now: datetime, rng: random.Random, state: str | None = None) -> Dict:
    total_reviews = rng.randint(0, 18)
    total_wrong = rng.randint(0, max(1, total_reviews // 3))
    total_correct = max(0, total_reviews - total_wrong)
    due_shift_hours = rng.randint(-72, 72)
    picked_state = state or rng.choice([STATE_NEW, STATE_LEARNING, STATE_REVIEWING, STATE_MASTERED])
    return {
        "token_id": token_id,
        "state": picked_state,
        "stability": round(rng.uniform(0.2, 6.0), 3),
        "difficulty_user": round(rng.uniform(0.15, 0.95), 3),
        "next_review_at": (now + timedelta(hours=due_shift_hours)).isoformat(),
        "last_seen_at": (now - timedelta(hours=rng.randint(1, 96))).isoformat(),
        "first_seen_at": (now - timedelta(days=rng.randint(1, 60))).isoformat(),
        "total_reviews": total_reviews,
        "total_correct": total_correct,
        "total_wrong": total_wrong,
        "last_outcome": rng.choice(["again", "hard", "good", "easy"]),
    }


def simulate_user_progress(tokens: List[Token], ayah_index: Dict[Tuple[int, int], List[Token]], rng: random.Random) -> Dict[str, Dict]:
    """
    Fake progress for demo generation.
    Important: ensure some complete ayahs are "covered" so ayah-assembly tasks are possible.
    """
    now = datetime.now(timezone.utc)
    progress: Dict[str, Dict] = {}

    # 1) random sample baseline
    sample_pool = tokens[:400] if len(tokens) >= 400 else tokens
    sampled = rng.sample(sample_pool, min(60, len(sample_pool)))
    for t in sampled:
        progress[t.token_id] = progress_row_for_token(t.token_id, now, rng)

    # 2) enforce complete coverage for several short ayahs (eligible for ayah tasks)
    short_ayahs = sorted(ayah_index.items(), key=lambda kv: (len(kv[1]), kv[0][0], kv[0][1]))
    covered = 0
    for (_, _), ayah_tokens in short_ayahs:
        if len(ayah_tokens) <= LESSON_CONFIG["max_ayah_tokens_full"]:
            for t in ayah_tokens:
                if t.token_id not in progress:
                    progress[t.token_id] = progress_row_for_token(t.token_id, now, rng, state=STATE_REVIEWING)
            covered += 1
        if covered >= 8:
            break

    return progress


def score_due_item(p: Dict, now: datetime, token: Token) -> float:
    next_review_at = datetime.fromisoformat(p["next_review_at"])
    overdue_hours = max(0.0, (now - next_review_at).total_seconds() / 3600)
    wrong_rate = p["total_wrong"] / max(1, p["total_reviews"])
    return overdue_hours * 1.2 + wrong_rate * 3.0 + token.freq_global * 0.02


def pick_due(tokens_by_id: Dict[str, Token], progress: Dict[str, Dict], count: int, now: datetime) -> List[Token]:
    candidates: List[Tuple[float, Token]] = []
    for token_id, p in progress.items():
        if p["state"] in {STATE_LEARNING, STATE_REVIEWING, STATE_LAPSED, STATE_MASTERED}:
            next_review_at = datetime.fromisoformat(p["next_review_at"])
            if next_review_at <= now and token_id in tokens_by_id:
                t = tokens_by_id[token_id]
                candidates.append((score_due_item(p, now, t), t))

    candidates.sort(key=lambda x: x[0], reverse=True)

    # Anti-duplicate by concept in card-based due queue.
    selected: List[Token] = []
    seen_concepts: set[str] = set()
    for _, t in candidates:
        if t.concept_key in seen_concepts:
            continue
        selected.append(t)
        seen_concepts.add(t.concept_key)
        if len(selected) >= count:
            return selected

    # Fallback: if too few unique concepts, allow duplicates.
    if len(selected) < count:
        for _, t in candidates:
            if t in selected:
                continue
            selected.append(t)
            if len(selected) >= count:
                break

    return selected


def pick_new(
    tokens: List[Token],
    tokens_by_id: Dict[str, Token],
    progress: Dict[str, Dict],
    excluded_ids: set[str],
    count: int,
) -> List[Token]:
    """
    New-intro selection policy:
    1) One intro per concept (lemma/surface), avoid repeating same word as "new".
    2) Prefer high-frequency concepts first.
    3) Enforce POS diversity (avoid long runs of one POS class).
    """
    progress_concepts = {
        tokens_by_id[tid].concept_key
        for tid in progress.keys()
        if tid in tokens_by_id
    }

    # Candidate concept -> best representative token for intro.
    concept_rep: Dict[str, Token] = {}
    for t in tokens:
        if t.token_id in progress or t.token_id in excluded_ids:
            continue
        if not t.audio_key or not t.translation_en:
            continue
        if t.concept_key in progress_concepts:
            # already seen concept: can appear in other tasks, but not as NEW intro
            continue

        prev = concept_rep.get(t.concept_key)
        if prev is None:
            concept_rep[t.concept_key] = t
        else:
            # keep earliest occurrence as representative
            if (t.surah, t.ayah, t.word) < (prev.surah, prev.ayah, prev.word):
                concept_rep[t.concept_key] = t

    reps = list(concept_rep.values())
    if not reps:
        return []

    # Rank by concept frequency (primary), then token frequency/location.
    reps.sort(key=lambda x: (-x.concept_freq, -x.freq_global, x.surah, x.ayah, x.word))

    # POS-diversity round: try to cover multiple buckets first.
    by_bucket: Dict[str, List[Token]] = {}
    for t in reps:
        by_bucket.setdefault(pos_bucket(t.pos), []).append(t)

    selected: List[Token] = []
    used_concepts: set[str] = set()

    bucket_order = sorted(
        by_bucket.keys(),
        key=lambda b: (-by_bucket[b][0].concept_freq, b),
    )

    # Round-robin over buckets to avoid single-POS domination.
    bucket_idx = {b: 0 for b in bucket_order}
    exhausted = False
    while len(selected) < count and not exhausted:
        exhausted = True
        for b in bucket_order:
            i = bucket_idx[b]
            items = by_bucket[b]
            while i < len(items) and items[i].concept_key in used_concepts:
                i += 1
            bucket_idx[b] = i
            if i < len(items):
                t = items[i]
                selected.append(t)
                used_concepts.add(t.concept_key)
                bucket_idx[b] += 1
                exhausted = False
                if len(selected) >= count:
                    break

    # Fallback fill by global rank.
    if len(selected) < count:
        for t in reps:
            if t.concept_key in used_concepts:
                continue
            selected.append(t)
            used_concepts.add(t.concept_key)
            if len(selected) >= count:
                break

    return selected[:count]


def pick_reinforcement(
    tokens_by_id: Dict[str, Token],
    progress: Dict[str, Dict],
    excluded_ids: set[str],
    count: int,
    blocked_concepts: set[str] | None = None,
) -> List[Token]:
    weak: List[Tuple[float, Token]] = []
    blocked_concepts = blocked_concepts or set()

    for token_id, p in progress.items():
        if token_id in excluded_ids or token_id not in tokens_by_id:
            continue
        if p["total_reviews"] <= 0:
            continue
        wrong_rate = p["total_wrong"] / max(1, p["total_reviews"])
        if wrong_rate > 0:
            weak.append((wrong_rate, tokens_by_id[token_id]))

    weak.sort(key=lambda x: x[0], reverse=True)

    # Anti-duplicate by concept for card-based reinforcement.
    selected: List[Token] = []
    seen_concepts: set[str] = set(blocked_concepts)
    for _, t in weak:
        if t.concept_key in seen_concepts:
            continue
        selected.append(t)
        seen_concepts.add(t.concept_key)
        if len(selected) >= count:
            return selected

    # Fallback: allow duplicates if needed to fill quota.
    if len(selected) < count:
        for _, t in weak:
            if t in selected:
                continue
            selected.append(t)
            if len(selected) >= count:
                break

    return selected


def token_payload(t: Token) -> Dict:
    return {
        "token_id": t.token_id,
        "location": t.location,
        "surah": t.surah,
        "ayah": t.ayah,
        "word": t.word,
        "ar": t.full_form_ar,
        "lemma_ar": t.lemma_ar,
        "root_ar": t.root_ar,
        "pos": t.pos,
        "translation_en": t.translation_en,
        "audio_key": t.audio_key,
        "freq_global": t.freq_global,
        "concept_key": t.concept_key,
        "concept_freq": t.concept_freq,
        "pos_bucket": pos_bucket(t.pos),
    }


def _is_pronoun_token(t: Token) -> bool:
    return pos_bucket(t.pos) == "pronoun"


def _collect_mcq_distractors(
    correct: Token,
    candidates: List[Token],
    n: int,
    rng: random.Random,
) -> List[str]:
    needed = max(0, n - 1)
    if needed <= 0:
        return []

    filtered = [
        t for t in candidates
        if t.token_id != correct.token_id and t.translation_en and t.translation_en != correct.translation_en
    ]
    rng.shuffle(filtered)

    unique: List[str] = []
    seen = {correct.translation_en.strip().lower()}
    for t in filtered:
        key = t.translation_en.strip().lower()
        if key in seen:
            continue
        seen.add(key)
        unique.append(t.translation_en)
        if len(unique) >= needed:
            break

    return unique


def mcq_options(
    correct: Token,
    pool: List[Token],
    known_token_ids: set[str],
    rng: random.Random,
    n: int = 4,
) -> List[str]:
    # Prefer known-token distractors; fallback to unknown-token distractors.
    known_pool = [t for t in pool if t.token_id in known_token_ids]
    unknown_pool = [t for t in pool if t.token_id not in known_token_ids]

    # Pronoun-aware distractors for pronoun questions.
    if _is_pronoun_token(correct):
        known_pron = [t for t in known_pool if _is_pronoun_token(t)]
        unknown_pron = [t for t in unknown_pool if _is_pronoun_token(t)]

        distractors = _collect_mcq_distractors(correct, known_pron, n, rng)
        if len(distractors) < n - 1:
            distractors += _collect_mcq_distractors(
                correct,
                [t for t in unknown_pron if t.translation_en not in distractors],
                n - len(distractors),
                rng,
            )
    else:
        distractors = []

    if len(distractors) < n - 1:
        distractors += _collect_mcq_distractors(
            correct,
            [t for t in known_pool if t.translation_en not in distractors],
            n - len(distractors),
            rng,
        )

    if len(distractors) < n - 1:
        distractors += _collect_mcq_distractors(
            correct,
            [t for t in unknown_pool if t.translation_en not in distractors],
            n - len(distractors),
            rng,
        )

    options = [correct.translation_en] + distractors[: n - 1]
    while len(options) < n:
        options.append(f"Option {len(options)+1}")
    rng.shuffle(options)
    return options


def all_ayah_tokens_in_progress(ayah_tokens: List[Token], progress_ids: set[str]) -> bool:
    return all(t.token_id in progress_ids for t in ayah_tokens)


def all_ayah_concepts_known(ayah_tokens: List[Token], known_concepts: set[str]) -> bool:
    """Check if user knows all concepts in an ayah (by concept_key, not token_id)."""
    return all(t.concept_key in known_concepts for t in ayah_tokens)


def build_known_concepts(progress: Dict[str, Dict], tokens_by_id: Dict[str, "Token"]) -> set[str]:
    """Build set of concept_keys the user has seen (any non-new state)."""
    concepts: set[str] = set()
    for token_id, p in progress.items():
        if p.get("state", "new") == STATE_NEW:
            continue
        if token_id in tokens_by_id:
            concepts.add(tokens_by_id[token_id].concept_key)
    return concepts


def split_long_ayah_into_segments(ayah_tokens: List[Token], segment_len: int) -> List[List[Token]]:
    """
    Sequential segmentation policy for long ayahs.
    Heuristic: contiguous chunks to preserve reading order.
    """
    if len(ayah_tokens) <= segment_len:
        return [ayah_tokens]

    segments: List[List[Token]] = []
    start = 0
    n = len(ayah_tokens)
    while start < n:
        end = min(start + segment_len, n)
        segments.append(ayah_tokens[start:end])
        start = end
    return segments


def choose_eligible_ayah_segments(
    ayah_index: Dict[Tuple[int, int], List[Token]],
    progress_ids: set[str],
    selected_tokens: List[Token],
    known_concepts: set[str] | None = None,
) -> List[Dict]:
    selected_locs = {(t.surah, t.ayah) for t in selected_tokens}
    candidates: List[Dict] = []

    # Prefer ayahs related to selected tokens, then others
    ordered_ayah_keys = list(selected_locs) + [k for k in ayah_index.keys() if k not in selected_locs]

    for k in ordered_ayah_keys:
        surah_num, ayah_num = k
        # Skip Al-Muqatta'at (disconnected letters at ayah 1 of specific surahs).
        if ayah_num == 1 and surah_num in MUQATTAAT_SURAHS:
            continue

        ayah_tokens = ayah_index.get(k)
        if not ayah_tokens:
            continue
        # Concept-based check: user knows the word meaning even if from a different location
        if known_concepts is not None:
            if not all_ayah_concepts_known(ayah_tokens, known_concepts):
                continue
        elif not all_ayah_tokens_in_progress(ayah_tokens, progress_ids):
            continue

        token_count = len(ayah_tokens)
        # Minimum 3 tokens for ayah assembly tasks (single/two-word ayahs are trivial)
        if token_count < 3:
            continue

        # Only use complete ayahs (no segmentation) — max 10 tokens to keep difficulty reasonable
        if token_count > LESSON_CONFIG["max_ayah_tokens_full"]:
            continue

        candidates.append(
            {
                "surah": k[0],
                "ayah": k[1],
                "segment_index": 1,
                "segment_start_word": ayah_tokens[0].word,
                "segment_end_word": ayah_tokens[-1].word,
                "segment_tokens": ayah_tokens,
                "is_segmented": False,
                "total_ayah_tokens": token_count,
            }
        )

    return candidates


def pick_difficulty_by_len(segment_len: int) -> str:
    if segment_len <= 6:
        return "easy"
    if segment_len <= 8:
        return "medium"
    return "hard"


def distractor_count_for_difficulty(level: str) -> int:
    if level == "easy":
        return LESSON_CONFIG["distractor_count_easy"]
    if level == "medium":
        return LESSON_CONFIG["distractor_count_medium"]
    return LESSON_CONFIG["distractor_count_hard"]


def pick_distractor_tokens(
    seen_tokens: List[Token],
    segment_tokens: List[Token],
    count: int,
    rng: random.Random,
) -> List[Token]:
    segment_ids = {t.token_id for t in segment_tokens}
    pool = [t for t in seen_tokens if t.token_id not in segment_ids]
    if not pool or count <= 0:
        return []
    rng.shuffle(pool)
    return pool[:count]


def build_ayah_assembly_step(
    task_type: str,
    segment: Dict,
    seen_tokens: List[Token],
    rng: random.Random,
) -> Dict:
    seg_tokens: List[Token] = segment["segment_tokens"]
    difficulty = pick_difficulty_by_len(len(seg_tokens))
    dist_n = distractor_count_for_difficulty(difficulty)
    distractors = pick_distractor_tokens(seen_tokens, seg_tokens, dist_n, rng)

    token_units = [
        {
            "token_id": t.token_id,
            "location": t.location,
            "order": t.word,
            "ar": t.full_form_ar,
            "translation_en": t.translation_en,
        }
        for t in seg_tokens
    ]

    if task_type in {"ayah_build_ar_from_translation", "ayah_build_ar_from_audio"}:
        pool = [{"token_id": t.token_id, "text": t.full_form_ar, "location": t.location, "is_distractor": False} for t in seg_tokens]
        pool += [{"token_id": t.token_id, "text": t.full_form_ar, "location": t.location, "is_distractor": True} for t in distractors]
        rng.shuffle(pool)
    else:
        # Keep translation as token-unit; no split by spaces.
        pool = [
            {
                "token_id": t.token_id,
                "text": t.translation_en,
                "location": t.location,
                "is_distractor": False,
            }
            for t in seg_tokens
        ]
        pool += [
            {
                "token_id": t.token_id,
                "text": t.translation_en,
                "location": t.location,
                "is_distractor": True,
            }
            for t in distractors
            if t.translation_en
        ]
        rng.shuffle(pool)

    step = {
        "type": task_type,
        "skill_type": "listening" if task_type == "ayah_build_ar_from_audio" else ("reading" if task_type == "ayah_build_ar_from_translation" else "ar_en"),
        "surah": segment["surah"],
        "ayah": segment["ayah"],
        "ayah_segment_index": segment["segment_index"],
        "segment_start_word": segment["segment_start_word"],
        "segment_end_word": segment["segment_end_word"],
        "is_segmented": segment["is_segmented"],
        "total_ayah_tokens": segment["total_ayah_tokens"],
        "difficulty": difficulty,
        "gold_order_token_ids": [t.token_id for t in seg_tokens],
        "token_units": token_units,
        "pool": pool,
        "constraints": {
            "verify_by": "token_id",
            "translation_unit_policy": "no_split",
            "distractors_from_seen_only": True,
        },
    }

    if task_type == "ayah_build_ar_from_translation":
        step["prompt_translation_units"] = [t.translation_en for t in seg_tokens]
    elif task_type == "ayah_build_ar_from_audio":
        # For segment audio we attach token-level keys for now.
        step["prompt_audio_keys"] = [t.audio_key for t in seg_tokens if t.audio_key]
    elif task_type == "ayah_build_translation_from_ar":
        step["prompt_ar_tokens"] = [t.full_form_ar for t in seg_tokens]

    return step


def build_lesson(tokens: List[Token], seed: int, progress_override: Dict[str, Dict] | None = None) -> Dict:
    rng = random.Random(seed)
    random.seed(seed)

    now = datetime.now(timezone.utc)
    tokens_by_id = {t.token_id: t for t in tokens}
    ayah_index = build_ayah_index(tokens)

    if progress_override is not None:
        progress = progress_override
    else:
        progress = simulate_user_progress(tokens, ayah_index, rng)

    # Dynamic new/review ratio based on user's known word count
    total_known = sum(1 for p in progress.values() if p.get("state", "new") != "new")
    from engine.srs_engine import compute_dynamic_counts

    dyn_new, dyn_review = compute_dynamic_counts(
        total_known,
        target_steps=LESSON_CONFIG["target_steps"],
        base_new=LESSON_CONFIG["new_count"],
        base_review=LESSON_CONFIG["due_count"],
    )

    due = pick_due(tokens_by_id, progress, dyn_review, now)
    excluded = {t.token_id for t in due}
    new_tokens = pick_new(tokens, tokens_by_id, progress, excluded, dyn_new)
    excluded.update(t.token_id for t in new_tokens)
    blocked_concepts = {t.concept_key for t in due + new_tokens}
    reinforcement = pick_reinforcement(
        tokens_by_id,
        progress,
        excluded,
        LESSON_CONFIG["reinforcement_count"],
        blocked_concepts=blocked_concepts,
    )

    steps: List[Dict] = []
    progress_ids = set(progress.keys())

    core_steps: List[Dict] = []

    for t in due:
        core_steps.append(
            {
                "type": "review_card",
                "skill_type": "ar_en",
                "token": token_payload(t),
                "task": "meaning_choice",
                "options": mcq_options(t, tokens, progress_ids, rng, LESSON_CONFIG["review_choices"]),
                "correct": t.translation_en,
            }
        )

    # Delayed recall pool: translation_to_word for new words, shuffled at the end
    delayed_recall: List[Dict] = []

    for t in new_tokens:
        tp = token_payload(t)
        opts = mcq_options(t, tokens, progress_ids, rng, LESSON_CONFIG["review_choices"])

        # Format 1: new_word_intro (reading)
        core_steps.append({"type": "new_word_intro", "skill_type": "reading", "token": tp})

        # Format 2: meaning_choice (ar → en MCQ)
        core_steps.append({
            "type": "meaning_choice", "skill_type": "ar_en",
            "token": tp, "options": opts, "correct": t.translation_en,
        })

        # Format 3: audio_to_meaning (listening MCQ) — only if audio exists
        if t.audio_key:
            core_steps.append({
                "type": "audio_to_meaning", "skill_type": "listening",
                "token": tp,
                "options": mcq_options(t, tokens, progress_ids, rng, LESSON_CONFIG["review_choices"]),
                "correct": t.translation_en,
            })

        # Format 4: translation_to_word (en → ar, delayed recall — added to end)
        delayed_recall.append({
            "type": "translation_to_word", "skill_type": "en_ar",
            "token": tp,
            "prompt_translation": t.translation_en,
            "options": [tp["ar"]] + [
                token_payload(d)["ar"]
                for d in rng.sample(
                    [x for x in tokens if x.token_id != t.token_id and (x.full_form_ar or x.lemma_ar)],
                    min(3, len(tokens) - 1),
                )
            ],
            "correct": tp["ar"],
        })
        # Shuffle the options for translation_to_word
        rng.shuffle(delayed_recall[-1]["options"])

    reinforcement_steps: List[Dict] = []
    for t in reinforcement:
        reinforcement_steps.append(
            {
                "type": "reinforcement",
                "skill_type": "listening" if t.audio_key else "ar_en",
                "token": token_payload(t),
                "task": "audio_to_meaning" if t.audio_key else "meaning_choice",
                "options": mcq_options(t, tokens, progress_ids, rng, LESSON_CONFIG["review_choices"]),
                "correct": t.translation_en,
            }
        )

    # Interleave reinforcement into core to avoid consecutive reinforcement blocks.
    if not core_steps:
        steps.extend(reinforcement_steps)
    else:
        interval = max(1, len(core_steps) // max(1, len(reinforcement_steps))) if reinforcement_steps else 0
        r_idx = 0
        for idx, step in enumerate(core_steps, start=1):
            steps.append(step)
            should_place = (
                reinforcement_steps
                and r_idx < len(reinforcement_steps)
                and (idx % interval == 0)
                and (not steps or steps[-1].get("type") != "reinforcement")
            )
            if should_place:
                steps.append(reinforcement_steps[r_idx])
                r_idx += 1

        # Append any remaining reinforcement with non-consecutive guarantee.
        while r_idx < len(reinforcement_steps):
            if steps and steps[-1].get("type") == "reinforcement":
                # Insert before the last non-reinforcement step when possible.
                insert_at = len(steps)
                for i in range(len(steps) - 1, -1, -1):
                    if steps[i].get("type") != "reinforcement":
                        insert_at = i + 1
                        break
                steps.insert(insert_at, reinforcement_steps[r_idx])
            else:
                steps.append(reinforcement_steps[r_idx])
            r_idx += 1

    # Delayed recall: translation_to_word for new words (shuffled, spaced from intro)
    rng.shuffle(delayed_recall)
    steps.extend(delayed_recall)

    # Ayah assembly tasks (replaces ayah_context)
    seen_tokens = [tokens_by_id[tid] for tid in progress_ids if tid in tokens_by_id]
    selected_tokens = due + new_tokens + reinforcement
    known_concepts = build_known_concepts(progress, tokens_by_id)
    ayah_segments = choose_eligible_ayah_segments(ayah_index, progress_ids, selected_tokens, known_concepts=known_concepts)

    ayah_steps: List[Dict] = []
    if ayah_segments:
        rng.shuffle(ayah_segments)
        for i in range(min(LESSON_CONFIG["ayah_assembly_count"], len(ayah_segments))):
            seg = ayah_segments[i]
            task_type = AYAH_TASK_TYPES[i % len(AYAH_TASK_TYPES)]
            ayah_steps.append(build_ayah_assembly_step(task_type, seg, seen_tokens, rng))

    steps.extend(ayah_steps)

    target = LESSON_CONFIG["target_steps"]
    if len(steps) < target:
        pad_source = due + new_tokens
        used_pad: set[str] = set()
        # Collect already-used (token_id, review_card) pairs to avoid duplicates
        for s in steps:
            tid = s.get("token", {}).get("token_id")
            if tid and s.get("type") == "review_card":
                used_pad.add(tid)

        for t in pad_source:
            if len(steps) >= target:
                break
            if t.token_id in used_pad:
                continue
            used_pad.add(t.token_id)
            steps.append(
                {
                    "type": "review_card",
                    "skill_type": "ar_en",
                    "token": token_payload(t),
                    "task": "meaning_choice",
                    "options": mcq_options(t, tokens, progress_ids, rng, LESSON_CONFIG["review_choices"]),
                    "correct": t.translation_en,
                }
            )
    # NOTE:
    # - target_steps remains a planning target from config and is not mutated.
    # - reinforcement steps are never trimmed; total steps may exceed target.

    lesson = {
        "lesson_id": f"lesson-{now.strftime('%Y%m%d-%H%M%S')}-{rng.randint(1000, 9999)}",
        "generated_at_utc": now.isoformat(),
        "lesson_type": "daily",
        "algorithm_version": "v3-graduated-srs-dynamic-ratio",
        "config": LESSON_CONFIG,
        "dynamic": {
            "total_known_words": total_known,
            "computed_new": dyn_new,
            "computed_review": dyn_review,
            "actual_new": len(new_tokens),
            "actual_due": len(due),
            "actual_reinforcement": len(reinforcement),
        },
        "selection": {
            "due": [token_payload(t) for t in due],
            "new": [token_payload(t) for t in new_tokens],
            "reinforcement": [token_payload(t) for t in reinforcement],
        },
        "steps": steps,
        "notes": {
            "quran_safe": True,
            "content_policy": "All tokens and ayah tasks are selected only from dataset.csv",
            "persistence": "No lesson history is saved by this script",
            "srs_role": "selects what/when to study",
            "skill_role": "selects how each selected unit is practiced",
            "long_ayah_policy": "Long ayahs are segmented into sequential chunks",
            "new_intro_policy": "One intro per concept_key (lemma/surface), no duplicate new-intro for same word concept",
            "new_order_policy": "High-frequency concepts first with POS-bucket diversity",
            "card_dedup_policy": "Due/Reinforcement avoid duplicate concept_key; ayah tasks may still include same concept in different locations",
        },
    }
    return lesson


def build_review_lesson(
    tokens: List[Token],
    seed: int,
    progress_override: Dict[str, Dict],
    target_steps: int = 14,
) -> Dict:
    """Build a review-only lesson from full user progress.

    Rules:
    - no new_word_intro/new words
    - include due + reinforcement + ayah tasks
    - avoid duplicate (token_id + task type) inside one lesson
    - no padding loop that re-adds duplicate cards
    """
    rng = random.Random(seed)
    random.seed(seed)
    now = datetime.now(timezone.utc)

    tokens_by_id = {t.token_id: t for t in tokens}
    ayah_index = build_ayah_index(tokens)
    progress = progress_override or {}
    progress_ids = set(progress.keys())

    # Core review selection
    desired_ayah = LESSON_CONFIG["ayah_assembly_count"]
    desired_reinforcement = LESSON_CONFIG["reinforcement_count"]
    desired_due = max(1, target_steps - desired_ayah - desired_reinforcement)

    due = pick_due(tokens_by_id, progress, desired_due, now)

    # Fallback for review-only: if strict due is sparse, fill from known progress by priority.
    if len(due) < desired_due:
        due_ids = {t.token_id for t in due}
        candidates: List[Tuple[Tuple[int, float, float], Token]] = []

        for token_id, p in progress.items():
            if token_id in due_ids or token_id not in tokens_by_id:
                continue

            state = p.get("state", "new")
            if state == STATE_NEW:
                continue

            next_review_at = p.get("next_review_at")
            overdue_flag = 1
            overdue_hours = 0.0
            if next_review_at:
                try:
                    nr = datetime.fromisoformat(next_review_at)
                    overdue_hours = (now - nr).total_seconds() / 3600.0
                    overdue_flag = 0 if nr <= now else 1
                except Exception:
                    overdue_flag = 1
                    overdue_hours = 0.0

            wrong_rate = p.get("total_wrong", 0) / max(1, p.get("total_reviews", 0))
            priority = (overdue_flag, -overdue_hours, -wrong_rate)
            candidates.append((priority, tokens_by_id[token_id]))

        candidates.sort(key=lambda x: x[0])

        seen_concepts = {t.concept_key for t in due}
        for _, t in candidates:
            if t.concept_key in seen_concepts:
                continue
            due.append(t)
            seen_concepts.add(t.concept_key)
            if len(due) >= desired_due:
                break

    excluded = {t.token_id for t in due}
    blocked_concepts = {t.concept_key for t in due}
    reinforcement = pick_reinforcement(
        tokens_by_id,
        progress,
        excluded,
        desired_reinforcement,
        blocked_concepts=blocked_concepts,
    )

    # Build core steps with dedup by (token_id, template)
    steps: List[Dict] = []
    used_templates: set[tuple[str, str]] = set()

    def add_unique_step(step: Dict, template: str) -> None:
        tid = step.get("token", {}).get("token_id")
        if not tid:
            return
        key = (tid, template)
        if key in used_templates:
            return
        used_templates.add(key)
        steps.append(step)

    for idx, t in enumerate(due):
        tp = token_payload(t)
        variant = idx % 3

        if variant == 0:
            add_unique_step(
                {
                    "type": "review_card",
                    "skill_type": "ar_en",
                    "token": tp,
                    "task": "meaning_choice",
                    "options": mcq_options(t, tokens, progress_ids, rng, LESSON_CONFIG["review_choices"]),
                    "correct": t.translation_en,
                },
                "review_card:meaning_choice",
            )
        elif variant == 1 and t.audio_key:
            add_unique_step(
                {
                    "type": "audio_to_meaning",
                    "skill_type": "listening",
                    "token": tp,
                    "options": mcq_options(t, tokens, progress_ids, rng, LESSON_CONFIG["review_choices"]),
                    "correct": t.translation_en,
                },
                "audio_to_meaning",
            )
        else:
            distractor_pool = [x for x in tokens if x.token_id != t.token_id and (x.full_form_ar or x.lemma_ar)]
            options = [tp["ar"]] + [
                token_payload(d)["ar"]
                for d in rng.sample(distractor_pool, min(3, len(distractor_pool)))
            ]
            rng.shuffle(options)
            add_unique_step(
                {
                    "type": "translation_to_word",
                    "skill_type": "en_ar",
                    "token": tp,
                    "prompt_translation": t.translation_en,
                    "options": options,
                    "correct": tp["ar"],
                },
                "translation_to_word",
            )

    for t in reinforcement:
        add_unique_step(
            {
                "type": "reinforcement",
                "skill_type": "listening" if t.audio_key else "ar_en",
                "token": token_payload(t),
                "task": "audio_to_meaning" if t.audio_key else "meaning_choice",
                "options": mcq_options(t, tokens, progress_ids, rng, LESSON_CONFIG["review_choices"]),
                "correct": t.translation_en,
            },
            "reinforcement",
        )

    # Ayah tasks (review mode should still include them when possible)
    selected_tokens = due + reinforcement
    if not selected_tokens:
        selected_tokens = [tokens_by_id[tid] for tid in list(progress_ids)[:20] if tid in tokens_by_id]

    seen_tokens = [tokens_by_id[tid] for tid in progress_ids if tid in tokens_by_id]
    known_concepts = build_known_concepts(progress, tokens_by_id)
    ayah_segments = choose_eligible_ayah_segments(ayah_index, progress_ids, selected_tokens, known_concepts=known_concepts)
    ayah_source = "strict"
    ayah_block_reason = ""

    # Relaxed fallback for review-only:
    # find complete short ayahs where most concepts are known (>=80% coverage).
    if not ayah_segments:
        selected_locs = {(t.surah, t.ayah) for t in selected_tokens}
        ordered_ayah_keys = list(selected_locs) + [k for k in ayah_index.keys() if k not in selected_locs]

        def _find_relaxed_full_ayahs(min_coverage: float) -> List[Dict]:
            out: List[Dict] = []
            for k in ordered_ayah_keys:
                surah_num, ayah_num = k
                if ayah_num == 1 and surah_num in MUQATTAAT_SURAHS:
                    continue
                ayah_tokens = ayah_index.get(k)
                if not ayah_tokens:
                    continue
                token_count = len(ayah_tokens)
                if token_count < 3 or token_count > LESSON_CONFIG["max_ayah_tokens_full"]:
                    continue
                known_count = sum(1 for t in ayah_tokens if t.concept_key in known_concepts)
                if known_count / token_count >= min_coverage:
                    out.append(
                        {
                            "surah": k[0],
                            "ayah": k[1],
                            "segment_index": 1,
                            "segment_start_word": ayah_tokens[0].word,
                            "segment_end_word": ayah_tokens[-1].word,
                            "segment_tokens": ayah_tokens,
                            "is_segmented": False,
                            "total_ayah_tokens": token_count,
                        }
                    )
            return out

        ayah_segments = _find_relaxed_full_ayahs(0.8)
        if ayah_segments:
            ayah_source = "relaxed_full_ayah_80pct"
        else:
            ayah_segments = _find_relaxed_full_ayahs(0.6)
            if ayah_segments:
                ayah_source = "relaxed_full_ayah_60pct"
            else:
                ayah_source = "none"
                ayah_block_reason = "no_complete_ayah_with_sufficient_concept_coverage"

    actual_ayah = 0
    if ayah_segments:
        # Prioritize ayah segments related to selected core tokens.
        selected_locs = {(t.surah, t.ayah) for t in selected_tokens}
        prioritized = [s for s in ayah_segments if (s["surah"], s["ayah"]) in selected_locs]
        others = [s for s in ayah_segments if (s["surah"], s["ayah"]) not in selected_locs]
        rng.shuffle(prioritized)
        rng.shuffle(others)
        ordered_segments = prioritized + others

        for i in range(min(desired_ayah, len(ordered_segments))):
            seg = ordered_segments[i]
            task_type = AYAH_TASK_TYPES[i % len(AYAH_TASK_TYPES)]
            steps.append(build_ayah_assembly_step(task_type, seg, seen_tokens, rng))
            actual_ayah += 1

    # Safe fill to target without duplicate (token_id + template)
    fill_added = 0
    fill_block_reason = ""
    if len(steps) < target_steps:
        fallback_known: List[Token] = []
        due_ids = {t.token_id for t in due}
        for token_id, p in progress.items():
            if token_id in due_ids or token_id not in tokens_by_id:
                continue
            if p.get("state", "new") == STATE_NEW:
                continue
            fallback_known.append(tokens_by_id[token_id])

        fill_candidates: List[Token] = []
        fill_candidates.extend(due)
        fill_candidates.extend(reinforcement)
        fill_candidates.extend(fallback_known)

        if fill_candidates:
            rng.shuffle(fill_candidates)

        def _build_template_step(t: Token, template: str) -> Dict | None:
            tp = token_payload(t)
            if template == "review_card:meaning_choice":
                return {
                    "type": "review_card",
                    "skill_type": "ar_en",
                    "token": tp,
                    "task": "meaning_choice",
                    "options": mcq_options(t, tokens, progress_ids, rng, LESSON_CONFIG["review_choices"]),
                    "correct": t.translation_en,
                }
            if template == "audio_to_meaning":
                if not t.audio_key:
                    return None
                return {
                    "type": "audio_to_meaning",
                    "skill_type": "listening",
                    "token": tp,
                    "options": mcq_options(t, tokens, progress_ids, rng, LESSON_CONFIG["review_choices"]),
                    "correct": t.translation_en,
                }
            if template == "translation_to_word":
                distractor_pool = [x for x in tokens if x.token_id != t.token_id and (x.full_form_ar or x.lemma_ar)]
                options = [tp["ar"]] + [
                    token_payload(d)["ar"]
                    for d in rng.sample(distractor_pool, min(3, len(distractor_pool)))
                ]
                rng.shuffle(options)
                return {
                    "type": "translation_to_word",
                    "skill_type": "en_ar",
                    "token": tp,
                    "prompt_translation": t.translation_en,
                    "options": options,
                    "correct": tp["ar"],
                }
            return None

        templates = ["review_card:meaning_choice", "audio_to_meaning", "translation_to_word"]
        stalled_rounds = 0

        while len(steps) < target_steps and stalled_rounds < 2:
            before_len = len(steps)
            for t in fill_candidates:
                for template in templates:
                    if len(steps) >= target_steps:
                        break
                    step = _build_template_step(t, template)
                    if step is None:
                        continue
                    prev_len = len(steps)
                    add_unique_step(step, template)
                    if len(steps) > prev_len:
                        fill_added += 1
                if len(steps) >= target_steps:
                    break

            if len(steps) == before_len:
                stalled_rounds += 1
            else:
                stalled_rounds = 0

        if len(steps) < target_steps:
            fill_block_reason = "dedup_exhausted_or_insufficient_known_tokens"

    # Respect hard cap just in case
    if len(steps) > target_steps:
        steps = steps[:target_steps]

    # Add step_id/index
    for i, step in enumerate(steps):
        step["step_id"] = f"step_{i:04d}"
        step["step_index"] = i

    total_known = sum(1 for p in progress.values() if p.get("state", "new") != "new")

    review_config = dict(LESSON_CONFIG)
    review_config["new_count"] = 0

    lesson = {
        "lesson_id": f"lesson-{now.strftime('%Y%m%d-%H%M%S')}-{rng.randint(1000, 9999)}",
        "generated_at_utc": now.isoformat(),
        "lesson_type": "review_only",
        "algorithm_version": "v3-graduated-srs-dynamic-ratio",
        "config": review_config,
        "dynamic": {
            "total_known_words": total_known,
            "computed_new": 0,
            "computed_review": len(due),
            "actual_new": 0,
            "actual_due": len(due),
            "actual_reinforcement": len(reinforcement),
            "planned_steps": target_steps,
            "actual_steps": len(steps),
            "planned_ayah": desired_ayah,
            "actual_ayah": actual_ayah,
            "fill_added": fill_added,
        },
        "selection": {
            "due": [token_payload(t) for t in due],
            "new": [],
            "reinforcement": [token_payload(t) for t in reinforcement],
        },
        "steps": steps,
        "notes": {
            "quran_safe": True,
            "content_policy": "All tokens and ayah tasks are selected only from dataset.csv",
            "persistence": "No lesson history is saved by this script",
            "srs_role": "selects what/when to study",
            "skill_role": "selects how each selected unit is practiced",
            "review_only": True,
            "dedup_policy": "No duplicate (token_id + task template) in one lesson",
            "target_policy": "Best-effort to reach target_steps with unique templates per token",
            "target_block_reason": fill_block_reason,
            "ayah_source": ayah_source,
            "ayah_block_reason": ayah_block_reason,
        },
    }
    return lesson


def main() -> None:
    args = parse_args()
    dataset_path = Path(args.dataset)
    out_path = Path(args.out)

    if not dataset_path.exists():
        raise FileNotFoundError(f"Dataset not found: {dataset_path}")

    tokens = read_tokens(dataset_path)
    if not tokens:
        raise RuntimeError("No tokens were loaded from dataset")

    progress_override = None
    store = None

    if args.progress:
        from engine.user_progress_store import UserProgressStore
        store = UserProgressStore(args.progress)
        progress_override = store.to_legacy_progress()

        # If progress is empty, bootstrap with first batch as "new" (no simulated data).
        if not progress_override:
            print(f"Progress file empty — first run, no simulated progress.")

    lesson = build_lesson(tokens, seed=args.seed, progress_override=progress_override)

    # After lesson generation, mark selected new words in progress store.
    if store is not None:
        from engine.srs_engine import AnswerSignal
        from datetime import datetime, timezone
        now = datetime.now(timezone.utc)

        for t_payload in lesson.get("selection", {}).get("new", []):
            tid = t_payload.get("token_id", "")
            ckey = t_payload.get("concept_key", "")
            if tid:
                p = store.get_or_create(tid, ckey)
                if p.first_seen_at is None:
                    p.first_seen_at = now.isoformat()
                    p.last_seen_at = now.isoformat()

        # Mark due/reinforcement as "seen" (last_seen_at update).
        for section in ["due", "reinforcement"]:
            for t_payload in lesson.get("selection", {}).get(section, []):
                tid = t_payload.get("token_id", "")
                if tid and store.has(tid):
                    prog = store.get(tid)
                    prog.last_seen_at = now.isoformat()

        store.save()
        stats = store.stats()
        print(f"Progress saved: {stats['total_tokens']} tokens tracked, states: {stats['by_state']}")

    out_path.write_text(json.dumps(lesson, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"Lesson generated: {out_path.resolve()}")
    print(f"Algorithm: {lesson['algorithm_version']}")
    print(f"Steps: {len(lesson['steps'])}")


if __name__ == "__main__":
    main()
