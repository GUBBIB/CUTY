from flask import Blueprint, request, jsonify
from src.services.request_service import RequestService
from src.utils.formatters import get_current_user_data
from src.utils.auth import token_required, admin_required
from src.utils.exceptions import ValidationError, PermissionDeniedError, DuplicateRequestError, InternalServiceError


request_bp = Blueprint('request', __name__)

@request_bp.route('/requests', methods=['POST'])
@token_required
def create_requests(current_user):
    """
    신청 요청을 생성합니다.
    
    :param user: 로그인된 사용자 객체
    :param req_type: 요청 타입(예: "PART_TIME" 등 [ 추후 추가 예정 ] )
    :req_type: [ PENDING, REJECTED, APPROVED, CANCELED ]
    :param idempotency_key: 중복 요청 방지를 위한 키(선택)
    :return: dict 응답 데이터
    :raises ValidationError, DuplicateRequestError, InternalServiceError
    """
    data = request.get_json(silent=True) or {}
    req_type = data.get('type')
    
    if not req_type:
        raise ValidationError(message="type 은/는 필수 항목입니다.")


    try:
        result = RequestService.create_request(
            user=current_user,
            req_type=req_type,
            idempotency_key=data.get('idempotencyKey'),
        )
        return jsonify(result), 201

    except ValidationError as e:
        return jsonify(e.to_dict()), 400
    except PermissionDeniedError as e:
        return jsonify(e.to_dict()), 403
    except DuplicateRequestError as e:
        return jsonify(e.to_dict()), 409
    except InternalServiceError as e:
        return jsonify(e.to_dict()), 500
    
@request_bp.route('/requests', methods=['GET'])
@token_required
@admin_required
def list_requests(current_user):
    """
    요청 목록 조회
    :param user: 로그인된 사용자 객체
    :param page: 페이지 번호 (기본 1)
    :param per_page: 페이지당 항목 개수 (기본 10)
    :param status: 요청 상태 필터 (None이면 전체)
    :return: dict 형태로 { items: [...], total:…, page:…, per_page:… }
    """
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    status = request.args.get('status', None)

    result = RequestService.list_requests(
        user=current_user,
        page=page,
        per_page=per_page,
        status=status
    )

    return jsonify(result), 200