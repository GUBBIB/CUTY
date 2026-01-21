from flask import Blueprint, request, jsonify
from src.services.attendance_service import AttendanceService
from src.utils.auth import token_required
from datetime import date
from flasgger import swag_from
from src.utils.swagger_helper import get_swagger_config  

attendance_bp = Blueprint('attendance', __name__)

@attendance_bp.route('/', methods=['POST'])
@token_required
@swag_from(get_swagger_config('docs/v1/attendance/check.yml'))  
def check_attendance(current_user):
    """
    출석 체크 및 포인트 적립

    201: 출석 체크 성공
    400: 이미 출석 체크한 경우 또는 잘못된 요청 // 광고 보기로 변경 필요
    500: 서버 에러
    """
    try:
        result = AttendanceService.check_attendance(current_user)

        return jsonify(result), 201

    except ValueError as e:
        return jsonify({'error': str(e)}), 400

    except Exception as e:
        return jsonify({'error': str(e)}), 500

@attendance_bp.route('/me', methods=['GET'])
@token_required
@swag_from(get_swagger_config('docs/v1/attendance/me.yml'))  
def get_my_attendance(current_user):
    """
    내 출석 기록 조회
    Parameters:

    """
    try:
        today = date.today()
        year = request.args.get('year', today.year, type=int)
        month = request.args.get('month', today.month, type=int)

        result = AttendanceService.get_monthly_attendance(current_user, year, month)

        return jsonify(result), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500