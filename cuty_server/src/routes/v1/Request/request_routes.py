from flask import Blueprint, request, jsonify
from src.services.request_service import RequestService
from src.utils.formatters import get_current_user_data
from src.utils.auth import token_required
from src.utils.exceptions import ValidationError, PermissionDeniedError, DuplicateRequestError, InternalServiceError


request_bp = Blueprint('request', __name__)

@request_bp.route('/requests', methods=['POST'])
@token_required
def create_request(current_user):
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
    