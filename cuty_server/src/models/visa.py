from .base import db, TimestampMixin

class Visa(db.Model, TimestampMixin):
    __tablename__ = 'visas'
    
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    visa_type = db.Column(db.String(50), nullable=False)  # 비자 종류 (예: D-2, D-10 등)
    issue_date = db.Column(db.Date, nullable=False)       # 발급일
    expiry_date = db.Column(db.Date, nullable=False)      # 만료일
    document_url = db.Column(db.String(255))              # 비자 관련 서류 URL
    score = db.Column(db.Integer, nullable=True)              # 비자 점수

    # Relationships
    user = db.relationship('User', backref='visas')

    def __repr__(self):
        return f'<Visa {self.visa_type} for User {self.user_id}>'