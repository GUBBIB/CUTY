from flask import current_app
from src.models import Attendance, PointLog, User, db
from datetime import date
from sqlalchemy.exc import IntegrityError
from sqlalchemy import extract

class AttendanceService:

    @staticmethod
    def random_point_allocation():
        """
        출석 체크 시 랜덤 포인트 적립
        """
        import random
        min_points = current_app.config.get('ATTENDANCE_MIN_POINTS', 10)
        max_points = current_app.config.get('ATTENDANCE_MAX_POINTS', 100)
        return random.randint(min_points, max_points)

    @staticmethod
    def check_attendance(user):
        """
        출석 체크 및 포인트 적립
        """
        today = date.today()
        try:
            new_attendance = Attendance(
                user_id=user.id,
                check_date=today
            )
            db.session.add(new_attendance)

            point = AttendanceService.random_point_allocation()
            user.point += point

            new_log = PointLog(
                user_id=user.id,
                amount=point,
                description='출석 체크 포인트 적립'
            )

            db.session.add(new_log)
            db.session.commit()

            return {
                'message': '출석 체크 완료',
                'gained_point': point,
                'total_points': user.point
            }

        except IntegrityError as e:
            db.session.rollback()
            raise ValueError('이미 오늘 출석 체크를 하셨습니다.') from e
        except Exception as e:
            db.session.rollback()
            raise e

    @staticmethod
    def get_monthly_attendance(user, year, month):
        """
        특정 년/월의 출석 기록 조회
        """
        attendance = Attendance.query.filter(
            Attendance.user_id == user.id,
            extract('year', Attendance.check_date) == year,
            extract('month', Attendance.check_date) == month
        ).all()

        return {
            'year': year,
            'month': month,
            'count': len(attendance),
            'dates': [att.check_date.isoformat() for att in attendance]
        }