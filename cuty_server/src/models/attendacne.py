from .base import db, TimestampMixin
from datetime import date

class Attendance(db.Model, TimestampMixin): # 출석체크
    __tablename__ = 'attendances'

    id = db.Column(db.Integer, primary_key=True)

    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)

    check_date = db.Column(db.Date, nullable=False, default=date.today)

    __table_args__ = (
        db.UniqueConstraint('user_id', 'check_date', name='unique_user_daily_attendance'),
    )

    def __repr__(self):
        return f'<Attendance User:{self.user_id} Date:{self.check_date}>'