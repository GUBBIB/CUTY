from .base import db, TimestampMixin

class PointLog(db.Model, TimestampMixin): # 포인트 내역
    __tablename__ = 'point_logs'

    id = db.Column(db.Integer, primary_key=True)

    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)

    amount = db.Column(db.Integer, nullable=False) 
    description = db.Column(db.String(255), nullable=False)

    def __repr__(self):
        return f'<PointLog User:{self.user_id} {self.amount:+d} ({self.description})>'

    def to_dict(self):
        return {
            'id': self.id,
            'user_id': self.user_id,
            'amount': self.amount,
            'description': self.description,
            'created_at': self.created_at.isoformat()
        }