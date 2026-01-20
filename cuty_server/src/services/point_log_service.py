from flask import current_app
from src.models import db, User, PointLog

class PointLogService:
    @staticmethod
    def get_point_logs(user, limit=20, cursor=None):
        """
        내 포인트 내역 조회 (무한 스크롤)
        Parameters:
        - limit: 한 번에 조회할 포인트 내역 수 (기본값: 20)
        - cursor: 마지막으로 조회한 포인트 내역의 ID (선택 사항, 다음 페이지 조회 시 사용)
        """
        query = PointLog.query.filter(PointLog.user_id == user.id)

        if cursor:
            query = query.filter(PointLog.id < cursor)

        point_logs = query.order_by(PointLog.id.desc()).limit(limit).all()

        next_cursor = point_logs[-1].id if point_logs else None
        has_next = len(point_logs) == limit

        return {
            'items': [log.to_dict() for log in point_logs],
            'next_cursor': next_cursor,
            'has_next': has_next
        }


    