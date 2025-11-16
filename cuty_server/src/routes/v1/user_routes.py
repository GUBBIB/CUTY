from flask import Blueprint, request, jsonify
from src.services.user_service import UserService
from src.utils.auth import token_required, admin_or_school_required
from src.utils.formatters import get_current_user_data
from src.utils.exceptions import ValidationError, PermissionDeniedError, DuplicateRequestError, InternalServiceError, ServiceError

user_bp = Blueprint('user', __name__)

@user_bp.route('/me', methods=['GET'])
@token_required
def get_current_user(current_user):
    try:
        return jsonify(get_current_user_data(current_user)), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@user_bp.route('/me', methods=['DELETE'])
@token_required
def delete_account(current_user):
    try:
        UserService.delete_account(current_user.id)
        return '', 204
    except ValueError as e:
        return jsonify({'error': str(e)}), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@user_bp.route('/me/password', methods=['PUT'])
@token_required
def change_password(current_user):
    data = request.get_json()
    
    # 필수 필드 확인
    required_fields = ['current_password', 'new_password']
    for field in required_fields:
        if field not in data:
            return jsonify({'error': f'{field}는 필수 항목입니다'}), 400
    
    try:
        UserService.change_password(
            current_user.id,
            data['current_password'],
            data['new_password']
        )
        return '', 204
    except ValueError as e:
        return jsonify({'error': str(e)}), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500



@user_bp.route('/me/posts', methods=['GET'])
@token_required
def get_my_posts(current_user):
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    
    try:
        result = UserService.get_my_posts(current_user.id, page, per_page)
        return jsonify(result), 200
    except ValueError as e:
        return jsonify({'error': str(e)}), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@user_bp.route('/me/comments', methods=['GET'])
@token_required
def get_my_comments(current_user):
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    
    try:
        result = UserService.get_my_comments(current_user.id, page, per_page)
        return jsonify(result), 200
    except ValueError as e:
        return jsonify({'error': str(e)}), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@user_bp.route('/select', methods=['GET'])
@token_required
@admin_or_school_required
def get_select_user(current_user):
    user_email = request.args.get('user_email', type=str)
    if user_email is None:
        err = ValidationError(
            message="user_email 쿼리 파라미터가 필요합니다.",
            code="BAD_REQUEST",
            details={"param": " user_email"},
        )
        return jsonify(err.to_dict()), 400

    try:
        payload = UserService.selectUser(current_user, user_email)
        return jsonify(payload), 200
    
    except ValidationError as e:
        status_code = 404 if e.code == "NOT_FOUND" else 400
        return jsonify(e.to_dict()), status_code
    except PermissionDeniedError as e:
        return jsonify(e.to_dict()), 403
    except ServiceError as e:
        return jsonify(e.to_dict()), 400
    except Exception as e:
        print(f"get_select_user 예상치 못한 오류 발생")
        err = InternalServiceError(
            message="서버 내부 오류가 발생했습니다.",
            details={"error": str(e)},
        )
        return jsonify(err.to_dict()), 500