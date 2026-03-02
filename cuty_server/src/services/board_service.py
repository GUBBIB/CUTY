from datetime import datetime
from flask import current_app
from sqlalchemy import func, case, distinct, and_, or_
from src.models import (
    db, Board
)
from src.utils.exceptions import InternalServiceError

class BoardService:
    @staticmethod
    def get_board_list():

        try:
            boards = Board.query.all()

            return [
                {
                    "id": board.id,
                    "name": board.name,
                    "description": board.description,
                    "attribute_schema": board.attribute_schema
                }
                for board in boards
            ]

        except Exception as e:
            raise InternalServiceError(
                message="게시판 목록을 불러오는 중 서버 오류가 발생했습니다.",
                details={"error_message": str(e)}
            )

    @staticmethod
    def get_board_detail_with_posts(board_id: int, cursor: int = None, limit: int = 20):
        """
        특정 게시판 정보와 게시글 목록을 커서 기반 무한 스크롤 방식으로 조회합니다.
        """
        board = Board.query.get(board_id)
        if not board:
            raise ValidationError(message="존재하지 않는 게시판입니다.", code="BAD_REQUEST")

        query = Post.query.filter_by(board_id=board.id)
        
        if cursor:
            query = query.filter(Post.id < cursor)
            
        posts = query.order_by(Post.id.desc()).limit(limit + 1).all()

        has_next = len(posts) > limit
        if has_next:
            posts = posts[:-1] 
            next_cursor = posts[-1].id
        else:
            next_cursor = None

        posts_data = []
        for post in posts:
            posts_data.append({
                "id": post.id,
                "title": post.title,
                "preview_content": post.content[:50] + "..." if len(post.content) > 50 else post.content,
                "category": post.category,
                "user_id": post.user_id,
                "views_count": post.views_count,
                "likes_count": post.likes_count,
                "created_at": post.created_at.isoformat() if post.created_at else None,
                "extra_data": post.extra_data
            })

        return {
            "board_info": {
                "id": board.id,
                "name": board.name,
                "description": board.description,
                "attribute_schema": board.attribute_schema
            },
            "posts": {
                "items": posts_data,
                "next_cursor": next_cursor,
                "has_next": has_next
            }
        }