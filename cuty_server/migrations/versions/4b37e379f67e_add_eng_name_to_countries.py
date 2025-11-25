"""add eng_name to countries

Revision ID: 4b37e379f67e
Revises: bf9059d9c3b3
Create Date: 2025-11-25 21:38:12.463128

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '4b37e379f67e'
down_revision = 'bf9059d9c3b3'
branch_labels = None
depends_on = None

def upgrade():
    with op.batch_alter_table('countries', schema=None) as batch_op:
        batch_op.add_column(
            sa.Column('eng_name', sa.String(length=100), nullable=True)
        )

    op.execute("""
        UPDATE countries
        SET eng_name = name
        WHERE eng_name IS NULL;
    """)

    with op.batch_alter_table('countries', schema=None) as batch_op:
        batch_op.alter_column(
            'eng_name',
            existing_type=sa.String(length=100),
            nullable=False
        )

    with op.batch_alter_table('schools', schema=None) as batch_op:
        batch_op.drop_constraint('schools_country_id_fkey', type_='foreignkey')
        batch_op.drop_column('country_id')


def downgrade():
    with op.batch_alter_table('schools', schema=None) as batch_op:
        batch_op.add_column(
            sa.Column('country_id', sa.INTEGER(), autoincrement=False, nullable=False)
        )
        batch_op.create_foreign_key(
            'schools_country_id_fkey', 'countries', ['country_id'], ['id']
        )

    with op.batch_alter_table('countries', schema=None) as batch_op:
        batch_op.drop_column('eng_name')