from flask import Blueprint, request, jsonify
from src.services.request_service import RequestService
from src.utils.auth import token_required, admin_or_school_required
from src.utils.exceptions import ValidationError, PermissionDeniedError, DuplicateRequestError, InternalServiceError
from src.models.enums import UserType
from sqlalchemy.orm import joinedload, selectinload

management_bp = Blueprint('management', __name__)

@management_bp.route('/<int:user_id>', methods=['GET'])
@token_required
@admin_or_school_required
def show_user(current_user, user_id):
    """
    특정 학생의 전체 정보(유저 정보 + 문서 전체) 조회
    """
    user = (
        db.session.query(User)
        .options(
            joinedload(User.country),      # user.country 미리 조인
            joinedload(User.school),       # user.school 미리 조인
            joinedload(User.college),
            joinedload(User.department),
            selectinload(User.documents)   # user.documents는 IN 쿼리로 프리패치
                .joinedload(Document.image_store)  # 문서의 이미지까지
        )
        .filter(User.id == user_id)
        .one_or_none()
    )

    if not user:
        raise ValidationError(message="해당 사용자를 찾을 수 없습니다.", code="NOT_FOUND")
    
    # 추후 주석 제거할 부분
    # if current_user.register_type == UserType.SCHOOL and current_user.school_id != user.school_id:
    #     raise PermissionDeniedError(message="해당 학교 담당자만 접근할 수 있습니다.")

    documents = [{
        "id": d.id,
        "name": d.name,
        "document_type": d.document_type.name,
        "image_store_id": d.image_store_id,
        "previewable": True,
    } for d in user.documents]

    payload = {
        "user": {
            "id": user.id,
            "name": useru.name,
            "email": user.email,
            "country": {"id": user.country_id, "name": user.country.name},
            "school": {"id": user.school_id, "name": user.school.name},
            "college": {"id": user.college_id, "name": user.college.name},
            "department": {"id": user.department_id, "name": user.department.name},
        },
        "documents": [
            {
                "id": d.id,
                "name": d.name,
                "type": d.document_type.value,
                "image": {
                    "id": d.image_store_id,
                    # 필요하면 URL 같은 필드도
                },
                "created_at": d.created_at.isoformat(),
            }
            for d in u.documents
        ],
    }

    return jsonify(payload), 200