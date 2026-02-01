from flask import Blueprint
from src.routes.v1.auth_routes import auth_bp
from src.routes.v1.post_routes import post_bp
from src.routes.v1.comment_routes import comment_bp
from src.routes.v1.school_routes import school_bp
from src.routes.v1.user_routes import user_bp
from src.routes.v1.like_routes import like_bp
from src.routes.v1.document_routes import document_bp
from src.routes.v1.image_routes import images_bp
from src.routes.v1.requests_routes import requests_bp
from src.routes.v1.management_routes import management_bp
from src.routes.v1.country_routes import country_bp
from src.routes.v1.attendance_routes import attendance_bp
from src.routes.v1.point_log_routes import point_log_bp
from src.routes.v1.swagger_routes import swagger_bp

def init_routes(app):
    """애플리케이션의 모든 라우트를 등록합니다."""
    
    # API v1 라우트
    
    # 인증 관련 라우트
    app.register_blueprint(auth_bp, url_prefix='/api/v1/auth')
    
    # 학교 관련 라우트
    app.register_blueprint(school_bp, url_prefix='/api/v1/schools')

    # 국가 관련 라우트
    app.register_blueprint(country_bp, url_prefix='/api/v1/countries')
    
    # 게시글 관련 라우트
    app.register_blueprint(post_bp, url_prefix='/api/v1/posts')
    
    # 댓글 관련 라우트
    app.register_blueprint(comment_bp, url_prefix='/api/v1/posts')
    
    # 사용자 관련 라우트
    app.register_blueprint(user_bp, url_prefix='/api/v1/users')
    
    # 좋아요 관련 라우트
    app.register_blueprint(like_bp, url_prefix='/api/v1/posts')
    
    # 서류 관련 라우트
    app.register_blueprint(document_bp, url_prefix='/api/v1/documents')

    # 이미지 관련 라우트
    app.register_blueprint(images_bp, url_prefix='/api/v1/images')

    # 신청 관련 라우트
    app.register_blueprint(requests_bp, url_prefix='/api/v1/requests')

    # ADMIN, SCHOOL의 관리 관련 라우트
    app.register_blueprint(management_bp, url_prefix='/api/v1/managements')

    # 출석 체크 관련 라우트
    app.register_blueprint(attendance_bp, url_prefix='/api/v1/attendances')

    # 포인트 내역 관련 라우트
    app.register_blueprint(point_log_bp, url_prefix='/api/v1/point-logs')

    
    # swagger용 라우트
    app.register_blueprint(swagger_bp, url_prefix='/api/v1/swagger')