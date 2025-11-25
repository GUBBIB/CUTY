from src.models import db, Requests
from src.models.enums import ReqType, ReqState
from sqlalchemy.orm import selectinload
from src.utils.exceptions import ValidationError, DuplicateRequestError, InternalServiceError

class RequestsService:
    @staticmethod
    def create_requests(user, req_type_str, idempotency_key=None):

        if not req_type_str:
            raise ValidationError("요청 타입은 필수 항목입니다.")

        try:
            req_type = ReqType[str(req_type_str).upper()]
        except KeyError:
            raise ValidationError(f"허용되지 않은 요청 타입니다: {req_type_str}")

        if idempotency_key:
            existing = Requests.query.filter_by(user_id=user.id, idempotency_key=idempotency_key).first()

            if existing:
                raise DuplicateRequestError("이미 동일한 요청이 존재합니다.")

        try:
            new_req = Requests(
                user_id = user.id,
                req_type = req_type,
                idempotency_key = idempotency_key,
                status = ReqState.PENDING
            )
            db.session.add(new_req)
            db.session.commit()
        except Exception as e:
            db.session.rollback()
            raise InternalServiceError(details={"original_exception": str(e)})

        return {
            "requestsId": new_req.id,
            "reqType": new_req.req_type.value,
            "status": new_req.status.value if hasattr(new_req.status, "value") else new_req.status,
            "createdAt": new_req.created_at.isoformat()
        }

    @staticmethod
    def list_requests(user, page, per_page, status):

        if page <= 0:
            raise ValidationError(
                message="page 값은 1 이상의 정수여야 합니다.",
                details={"page": page}
            )

        if per_page <= 0:
            raise ValidationError(
                message="per_page 값은 1 이상의 정수여야 합니다.",
                details={"per_page": per_page}
            )

        try:
            query = Requests.query.options(selectinload(Requests.user))
        except Exception as e:
            raise InternalServiceError(
                message="요청 목록 조회 중 쿼리 초기화 오류가 발생했습니다.",
                details={"error": str(e)}
            )

        if status:
            try:
                status_enum = ReqState(status)
            except ValueError:
                raise ValidationError(
                    message=f"유효하지 않은 요청 상태입니다: {status}",
                    details={"allowed": [s.value for s in ReqState]}
                )
            except Exception as e:
                raise InternalServiceError(
                    message="상태 값 처리 중 내부 오류가 발생했습니다.",
                    details={"error": str(e)}
                )

            query = query.filter(Requests.status == status_enum)

        try:
            pagination = query.order_by(
                Requests.created_at.desc()
            ).paginate(page=page, per_page=per_page, error_out=False)

        except SQLAlchemyError as e:
            raise InternalServiceError(
                message="요청 목록 조회 중 DB 오류가 발생했습니다.",
                details={"sqlalchemy_error": str(e)}
            )

        except Exception as e:
            raise InternalServiceError(
                message="요청 목록 페이징 처리 중 내부 오류가 발생했습니다.",
                details={"error": str(e)}
            )

        items = []

        try:
            for req in pagination.items:
                user_data = None
                if req.user:
                    user_data = {
                        "id": req.user.id,
                        "name": req.user.name,
                        "email": req.user.email,
                        "country": req.user.country.name if getattr(req.user, "country", None) else None,
                        "school": req.user.school.name if getattr(req.user, "school", None) else None,
                        "college": req.user.college.name if getattr(req.user, "college", None) else None,
                        "department": req.user.department.name if getattr(req.user, "department", None) else None,
                    }

                items.append({
                    "requestsId": req.id,
                    "reqType": req.req_type.value if hasattr(req.req_type, "value") else req.req_type,
                    "status": req.status.value if hasattr(req.status, "value") else req.status,
                    "createdAt": req.created_at.isoformat() if req.created_at else None,
                    "userId": req.user_id,
                    "userName": req.user.name if req.user else None,
                    "user": user_data,
                })

        except Exception as e:
            raise InternalServiceError(
                message="요청 항목 변환 중 오류가 발생했습니다.",
                details={"error": str(e)}
            )


        return {
            "items": items,
            "total": pagination.total,
            "page": pagination.page,
            "per_page": pagination.per_page,
            "has_next": pagination.has_next,
            "has_prev": pagination.has_prev
        }