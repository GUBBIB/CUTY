from flask import Blueprint, request, jsonify
from src.services.point_log_service import PointLogService
from src.utils.auth import token_required

point_log_bp = Blueprint('point_log', __name__)

@point_log_bp.route('/', methods=['GET'])
@token_required
def get_point_logs(current_user):
    """
    내 포인트 내역 조회 (무한 스크롤)
    Parameters:
    - limit: 한 번에 조회할 포인트 내역 수 (기본값: 20)
    - cursor: 마지막으로 조회한 포인트 내역의 ID (선택 사항, 다음 페이지 조회 시 사용)    
    """
    limit = request.args.get('limit', 20, type=int)
    cursor = request.args.get('cursor', type=int)
    
    try:
        point_logs = PointLogService.get_point_logs(current_user, limit, cursor)

        return jsonify(point_logs), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500