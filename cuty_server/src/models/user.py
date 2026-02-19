from .base import db, TimestampMixin
from .enums import UserType, SexType

class User(db.Model, TimestampMixin):
    __tablename__ = 'users'
    
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password = db.Column(db.String(255), nullable=False)
    name = db.Column(db.String(100), nullable=False)  # 실명

     # 닉네임
    nickname = db.Column(db.String(50), unique=True, nullable=False)
    is_nickname_anonymous = db.Column(db.Boolean, default=False) # 닉네임 익명 여부
    
    # 성별
    sex = db.Column(db.Enum(SexType), nullable=False) # 성별
    is_sex_anonymous = db.Column(db.Boolean, default=False) # 성별 익명 여부

    # 국가
    country_id = db.Column(db.Integer, db.ForeignKey('countries.id'), nullable=False)
    is_country_anonymous = db.Column(db.Boolean, default=False) # 국가 익명 여부

    # 학교
    school_id = db.Column(db.Integer, db.ForeignKey('schools.id'), nullable=False)
    college_id = db.Column(db.Integer, db.ForeignKey('colleges.id'), nullable=False)
    department_id = db.Column(db.Integer, db.ForeignKey('departments.id'), nullable=False)
    is_school_anonymous = db.Column(db.Boolean, default=False) # 학교 익명 여부

    # User, Admin, School
    register_type = db.Column(db.Enum(UserType), nullable=False, default=UserType.USER)

    point = db.Column(db.Integer, default=0, nullable=False) # 포인트
    profile_image_url = db.Column(db.String(255)) # 프로필 이미지 URL
    is_advertisement_agreed = db.Column(db.Boolean, default=False) # 광고 수신 동의 여부
    level = db.Column(db.Integer, default=1, nullable=False) # 레벨
    current_exp = db.Column(db.Integer, default=0, nullable=False) # 현재 경험치
    current_language = db.Column(db.String(50)) # 현재 언어 (예: 한국어, 영어 등)

    # Relationships
    posts = db.relationship('Post', backref='user', lazy=True)
    post_comments = db.relationship('PostComment', backref='user', lazy=True)
    post_likes = db.relationship('PostLike', backref='user', lazy=True)
    post_views = db.relationship('PostView', backref='user', lazy=True)
    point_logs = db.relationship('PointLog', backref='user', lazy=True)
    attendances = db.relationship('Attendance', backref='user', lazy=True)
    timetables = db.relationship('Timetable', backref='user', lazy=True)
    visas = db.relationship('Visa', backref='user', lazy=True)
    kvtis = db.relationship('Kvti', backref='user', lazy=True)

    @property
    def display_nickname(self):
        return "삭제된 유저" if self.is_deleted else self.nickname

    def __repr__(self):
        return f'<User {self.display_nickname}>'