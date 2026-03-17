"""
Shared in-memory cache for active lessons.
Used by both lessons and progress routers.
"""

# In-memory lesson cache (per-session; for production use Redis/DB)
_active_lessons: dict = {}


def cache_lesson(lesson_id: str, lesson: dict) -> None:
    """Cache a lesson by ID."""
    _active_lessons[lesson_id] = lesson


def get_cached_lesson(lesson_id: str) -> dict | None:
    """Retrieve a cached lesson by ID."""
    return _active_lessons.get(lesson_id)


def remove_cached_lesson(lesson_id: str) -> None:
    """Remove a cached lesson by ID."""
    if lesson_id in _active_lessons:
        del _active_lessons[lesson_id]
