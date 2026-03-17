"""
Simulate answering a generated lesson to test SRS progression.

Usage:
  python simulate_answers.py --lesson lesson.generated.json --progress user_progress.json

Simulates answering each step and updates progress via SRS engine.
"""
from __future__ import annotations

import argparse
import json
import random
from datetime import datetime, timezone
from pathlib import Path

import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from engine.srs_engine import AnswerSignal
from engine.user_progress_store import UserProgressStore


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Simulate lesson answers")
    parser.add_argument("--lesson", default="lesson.generated.json", help="Lesson JSON file")
    parser.add_argument("--progress", default="user_progress.json", help="Progress JSON file")
    parser.add_argument("--accuracy", type=float, default=0.75, help="Simulated accuracy (0.0-1.0)")
    parser.add_argument("--seed", type=int, default=42, help="Random seed")
    return parser.parse_args()


ANSWERABLE_STEP_TYPES = {
    "meaning_choice",
    "review_card",
    "reinforcement",
    "audio_to_meaning",
    "ayah_build_ar_from_translation",
    "ayah_build_ar_from_audio",
    "ayah_build_translation_from_ar",
}


def main() -> None:
    args = parse_args()
    rng = random.Random(args.seed)

    lesson_path = Path(args.lesson)
    if not lesson_path.exists():
        raise FileNotFoundError(f"Lesson file not found: {lesson_path}")

    lesson = json.loads(lesson_path.read_text(encoding="utf-8"))
    store = UserProgressStore(args.progress)
    now = datetime.now(timezone.utc)

    answered = 0
    correct_count = 0

    for step in lesson["steps"]:
        step_type = step.get("type", "")
        if step_type not in ANSWERABLE_STEP_TYPES:
            continue

        token = step.get("token", {})
        token_id = token.get("token_id", "")
        concept_key = token.get("concept_key", "")
        if not token_id:
            continue

        is_correct = rng.random() < args.accuracy
        latency_ms = rng.randint(1500, 10000)

        signal = AnswerSignal(
            is_correct=is_correct,
            attempt_count=1 if is_correct else rng.randint(1, 3),
            latency_ms=latency_ms,
            hint_used=False,
        )

        store.record_answer(token_id, signal, concept_key=concept_key, now=now)
        answered += 1
        if is_correct:
            correct_count += 1

    store.save()

    accuracy = (correct_count / answered * 100) if answered else 0
    stats = store.stats()

    print(f"Answered: {answered} steps")
    print(f"Correct: {correct_count}/{answered} ({accuracy:.1f}%)")
    print(f"Progress: {stats['total_tokens']} tokens, states: {stats['by_state']}")

    # Show a few sample progress records
    all_p = store.all_progress()
    samples = list(all_p.values())[:5]
    print("\nSample progress records:")
    for p in samples:
        print(f"  {p.token_id}: state={p.state} stability={p.stability:.2f}d "
              f"difficulty={p.difficulty:.2f} reviews={p.total_reviews} "
              f"correct={p.total_correct} wrong={p.total_wrong} "
              f"next_review={p.next_review_at}")


if __name__ == "__main__":
    main()
