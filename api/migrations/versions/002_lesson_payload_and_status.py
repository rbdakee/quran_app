"""Add lesson payload/status persistence for lesson timeline MVP.

Revision ID: 002_lesson_payload_and_status
Revises: 001_add_lesson_invalidation
Create Date: 2026-03-17
"""
from alembic import op
import sqlalchemy as sa


revision = "002_lesson_payload_and_status"
down_revision = "001_add_lesson_invalidation"
branch_labels = None
depends_on = None


lesson_status = sa.Enum("generated", "in_progress", "completed", "invalidated", name="lesson_status")


def upgrade() -> None:
    bind = op.get_bind()
    lesson_status.create(bind, checkfirst=True)

    op.add_column("lesson_records", sa.Column("status", lesson_status, nullable=True))
    op.add_column("lesson_records", sa.Column("lesson_payload", sa.JSON(), nullable=True))
    op.add_column("lesson_records", sa.Column("seed", sa.Integer(), nullable=True))

    op.execute("""
        UPDATE lesson_records
        SET status = CASE
            WHEN is_invalidated = true THEN 'invalidated'::lesson_status
            WHEN is_completed = true THEN 'completed'::lesson_status
            ELSE 'generated'::lesson_status
        END
    """)

    op.alter_column("lesson_records", "status", nullable=False)
    op.create_index("ix_lesson_records_user_started", "lesson_records", ["user_id", "started_at"], unique=False)
    op.create_index("ix_lesson_records_user_status", "lesson_records", ["user_id", "status"], unique=False)


def downgrade() -> None:
    op.drop_index("ix_lesson_records_user_status", table_name="lesson_records")
    op.drop_index("ix_lesson_records_user_started", table_name="lesson_records")
    op.drop_column("lesson_records", "seed")
    op.drop_column("lesson_records", "lesson_payload")
    op.drop_column("lesson_records", "status")

    bind = op.get_bind()
    lesson_status.drop(bind, checkfirst=True)
