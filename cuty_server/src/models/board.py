from .base import db, TimestampMixin

class Board(db.Model, TimestampMixin):
    __tablename__ = 'boards'
    
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)  # 게시판 이름
    description = db.Column(db.Text)                   # 게시판 설명
    attribute_schema = db.Column(db.JSON, nullable=True, default={})  # 게시판 속성 스키마 
    # 예: 질문게시판 -> {"is_accepted": "boolean"}
    # 예: 장터게시판 -> {"price": "integer", "is_sold": "boolean"}

    # Relationships
    posts = db.relationship('Post', backref='board', lazy=True)

    def __repr__(self):
        return f'<Board {self.name}>'