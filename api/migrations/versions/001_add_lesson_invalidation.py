"""Add is_invalidated and invalidated_at to lesson_records.

Revision ID: 001_add_lesson_invalidation
Revises:
Create Date: 2026-03-17
"""
from alembic import op
import sqlalchemy as sa

# revision identifiers
revision = "001_add_lesson_invalidation"
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.add_column(
        "lesson_records",
        sa.Column("is_invalidated", sa.Boolean(), server_default=sa.text("false"), nullable=False),
    )
    op.add_column(
        "lesson_records",
        sa.Column("invalidated_at", sa.DateTime(timezone=True), nullable=True),
    )


def downgrade() -> None:
    op.drop_column("lesson_records", "invalidated_at")
    op.drop_column("lesson_records", "is_invalidated")
