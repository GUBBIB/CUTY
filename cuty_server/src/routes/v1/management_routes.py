from flask import Blueprint, request, jsonify
from src.services.management_service import ManagementService
from src.utils.auth import token_required, admin_or_school_required
from src.utils.exceptions import ValidationError, PermissionDeniedError, DuplicateRequestError, InternalServiceError
from src.models.enums import UserType
from sqlalchemy.orm import joinedload, selectinload
from flasgger import swag_from
from src.utils.swagger_helper import get_swagger_config

management_bp = Blueprint('management', __name__)

@management_bp.route('/user/<int:user_id>', methods=['GET'])
@token_required
@admin_or_school_required
@swag_from(get_swagger_config('docs/v1/management/user_detail.yml'))
def show_user(current_user, user_id):
    """
    특정 학생의 전체 정보(유저 정보 + 문서 전체) 조회
    """
    payload = ManagementService.get_user_with_documents(current_user, user_id)

    return jsonify(payload), 200