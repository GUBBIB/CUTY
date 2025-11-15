from sqlalchemy.orm import joinedload, selectinload
from src.models import db, User, Document
from src.models.enums import UserType
from src.utils.exceptions import (
    ValidationError,
    PermissionDeniedError,
)
from src.services.s3_service import generate_presigned_get

class ManagementService:

    @staticmethod
    def get_user_with_documents(current_user, user_id: int) -> dict:
        """
        특정 학생의 전체 정보(유저 + 문서 리스트)를 조회해서
        JSON 응답에 바로 넣을 수 있는 dict 형태로 반환한다.
        """

        user = (
            db.session.query(User)
            .options(
                joinedload(User.country),
                joinedload(User.school),
                joinedload(User.college),
                joinedload(User.department),
                selectinload(User.documents).joinedload(Document.image_store),
            )
            .filter(User.id == user_id)
            .one_or_none()
        )

        if not user:
            raise ValidationError(message="해당 사용자를 찾을 수 없습니다.", code="NOT_FOUND")

        # 학교 담당자 접근 제한 (필요하면 주석 해제)
        # if (
        #     current_user.register_type == UserType.SCHOOL
        #     and current_user.school_id != user.school_id
        # ):
        #     raise PermissionDeniedError(
        #         message="해당 학교 담당자만 접근할 수 있습니다.", code="PERMISSION_DENIED"
        #     )

        # 문서 정보 리스트
        documents_payload = [
            {
                "id": d.id,
                "name": d.name,
                "type": d.document_type.value,
                "image": {
                    "id": d.image_store_id,
                    "url": generate_presigned_get(d.image_store.relative_path) if d.image_store else None, # url 보안 추가
                },
                "created_at": d.created_at.isoformat(),
            }
            for d in user.documents
        ]

        # 최종 payload
        payload = {
            "user": {
                "id": user.id,
                "name": user.name,
                "email": user.email,
                "country": {
                    "id": user.country_id,
                    "name": user.country.name if user.country else None,
                },
                "school": {
                    "id": user.school_id,
                    "name": user.school.name if user.school else None,
                },
                "college": {
                    "id": user.college_id,
                    "name": user.college.name if user.college else None,
                },
                "department": {
                    "id": user.department_id,
                    "name": user.department.name if user.department else None,
                },
            },
            "documents": documents_payload,
        }

        return payload
