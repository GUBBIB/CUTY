from .base import db, TimestampMixin
from datetime import datetime
import math

class Post(db.Model, TimestampMixin):
    __tablename__ = 'posts'
    
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(200), nullable=False)
    content = db.Column(db.Text, nullable=False)
    category = db.Column(db.String(50), nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    school_id = db.Column(db.Integer, db.ForeignKey('schools.id'), nullable=False)
    college_id = db.Column(db.Integer, db.ForeignKey('colleges.id'), nullable=False)
    department_id = db.Column(db.Integer, db.ForeignKey('departments.id'), nullable=False)

    extra_data = db.Column(MutableDict.as_mutable(db.JSON), nullable=True, default={})  # 게시판별 추가 속성 저장용

    likes_count = db.Column(db.Integer, default=0, nullable=False)
    dislikes_count = db.Column(db.Integer, default=0, nullable=False)
    views_count = db.Column(db.Integer, default=0, nullable=False)
    popularity_score = db.Column(db.Float, default=0.0, nullable=True)

    # Relationships
    post_comments = db.relationship('PostComment', backref='post', lazy=True)
    post_likes = db.relationship('PostLike', backref='post', lazy=True)
    views = db.relationship('PostView', backref='post', lazy=True)

    def __repr__(self):
        return f'<Post {self.title}>'

    def update_popularity_score(self):
        """시간 감쇠 알고리즘 적용"""
        # 가중치 설정
        # 좋아요 = 10점, 실헝요 = 5점, 조회수 = 0.1점
        points = (self.likes_count * 10) - (self.dislikes_count * 5) + (self.views_count * 0.1)

        # 시간 계산
        delta = datetime.utcnow() - self.created_at
        hours_since_created = delta.total_seconds() / 3600

        # 시간 감쇠 공식: Score = P / (T + 2)^G
        # P: Points     T: Time     G: Gravity
        gravity = 1.8
        self.popularity_score = points / math.pow((hours_since_created + 2), gravity)

        return self.popularity_score