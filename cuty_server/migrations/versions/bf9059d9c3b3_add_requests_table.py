"""add requests table

Revision ID: bf9059d9c3b3
Revises: fc324c73477e
Create Date: 2025-11-15 16:39:09.855053

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

from src.models.enums import ReqType, ReqState  # 이미 있으면 그대로 두고, 없으면 맞게 import


# revision identifiers, used by Alembic.
revision = "bf9059d9c3b3"
down_revision = "fc324c73477e"
branch_labels = None
depends_on = None


def upgrade():
    bind = op.get_bind()

    # 1) reqtype ENUM 존재 여부 확인
    exists_reqtype = bind.execute(
        sa.text("SELECT 1 FROM pg_type WHERE typname = 'reqtype'")
    ).scalar()

    if not exists_reqtype:
        # 없을 때만 새로 생성
        postgresql.ENUM(ReqType, name="reqtype").create(bind)

    # 2) reqstate ENUM 존재 여부 확인
    exists_reqstate = bind.execute(
        sa.text("SELECT 1 FROM pg_type WHERE typname = 'reqstate'")
    ).scalar()

    if not exists_reqstate:
        postgresql.ENUM(ReqState, name="reqstate").create(bind)

    # 3) requests 테이블 생성 (이미 있는 ENUM 타입만 참조)
    op.create_table(
        "requests",
        sa.Column("id", sa.Integer(), primary_key=True, nullable=False),
        sa.Column("user_id", sa.Integer(), sa.ForeignKey("users.id"),nullable=False),
        sa.Column("req_type", postgresql.ENUM(name="reqtype", create_type=False), nullable=False),
        sa.Column("idempotency_key", sa.String(length=100), unique=True, nullable=True),
        sa.Column("status", postgresql.ENUM(name="reqstate", create_type=False), nullable=True),
        sa.Column("created_at", sa.DateTime(), nullable=False),
        sa.Column("updated_at", sa.DateTime(), nullable=False),
        sa.Column("deleted_at", sa.DateTime(), nullable=True),
    )


def downgrade():
    bind = op.get_bind()
    op.drop_table("requests")