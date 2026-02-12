from enum import Enum
from .base import db, TimestampMixin

class DayOfWeek(Enum):
    MON = "MON"
    TUE = "TUE"
    WED = "WED"
    THU = "THU"
    FRI = "FRI"
    SAT = "SAT"
    SUN = "SUN"

    _text_map = {
        "ko": {
            "MON": "월", "TUE": "화", "WED": "수", "THU": "목", 
            "FRI": "금", "SAT": "토", "SUN": "일"
        },
        "en": {
            "MON": "Mon", "TUE": "Tue", "WED": "Wed", "THU": "Thu", 
            "FRI": "Fri", "SAT": "Sat", "SUN": "Sun"
        }
    }

    def get_text(self, lang='ko'):
        lang_map = self._text_map.get(lang, self._text_map['ko'])
        return lang_map[self.value]


class Lecture(db.Model, TimestampMixin):
    __tablename__ = 'lectures'

    id = db.Column(db.Integer, primary_key=True)
    timetable_id = db.Column(db.Integer, db.ForeignKey('timetables.id'), nullable=False)
    
    name_ko = db.Column(db.String(100), nullable=True)
    name_en = db.Column(db.String(100), nullable=True)
    
    professor_ko = db.Column(db.String(50), nullable=True)
    professor_en = db.Column(db.String(50), nullable=True) 
    
    room_ko = db.Column(db.String(50), nullable=True)
    room_en = db.Column(db.String(50), nullable=True)      
    
    memo = db.Column(db.Text, nullable=True)
    color = db.Column(db.String(20), default="#ffffff")

    times = db.relationship('LectureTime', backref='lecture', cascade="all, delete-orphan", lazy='joined')

    def to_dict(self, lang='ko'):
        # 언어 설정에 맞춰 값 선택 (영어가 비어있으면 한국어 보여주기)
        name = (self.name_en if lang == 'en' and self.name_en else self.name_ko) or ""
        professor = (self.professor_en if lang == 'en' and self.professor_en else self.professor_ko) or ""
        room = (self.room_en if lang == 'en' and self.room_en else self.room_ko) or ""

        return {
            "id": self.id,
            "name": name,
            "professor": professor,
            "room": room,
            "memo": self.memo,
            "color": self.color,
            "times": [t.to_dict(lang) for t in self.times]
        }


class LectureTime(db.Model):
    __tablename__ = 'lecture_times'

    id = db.Column(db.Integer, primary_key=True)
    lecture_id = db.Column(db.Integer, db.ForeignKey('lectures.id'), nullable=False)
    
    day = db.Column(db.Enum(DayOfWeek), nullable=False)
    start_period = db.Column(db.Integer, nullable=False) 
    end_period = db.Column(db.Integer, nullable=False)  

    def to_dict(self, lang='ko'):
        return {
            "id": self.id,
            "day": self.day.get_text(lang), 
            "start": self.start_period,
            "end": self.end_period
        }