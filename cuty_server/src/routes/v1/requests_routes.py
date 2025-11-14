from flask import Blueprint, requests, jsonify
from src.services.requests_service import RequestsService
from src.utils.formatters import get_current_user_data
from src.utils.auth import token_required, admin_or_school_required
from src.utils.exceptions import ValidationError, PermissionDeniedError, DuplicateRequestError, InternalServiceError


requests_bp = Blueprint('requests', __name__)

@requests_bp.route('/', methods=['POST'])
@token_required
def create_requests(current_user):
    """
    신청 요청을 생성합니다.
    
    :param user: 로그인된 사용자 객체
    :param req_type: 요청 타입(예: "PART_TIME" 등 [ 추후 추가 예정 ] )
        :req_type: [ PENDING, REJECTED, APPROVED, CANCELED ]
    :param idempotency_key: 중복 요청 방지를 위한 키(선택)
    :return: dict 응답 데이터
    :raises ValidationError, DuplicateRequestsError, InternalServiceError
    """
    data = requests.get_json(silent=True) or {}
    req_type = data.get('req_type_str')
    
    if not req_type:
        raise ValidationError(message="type 은/는 필수 항목입니다.")

    try:
        result = RequestsService.create_requests(
            user=current_user,
            req_type_str=req_type,
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
    
@requests_bp.route('/', methods=['GET'])
@token_required
@admin_or_school_required
def list_requests(current_user):
    """
    요청 목록 조회
    :param user: 로그인된 사용자 객체
    :param page: 페이지 번호 (기본 1)
    :param per_page: 페이지당 항목 개수 (기본 10)
    :param status: 요청 상태 필터 (None이면 전체)
    :return: dict 형태로 { items: [...], total:…, page:…, per_page:… }
    """
    page = requests.args.get('page', 1, type=int)
    per_page = requests.args.get('per_page', 10, type=int)
    status = requests.args.get('status', None)

    result = RequestsService.list_requests(
        user=current_user,
        page=page,
        per_page=per_page,
        status=status
    )

    return jsonify(result), 200