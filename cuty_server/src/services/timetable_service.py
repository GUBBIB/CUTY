from src.models import db, Timetable, Lecture, LectureTime
from src.utils.exceptions import ValidationError, PermissionDeniedError, InternalServiceError
from src.utils.date_utils import get_current_academic_term
from sqlalchemy import and_

class TimetableService:
    
    @staticmethod
    def get_or_create_main_timetable(user_id, lang='ko'):
        """
        현재 학기의 메인 시간표를 조회하거나 없으면 생성합니다.
        """
        try:
            # 현재 학기 정보 계산
            year, semester = get_current_academic_term()
            
            # 해당 학기의 '대표(Primary)' 시간표 조회
            timetable = Timetable.query.filter_by(
                user_id=user_id,
                year=year,
                semester=semester,
                is_primary=True
            ).first()

            # 대표 시간표가 없다면, 해당 학기의 아무 시간표나 조회
            if not timetable:
                timetable = Timetable.query.filter_by(
                    user_id=user_id,
                    year=year,
                    semester=semester
                ).first()

            # 아예 없다면 -> 자동 생성 (Lazy Creation)
            if not timetable:
                timetable = Timetable(
                    user_id=user_id,
                    year=year,
                    semester=semester,
                    is_primary=True, # 첫 생성이므로 대표로 설정
                    custom_name=None 
                )
                db.session.add(timetable)
                db.session.commit()
            
            return timetable.to_dict(lang)

        except Exception as e:
            db.session.rollback()
            # 이미 처리된 예외가 아니면 InternalServiceError로 감쌈
            if isinstance(e, (ValidationError, PermissionDeniedError)):
                raise e
            raise InternalServiceError(details={"original_error": str(e)})

    @staticmethod
    def get_all_timetables(user_id, year=None, semester=None, lang='ko'):
        """
        사용자의 모든 시간표 목록을 조회합니다.
        """
        query = Timetable.query.filter_by(user_id=user_id)
        
        if year:
            query = query.filter_by(year=year)
        if semester:
            query = query.filter_by(semester=semester)
            
        # 최신 학기 순으로 정렬
        timetables = query.order_by(Timetable.year.desc(), Timetable.semester.desc()).all()
        
        return [t.to_dict(lang) for t in timetables]

    @staticmethod
    def get_timetable_by_id(user_id, timetable_id, lang='ko'):
        """
        특정 시간표의 상세 정보를 조회합니다.
        """
        timetable = Timetable.query.get(timetable_id)
        
        if not timetable:
            raise ValidationError(message="존재하지 않는 시간표입니다.", code="NOT_FOUND")
            
        if timetable.user_id != user_id:
            raise PermissionDeniedError(message="본인의 시간표만 조회할 수 있습니다.")
            
        return timetable.to_dict(lang)

    @staticmethod
    def create_timetable(user_id, data):
        """
        새로운 시간표를 수동으로 생성합니다.
        """
        # 필수 필드 검증
        if 'year' not in data or 'semester' not in data:
            raise ValidationError(message="연도(year)와 학기(semester)는 필수 항목입니다.")

        year = data['year']
        semester = data['semester']
        custom_name = data.get('name')

        try:
            new_timetable = Timetable(
                user_id=user_id,
                year=year,
                semester=semester,
                custom_name=custom_name,
                is_primary=False # 수동 생성 시 기본값은 False (필요시 update로 변경)
            )
            
            db.session.add(new_timetable)
            db.session.commit()
            
            return new_timetable.to_dict()
            
        except Exception as e:
            db.session.rollback()
            raise InternalServiceError(details={"original_error": str(e)})

    @staticmethod
    def update_timetable(user_id, timetable_id, data):
        """
        시간표 정보를 수정합니다 (이름 변경, 대표 시간표 설정).
        """
        timetable = Timetable.query.get(timetable_id)
        
        if not timetable:
            raise ValidationError(message="존재하지 않는 시간표입니다.", code="NOT_FOUND")
            
        if timetable.user_id != user_id:
            raise PermissionDeniedError(message="시간표를 수정할 권한이 없습니다.")

        try:
            # 이름 변경
            if 'name' in data:
                timetable.custom_name = data['name']
            
            # 대표 시간표 설정 로직
            if 'is_primary' in data and data['is_primary'] is True:
                # 기존에 해당 학기의 대표 시간표였던 것들을 모두 해제
                Timetable.query.filter(
                    Timetable.user_id == user_id,
                    Timetable.year == timetable.year,
                    Timetable.semester == timetable.semester,
                    Timetable.is_primary == True,
                    Timetable.id != timetable_id # 자기 자신 제외
                ).update({'is_primary': False})
                
                # 현재 시간표를 대표로 설정
                timetable.is_primary = True
            
            db.session.commit()
            
        except Exception as e:
            db.session.rollback()
            raise InternalServiceError(details={"original_error": str(e)})

    @staticmethod
    def delete_timetable(user_id, timetable_id):
        """
        시간표를 삭제합니다.
        (만약 삭제하는 시간표가 '대표 시간표'라면, 같은 학기의 다른 시간표에게 대표 자격을 넘겨줍니다.)
        """
        timetable = Timetable.query.get(timetable_id)
        
        if not timetable:
            raise ValidationError(message="존재하지 않는 시간표입니다.", code="NOT_FOUND")
            
        if timetable.user_id != user_id:
            raise PermissionDeniedError(message="시간표를 삭제할 권한이 없습니다.")
            
        try:
            # 삭제하려는 게 '대표(primary)' 시간표인지 확인
            if timetable.is_primary:
                # 같은 학년도, 같은 학기의 다른 시간표를 찾음 (자신 제외)
                # 가장 최근에 수정한 시간표를 우선적으로 선택 (updated_at 내림차순)
                successor = Timetable.query.filter(
                    Timetable.user_id == user_id,
                    Timetable.year == timetable.year,
                    Timetable.semester == timetable.semester,
                    Timetable.id != timetable_id  # 나 자신은 제외
                ).order_by(Timetable.updated_at.desc()).first()

                # 대표를 변경할 시간표가 있다면 True로 설정
                if successor:
                    successor.is_primary = True
            
            # 삭제 수행
            db.session.delete(timetable)
            db.session.commit()
            
        except Exception as e:
            db.session.rollback()
            raise InternalServiceError(details={"original_error": str(e)})