from flask import Blueprint, request, jsonify
from src.services.timetable_service import TimetableService
from src.utils.auth import token_required
from src.utils.exceptions import ValidationError, PermissionDeniedError, InternalServiceError, ServiceError
from flasgger import swag_from
from src.utils.swagger_helper import get_swagger_config

timetable_bp = Blueprint('timetable', __name__)

@timetable_bp.route('/main', methods=['GET'])
@token_required
@swag_from(get_swagger_config('docs/v1/timetable/get_main.yml'))
def get_main_timetable(current_user):
    """
    메인 시간표 조회 (없으면 현재 날짜 기준 자동 생성)
    """
    lang = request.args.get('lang', 'ko')
    
    try:
        result = TimetableService.get_or_create_main_timetable(current_user.id, lang)
        return jsonify(result), 200
        
    except Exception as e:
        print(f"get_main_timetable 오류: {str(e)}")
        return jsonify({'error': str(e)}), 500


@timetable_bp.route('/', methods=['GET'])
@token_required
@swag_from(get_swagger_config('docs/v1/timetable/list.yml'))
def get_timetables(current_user):
    """
    내 시간표 목록 조회 (학년도/학기 필터링 가능)
    """
    year = request.args.get('year', type=int)
    semester = request.args.get('semester', type=int)
    lang = request.args.get('lang', 'ko')

    try:
        result = TimetableService.get_all_timetables(current_user.id, year, semester, lang)
        return jsonify(result), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@timetable_bp.route('/<int:timetable_id>', methods=['GET'])
@token_required
@swag_from(get_swagger_config('docs/v1/timetable/get_one.yml'))
def get_timetable_detail(current_user, timetable_id):
    """
    특정 시간표 상세 조회 (강의 목록 포함)
    """
    lang = request.args.get('lang', 'ko')

    try:
        result = TimetableService.get_timetable_by_id(current_user.id, timetable_id, lang)
        return jsonify(result), 200
        
    except ValueError as e: # 존재하지 않거나 권한 없음
        return jsonify({'error': str(e)}), 404
    except PermissionDeniedError as e:
        return jsonify(e.to_dict()), 403
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@timetable_bp.route('/', methods=['POST'])
@token_required
@swag_from(get_swagger_config('docs/v1/timetable/create.yml'))
def create_timetable(current_user):
    """
    시간표 수동 생성
    """
    data = request.get_json()
    
    # 필수 필드 검증
    required_fields = ['year', 'semester']
    for field in required_fields:
        if field not in data:
            return jsonify({'error': f'{field}는 필수 항목입니다'}), 400

    try:
        result = TimetableService.create_timetable(current_user.id, data)
        return jsonify(result), 201
        
    except ValidationError as e:
        return jsonify(e.to_dict()), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@timetable_bp.route('/<int:timetable_id>', methods=['PATCH'])
@token_required
@swag_from(get_swagger_config('docs/v1/timetable/update.yml'))
def update_timetable(current_user, timetable_id):
    """
    시간표 정보 수정 (이름 변경, 대표 시간표 설정 등)
    """
    data = request.get_json()

    try:
        TimetableService.update_timetable(current_user.id, timetable_id, data)
        return '', 204
        
    except ValueError as e:
        return jsonify({'error': str(e)}), 404
    except PermissionDeniedError as e:
        return jsonify(e.to_dict()), 403
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@timetable_bp.route('/<int:timetable_id>', methods=['DELETE'])
@token_required
@swag_from(get_swagger_config('docs/v1/timetable/delete.yml'))
def delete_timetable(current_user, timetable_id):
    """
    시간표 삭제
    """
    try:
        TimetableService.delete_timetable(current_user.id, timetable_id)
        return '', 204
        
    except ValueError as e:
        return jsonify({'error': str(e)}), 404
    except PermissionDeniedError as e:
        return jsonify(e.to_dict()), 403
    except Exception as e:
        return jsonify({'error': str(e)}), 500