from .base import db, TimestampMixin

class Timetable(db.Model, TimestampMixin):
    __tablename__ = 'timetables'

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    
    # 사용자가 직접 지은 이름 (없을 수 있음)
    custom_name = db.Column(db.String(50), nullable=True) 
    
    year = db.Column(db.Integer, nullable=False)     # 2026
    semester = db.Column(db.Integer, nullable=False) # 1, 2, 3(여름), 4(겨울)

    is_primary = db.Column(db.Boolean, default=False, nullable=False)

    lectures = db.relationship('Lecture', backref='timetable', cascade="all, delete-orphan")

    def get_display_name(self, lang='ko'):
        """
        사용자가 이름을 따로 안 지었으면, 학기 정보를 바탕으로 자동 생성
        lang: 'ko' or 'en'
        """
        if self.custom_name:
            return self.custom_name

        # 언어별 템플릿
        if lang == 'en':
            sem_map = {1: "1st Semester", 2: "2nd Semester", 3: "Summer Session", 4: "Winter Session"}
            base_name = f"{self.year} {sem_map.get(self.semester, 'Term')}"
        else:
            sem_map = {1: "1학기", 2: "2학기", 3: "여름학기", 4: "겨울학기"}
            base_name = f"{self.year}년 {sem_map.get(self.semester, '학기')}"
            
        return base_name

    # API 응답용 딕셔너리 만들기
    def to_dict(self, lang='ko'):
        return {
            "id": self.id,
            "year": self.year,
            "semester": self.semester,
            "name": self.get_display_name(lang),
            "is_primary": self.is_primary, # 대표 시간표 여부 알려줌
            
            "lectures": [l.to_dict(lang) for l in self.lectures] 
        }