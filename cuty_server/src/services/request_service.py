from src.models import db, Request
from src.models.enums import ReqType, ReqState
from src.utils.exceptions import ValidationError, DuplicateRequestError, InternalServiceError

class RequestService:
    @staticmethod
    def create_request(user, req_type_str, idempotency_key=None):

        if not req_type_str:
            raise ValidationError("요청 타입은 필수 항목입니다.")

        try:
            req_type = ReqType[str(req_type_str).upper()]
        except KeyError:
            raise ValidationError(f"허용되지 않은 요청 타입니다: {req_type_str}")

        if idempotency_key:
            existing = Request.query.filter_by(user_id=user.id, idempotency_key=idempotency_key).first()

            if existing:
                raise DuplicateRequestError("이미 동일한 요청이 존재합니다.")

        try:
            new_req = Request(
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
            "requestId": new_req.id,
            "reqType": new_req.req_type.value,
            "status": new_req.status.value if hasattr(new_req.status, "value") else new_req.status,
            "createdAt": new_req.created_at.isoformat()
        }

    @staticmethod
    def list_requests(user, page, per_page, status):
        query = Request.query.filter_by(user_id=user.id)

        if status is not None:
            query = query.filter(Request.status == status)

        pagination = query.order_by(Request.created_at.desc()).paginate(page=page, per_page=per_page, error_out=False)

        items = [{
            "requestId" : req.id,
            "reqType" : req.req_type.value if hasattr(req.req_type, "value") else req.req_type,
            "status" : req.status.value if hasattr(req.status, "value") else req.status,
            "createdAt" : req.created_at.isoformat()
        } for req in pagination.items]

        return {
            "items": items,
            "total": pagination.total,
            "page": pagination.page,
            "per_page": pagination.per_page,
            "has_next": pagination.has_next,
            "has_prev": pagination.has_prev
        }