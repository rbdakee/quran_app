"""
Learning pace analysis with v3 SRS (graduated steps + dynamic ratio).

Run:
  cd quran-app
  python -m tests.test_learning_pace
"""
from __future__ import annotations

import sys, os
import random
from datetime import datetime, timedelta, timezone
from collections import defaultdict

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from engine.srs_engine import (
    TokenProgress, AnswerSignal, update_progress, compute_dynamic_counts,
    is_due, due_score,
    STATE_NEW, STATE_LEARNING, STATE_REVIEWING, STATE_MASTERED, STATE_LAPSED,
    LEARNING_STEPS_DAYS,
)
from engine.user_progress_store import UserProgressStore


def run_scenario(label, days, base_new, base_review, seed=42):
    print(f"\n{'=' * 70}")
    print(f"  {label}")
    print(f"{'=' * 70}")

    rng = random.Random(seed)
    now = datetime.now(timezone.utc)
    store = UserProgressStore.__new__(UserProgressStore)
    store.path = None
    store._data = {}

    token_reviews = defaultdict(int)
    token_first_day = {}
    token_reviewing_day = {}
    token_mastered_day = {}
    all_tids = []
    daily_stats = []
    word_counter = 0

    for day in range(days):
        day_now = now + timedelta(days=day)
        accuracy = min(0.6 + day * 0.008, 0.92)

        total_known = len([p for p in store._data.values() if p.state != STATE_NEW])
        dyn_new, dyn_rev = compute_dynamic_counts(
            total_known,
            target_steps=14,
            base_new=base_new,
            base_review=base_review,
        )

        # Introduce new words
        new_today = []
        for i in range(dyn_new):
            tid = f"tok:{label}:{word_counter}"
            word_counter += 1
            p = store.get_or_create(tid, f"c_{word_counter}")
            p.first_seen_at = day_now.isoformat()
            p.last_seen_at = day_now.isoformat()
            new_today.append(tid)
            all_tids.append(tid)
            token_first_day[tid] = day

        # Intra-lesson: each new word gets 4 exposures
        for tid in new_today:
            for _ in range(4):
                is_correct = rng.random() < accuracy
                signal = AnswerSignal(
                    is_correct=is_correct, attempt_count=1,
                    latency_ms=rng.randint(1500, 7000),
                )
                store.record_answer(tid, signal, now=day_now)
                token_reviews[tid] += 1

        # Review due words
        due = store.get_due_tokens(day_now, limit=dyn_rev * 2)
        reviewed = 0
        for p in due:
            if p.token_id in new_today:
                continue
            if reviewed >= dyn_rev:
                break
            is_correct = rng.random() < accuracy
            signal = AnswerSignal(
                is_correct=is_correct, attempt_count=1,
                latency_ms=rng.randint(1500, 6000),
            )
            store.record_answer(p.token_id, signal, now=day_now)
            token_reviews[p.token_id] += 1
            reviewed += 1

        # Track transitions
        for tid in all_tids:
            p = store.get(tid)
            if p and p.state == STATE_REVIEWING and tid not in token_reviewing_day:
                token_reviewing_day[tid] = day
            if p and p.state == STATE_MASTERED and tid not in token_mastered_day:
                token_mastered_day[tid] = day

        stats = store.stats()
        daily_stats.append({
            "day": day + 1,
            "total": stats["total_tokens"],
            "new_today": dyn_new,
            "reviewed": reviewed,
            "dyn_ratio": f"{dyn_rev}:{dyn_new}",
            "states": dict(stats["by_state"]),
        })

    # ---- Analysis ----
    review_counts = list(token_reviews.values())
    avg_rev = sum(review_counts) / len(review_counts) if review_counts else 0

    states = store.stats()["by_state"]
    total = len(all_tids)

    print(f"\n  Total words: {total} over {days} days")
    print(f"  Avg reviews/word: {avg_rev:.1f}")
    print(f"  Min reviews: {min(review_counts)}, Max: {max(review_counts)}")

    b1 = sum(1 for c in review_counts if c <= 1)
    b23 = sum(1 for c in review_counts if 2 <= c <= 3)
    b46 = sum(1 for c in review_counts if 4 <= c <= 6)
    b710 = sum(1 for c in review_counts if 7 <= c <= 10)
    b11 = sum(1 for c in review_counts if c >= 11)
    print(f"\n  Review distribution:")
    print(f"    0-1x: {b1:3d} ({b1/total*100:.0f}%)")
    print(f"    2-3x: {b23:3d} ({b23/total*100:.0f}%)")
    print(f"    4-6x: {b46:3d} ({b46/total*100:.0f}%)")
    print(f"    7-10x: {b710:3d} ({b710/total*100:.0f}%)")
    print(f"    11+x: {b11:3d} ({b11/total*100:.0f}%)")

    print(f"\n  Final states:")
    for s in [STATE_NEW, STATE_LEARNING, STATE_REVIEWING, STATE_MASTERED, STATE_LAPSED]:
        c = states.get(s, 0)
        print(f"    {s:12s}: {c:3d} ({c/total*100:5.1f}%)")

    reviewing_times = [token_reviewing_day[t] - token_first_day[t] for t in token_reviewing_day]
    mastered_times = [token_mastered_day[t] - token_first_day[t] for t in token_mastered_day]

    if reviewing_times:
        print(f"\n  Time to reviewing: {len(reviewing_times)} words, "
              f"avg {sum(reviewing_times)/len(reviewing_times):.1f}d, "
              f"min {min(reviewing_times)}d, max {max(reviewing_times)}d")
    else:
        print(f"\n  No words reached reviewing.")
    if mastered_times:
        print(f"  Time to mastered:  {len(mastered_times)} words, "
              f"avg {sum(mastered_times)/len(mastered_times):.1f}d, "
              f"min {min(mastered_times)}d, max {max(mastered_times)}d")

    # Compact day table
    print(f"\n  Day progression (every 5 days):")
    print(f"  {'Day':>4} {'Tot':>4} {'New':>3} {'Rev':>3} {'Ratio':>5} "
          f"{'new':>3} {'lrn':>3} {'rev':>3} {'mst':>3} {'lps':>3}")
    for d in daily_stats:
        if d["day"] % 5 == 0 or d["day"] <= 3 or d["day"] == days:
            s = d["states"]
            print(f"  {d['day']:4d} {d['total']:4d} {d['new_today']:3d} {d['reviewed']:3d} "
                  f"{d['dyn_ratio']:>5s} "
                  f"{s.get('new',0):3d} {s.get('learning',0):3d} "
                  f"{s.get('reviewing',0):3d} {s.get('mastered',0):3d} "
                  f"{s.get('lapsed',0):3d}")


def main():
    run_scenario("Scenario A: Standard (30 days)", days=30, base_new=3, base_review=15)
    run_scenario("Scenario B: Extended (60 days)", days=60, base_new=3, base_review=15, seed=77)
    run_scenario("Scenario C: Intensive (30 days, higher base)", days=30, base_new=5, base_review=15, seed=99)


if __name__ == "__main__":
    main()
