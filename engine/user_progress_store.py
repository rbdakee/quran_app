"""
JSON-file based user progress store (Phase B sandbox).

Provides load/save for user_progress.json and helper methods
for the lesson generator to query due/new/reinforcement tokens.
"""
from __future__ import annotations

import json
from datetime import datetime, timezone
from pathlib import Path
from typing import Dict, List, Optional

from engine.srs_engine import (
    TokenProgress,
    AnswerSignal,
    update_progress,
    is_due,
    due_score,
    reinforcement_score,
    STATE_NEW,
)


DEFAULT_PROGRESS_FILE = "user_progress.json"


class UserProgressStore:
    """In-memory progress backed by a JSON file."""

    def __init__(self, path: str | Path = DEFAULT_PROGRESS_FILE):
        self.path = Path(path)
        self._data: Dict[str, TokenProgress] = {}
        self._load()

    # ----- Persistence -----

    def _load(self) -> None:
        if not self.path.exists():
            self._data = {}
            return
        raw = json.loads(self.path.read_text(encoding="utf-8"))
        self._data = {
            tid: TokenProgress.from_dict(d)
            for tid, d in raw.items()
        }

    def save(self) -> None:
        """Write current state to disk."""
        raw = {tid: p.to_dict() for tid, p in self._data.items()}
        self.path.write_text(
            json.dumps(raw, ensure_ascii=False, indent=2),
            encoding="utf-8",
        )

    # ----- CRUD -----

    def get(self, token_id: str) -> Optional[TokenProgress]:
        return self._data.get(token_id)

    def get_or_create(self, token_id: str, concept_key: str = "") -> TokenProgress:
        if token_id not in self._data:
            self._data[token_id] = TokenProgress(
                token_id=token_id,
                concept_key=concept_key,
            )
        return self._data[token_id]

    def has(self, token_id: str) -> bool:
        return token_id in self._data

    def all_progress(self) -> Dict[str, TokenProgress]:
        return dict(self._data)

    def known_token_ids(self) -> set[str]:
        """Token IDs that are not in 'new' state (user has seen them)."""
        return {tid for tid, p in self._data.items() if p.state != STATE_NEW}

    def known_concept_keys(self) -> set[str]:
        """Concept keys the user has encountered."""
        return {p.concept_key for p in self._data.values() if p.concept_key and p.state != STATE_NEW}

    # ----- Queries for lesson generator -----

    def get_due_tokens(self, now: datetime | None = None, limit: int = 50) -> List[TokenProgress]:
        """Return tokens due for review, sorted by urgency."""
        if now is None:
            now = datetime.now(timezone.utc)
        candidates = [p for p in self._data.values() if is_due(p, now)]
        candidates.sort(key=lambda p: due_score(p, now), reverse=True)
        return candidates[:limit]

    def get_reinforcement_candidates(
        self,
        excluded_ids: set[str],
        blocked_concepts: set[str],
        limit: int = 10,
    ) -> List[TokenProgress]:
        """Return weak tokens for reinforcement, excluding already-selected."""
        candidates = [
            p for p in self._data.values()
            if p.token_id not in excluded_ids
            and p.concept_key not in blocked_concepts
            and p.total_reviews > 0
            and p.total_wrong > 0
        ]
        candidates.sort(key=lambda p: reinforcement_score(p), reverse=True)
        return candidates[:limit]

    def record_answer(
        self,
        token_id: str,
        signal: AnswerSignal,
        concept_key: str = "",
        now: datetime | None = None,
    ) -> TokenProgress:
        """Record an answer and update SRS state. Returns updated progress."""
        progress = self.get_or_create(token_id, concept_key)
        update_progress(progress, signal, now)
        return progress

    # ----- Legacy compatibility (for generate_lesson.py) -----

    def to_legacy_progress(self) -> Dict[str, Dict]:
        """Convert to the dict format expected by generate_lesson.py."""
        return {tid: p.to_dict() for tid, p in self._data.items()}

    def progress_ids(self) -> set[str]:
        """All token IDs in progress (any state)."""
        return set(self._data.keys())

    # ----- Stats -----

    def stats(self) -> Dict:
        states = {}
        for p in self._data.values():
            states[p.state] = states.get(p.state, 0) + 1
        return {
            "total_tokens": len(self._data),
            "by_state": states,
        }
