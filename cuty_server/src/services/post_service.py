from datetime import datetime
from flask import current_app
from sqlalchemy import func, case, distinct, and_, or_
from src.models import (
    db, Post, PostComment, PostLike, PostView, User, Board
)
from src.utils.formatters import (
    get_post_data, get_school_data, get_college_data, 
    get_department_data, get_post_list_data
)
from src.services.nickname_service import NicknameService
from src.utils.exceptions import ValidationError, InternalServiceError, PermissionDeniedError

class PostService:
    @staticmethod
    def get_post(board_id, post_id, user_id=None, ip_address=None):
        """특정 게시판의 게시글을 상세 조회합니다."""

        post = Post.query.filter_by(id=post_id, board_id=board_id).first()

        if not post:
            raise ValidationError(message="존재하지 않거나 해당 게시판에 속하지 않은 게시글입니다.", code="BAD_REQUEST")
        
        if getattr(post, 'deleted_at', None):
            raise ValidationError(message="삭제된 게시글입니다.", code="BAD_REQUEST")

        user_like_status = False
        user_dislike_status = False
        
        if user_id:
            user_reaction = PostLike.query.filter_by(post_id=post.id, user_id=user_id).first()
            if user_reaction:
                user_like_status = (user_reaction.type == 'like')
                user_dislike_status = (user_reaction.type == 'dislike')

        existing_view = PostView.query.filter(
            PostView.post_id == post_id,
            or_(
                and_(PostView.user_id == user_id, PostView.user_id != None),
                and_(PostView.ip_address == ip_address, PostView.user_id == None)
            )
        ).first()

        if not existing_view:
            new_view = PostView(
                post_id=post_id,
                user_id=user_id,
                ip_address=ip_address if not user_id else None
            )
            db.session.add(new_view)
            post.view_count += 1
            post.update_popularity_score()
            db.session.commit()

        return {
            "id": post.id,
            "board_id": post.board_id,
            "title": post.title,
            "content": post.content,
            "category": post.category,
            "author_id": post.user_id,
            
            "views_count": post.views_count,
            "likes_count": post.likes_count,
            "dislikes_count": post.dislikes_count,
            "comments_count": len(post.post_comments), 
            
            "user_like_status": user_like_status,
            "user_dislike_status": user_dislike_status,
            
            "extra_data": post.extra_data,
            
            "created_at": post.created_at.isoformat() if post.created_at else None,
            "popularity_score": post.popularity_score
        }

    @staticmethod
    def create_post(board_id, user, data):
        """새 게시글을 생성합니다."""
        title = data.get('title')
        content = data.get('content')
        category = data.get('category')

        if not all([title, content, category]):
            raise ValidationError(message="제목, 내용, 카테고리는 필수 항목입니다.")
        
        board = Board.query.get(board_id)
        if not board:
            raise ValidationError(message="존재하지 않는 게시판입니다.")

        extra_data = data.get('extra_data', {})
        schema = board.attribute_schema or {}

        for key, expected_type in schema.items():
            if key not in extra_data:
                raise ValidationError(message=f"'{key}' 속성이 누락되었습니다.")

            value = extra_data[key]
            
            if expected_type == 'integer' and not isinstance(value, int):
                raise ValidationError(message=f"'{key}'는 숫자(정수) 형태여야 합니다.")
            elif expected_type == 'boolean' and not isinstance(value, bool):
                raise ValidationError(message=f"'{key}'는 true/false 형태여야 합니다.")
            elif expected_type == 'string' and not isinstance(value, str):
                raise ValidationError(message=f"'{key}'는 문자열 형태여야 합니다.")

        new_post = Post(
            board_id=board.id,
            title=title,
            content=content,
            category=category,
            user_id=user.id,
            school_id=user.school_id,
            college_id=user.college_id,
            department_id=user.department_id,
            extra_data=extra_data,  
            nickname = NicknameService.create_unique_nickname() if user.is_nickname_anonymous else user.nickname
        )

        try:
            db.session.add(new_post)
            db.session.commit()

            return {
            "post_id": new_post.id,
            "message": "게시글이 성공적으로 작성되었습니다."
            }
        except Exception as e:
            db.session.rollback()
            # DB 에러 등 내부 서버 오류 처리
            raise InternalServiceError(
                message="게시글 저장 중 오류가 발생했습니다.", 
                details={"error": str(e)}
            )


    @staticmethod
    def update_post(board_id, post_id, user, data):        
        """게시글을 수정합니다."""
        post = Post.query.filter_by(id=post_id, board_id=board_id).first()

        if not post:
            raise ValidationError(message="존재하지 않거나 해당 게시판에 속하지 않은 게시글입니다.")

        if getattr(post, 'deleted_at', None):
            raise ValidationError(message="삭제된 게시글입니다.")

        if post.user_id != user.id:
            raise PermissionDeniedError(message="게시글을 수정할 권한이 없습니다.")

        if 'extra_data' in data:
            raise PermissionDeniedError(message="게시글의 특수 속성은 직접 수정할 수 없습니다.")

        # 수정 가능한 필드 확인
        updatable_fields = ['title', 'content', 'category']
        for field in updatable_fields:
            if field in data:
                setattr(post, field, data[field])

        try:
            db.session.commit()

            return {
                "post_id": post.id,
                "message": "게시글이 성공적으로 수정되었습니다.",
                "updated_fields": {
                    "title": post.title,
                    "content": post.content,
                    "category": post.category,
                    "extra_data": post.extra_data
                }
            }

        except Exception as e:
            db.session.rollback()
            raise InternalServiceError(
                message="게시글 수정 중 오류가 발생했습니다.", 
                details={"error": str(e)}
            )

    @staticmethod
    def delete_post(post_id, user):
        """게시글을 삭제합니다."""
        
        post = Post.query.filter_by(id=post_id, board_id=board_id).first()

        if not post:
            raise ValidationError(message="존재하지 않거나 해당 게시판에 속하지 않은 게시글입니다.")

        if getattr(post, 'deleted_at', None):
            raise ValidationError(message="이미 삭제된 게시글입니다.")

        if post.user_id != user.id:
            raise PermissionDeniedError(message="게시글을 삭제할 권한이 없습니다.")

        try:
            post.deleted_at = datetime.now(timezone.utc)
            db.session.commit()
            
        except Exception as e:
            db.session.rollback()
            raise InternalServiceError(
                message="게시글 삭제 중 오류가 발생했습니다.", 
                details={"error": str(e)}
            )
            
    @staticmethod
    def get_popular_posts(category=None, limit=5):
        """
        인기 점수(popularity_score) 순으로 게시글 목록을 가져옵니다.
        """
        query = Post.query.filter(Post.deleted_at == None)

        if category:
            query = query.filter(Post.category == category)

        popular_posts = query.order_by(
            Post.popularity_score.desc(), 
            Post.created_at.desc()
        ).limit(limit).all()

        return [get_post_list_data(post) for post in popular_posts]