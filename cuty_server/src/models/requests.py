from .base import db, TimestampMixin
from .enums import ReqType, ReqState

class Requests(db.Model, TimestampMixin):
    __tablename__ = 'requests'
    
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    req_type = db.Column(db.Enum(ReqType), nullable=False)
    idempotency_key = db.Column(db.String(100), nullable=True, unique=True)
    status = db.Column(db.Enum(ReqState), nullable=True, default=ReqState.PENDING)

    # Relationships
    user = db.relationship('User', backref='requests', lazy=True)

    def __repr__(self):
        return f'<Requests {self.req_type} by user {self.user_id} status {self.status}>'
