from .base import db, TimestampMixin

# kvti 검사 결과 모델
class Kvti(db.Model, TimestampMixin):
    __tablename__ = 'kvtis'
    
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    

    # Relationships
    user = db.relationship('User', backref='kvtis')