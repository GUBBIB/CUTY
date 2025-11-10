# 예외 처리 코드 모듈

class ServiceError(Exception):
    """
    서비스 계층에서 발생하는 예외의 기본 클래스입니다.
    
    :param message: 사용자나 클라이언트에게 전달할 간단하고 이해 가능한 설명입니다.
    :param code: 응답용 오류 코드입니다. 예) 'BAD_REQUEST', 'FORBIDDEN', 'DUPLICATE', 'INTERNAL' 등
    :param details: 내부 로깅 또는 디버깅을 위한 추가 정보입니다. (예: 내부 예외 메시지, 스택트레이스 요약 등)
    """
    def __init__(self, message: str = None, code: str = None, details: dict = None):
        super().__init__(message)
        self.message = message or "서비스 내부 오류가 발생했습니다."
        self.code = code or "SERVICE_ERROR"
        self.details = details or {}
    
    def to_dict(self):
        """
        클라이언트에 반환할 JSON 응답용 딕셔너리로 변환합니다.
        반환 형식:
        {
          "code": <오류코드>,
          "message": <사용자용 메시지>,
          "details": <내부용 추가 정보>  ※ 개발/디버깅 시 유용하며, 운영 환경에서는 최소화할 수 있습니다
        }
        """
        response = {
            "code": self.code,
            "message": self.message,
        }
        # details가 비어 있지 않으면 포함
        if self.details:
            response["details"] = self.details
        return response

class ValidationError(ServiceError):
    """입력값이 잘못된 경우 발생하는 예외입니다."""
    def __init__(self, message="입력 값이 유효하지 않습니다.", code="BAD_REQUEST", details=None):
        super().__init__(message=message, code=code, details=details)

class PermissionDeniedError(ServiceError):
    """권한이 없는 경우 발생하는 예외입니다."""
    def __init__(self, message="권한이 없습니다.", code="FORBIDDEN", details=None):
        super().__init__(message=message, code=code, details=details)

class DuplicateRequestError(ServiceError):
    """중복 요청이 존재하는 경우 발생하는 예외입니다."""
    def __init__(self, message="중복된 요청입니다.", code="DUPLICATE", details=None):
        super().__init__(message=message, code=code, details=details)

class InternalServiceError(ServiceError):
    """서버 내부 오류가 발생한 경우 사용되는 예외입니다."""
    def __init__(self, message="서버 내부 오류가 발생했습니다.", code="INTERNAL", details=None):
        super().__init__(message=message, code=code, details=details)
