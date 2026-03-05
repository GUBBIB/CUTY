from datetime import datetime
from flask import current_app
from sqlalchemy import func, case, distinct, and_, or_
from src.models import (
    db, Post, PostComment, PostLike, PostView,
    School, College, Department, User
)
from src.utils.formatters import (
    get_post_data, get_school_data, get_college_data, 
    get_department_data, get_post_list_data
)
from src.services.nickname_service import NicknameService

class PostService:
    @staticmethod
    def get_post(board_id, post_id, user_id=None, ip_address=None):
        """특정 게시글을 조회합니다."""
        post_query = db.session.query(
            Post,
            func.count(distinct(PostView.id)).label('view_count'),
            func.count(distinct(case(
                (PostComment.parent_id == None, PostComment.id)
            ))).label('comment_count'),
            func.count(distinct(case((PostLike.type == 'like', PostLike.id)))).label('like_count'),
            func.count(distinct(case((PostLike.type == 'dislike', PostLike.id)))).label('dislike_count'),
            func.count(distinct(case(
                (and_(PostLike.type == 'like', PostLike.user_id == user_id), PostLike.id)
            ))).label('user_like_status'),
            func.count(distinct(case(
                (and_(PostLike.type == 'dislike', PostLike.user_id == user_id), PostLike.id)
            ))).label('user_dislike_status')
        ).outerjoin(PostView, Post.id == PostView.post_id)\
        .outerjoin(PostComment, Post.id == PostComment.post_id)\
        .outerjoin(PostLike, Post.id == PostLike.post_id)\
        .filter(Post.id == post_id)\
        .group_by(Post.id)\
        .first()

        if not post_query:
            raise ValueError('존재하지 않는 게시글입니다')

        post, view_count, comment_count, like_count, dislike_count, user_like_status, user_dislike_status = post_query

        if post.deleted_at:
            raise ValueError('삭제된 게시글입니다')

        # 조회수 증가 로직
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
            db.session.commit()
            view_count += 1

        return get_post_data(
            post, 
            view_count, 
            comment_count, 
            like_count, 
            dislike_count,
            bool(user_like_status),
            bool(user_dislike_status)
        )

    @staticmethod
    def create_post(user, title, content, category):
        """새 게시글을 생성합니다."""
        # 랜덤 닉네임 생성
        anonymous_nickname = NicknameService.create_unique_nickname()
        if not anonymous_nickname:
            raise ValueError('닉네임을 생성할 수 없습니다')

        new_post = Post(
            title=title,
            content=content,
            category=category,
            user_id=user.id,
            nickname=anonymous_nickname,
            school_id=user.school_id,
            college_id=user.college_id,
            department_id=user.department_id
        )

        try:
            db.session.add(new_post)
            db.session.commit()
            return get_post_data(new_post, 0, 0, 0, 0, False, False)
        except Exception as e:
            db.session.rollback()
            raise e

    @staticmethod
    def update_post(post_id, user, data):
        """게시글을 수정합니다."""
        post = Post.query.get(post_id)

        if not post:
            raise ValueError('존재하지 않는 게시글입니다')

        if post.deleted_at:
            raise ValueError('삭제된 게시글입니다')

        if post.user_id != user.id:
            raise ValueError('게시글을 수정할 권한이 없습니다')

        # 수정 가능한 필드 확인
        updatable_fields = ['title', 'content', 'category']
        for field in updatable_fields:
            if field in data:
                setattr(post, field, data[field])

        try:
            db.session.commit()

            post_data = db.session.query(
                Post,
                func.count(distinct(PostView.id)).label('view_count'),
                func.count(distinct(case(
                    (PostComment.parent_id == None, PostComment.id)
                ))).label('comment_count'),
                func.count(distinct(case((PostLike.type == 'like', PostLike.id)))).label('like_count'),
                func.count(distinct(case((PostLike.type == 'dislike', PostLike.id)))).label('dislike_count'),
                func.count(distinct(case(
                    (and_(PostLike.type == 'like', PostLike.user_id == user.id), PostLike.id)
                ))).label('user_like_status'),
                func.count(distinct(case(
                    (and_(PostLike.type == 'dislike', PostLike.user_id == user.id), PostLike.id)
                ))).label('user_dislike_status')
            ).outerjoin(PostView, Post.id == PostView.post_id)\
            .outerjoin(PostComment, Post.id == PostComment.post_id)\
            .outerjoin(PostLike, Post.id == PostLike.post_id)\
            .filter(Post.id == post_id)\
            .group_by(Post.id)\
            .first()

            post, view_count, comment_count, like_count, dislike_count, user_like_status, user_dislike_status = post_data
            return get_post_data(
                post, 
                view_count, 
                comment_count, 
                like_count, 
                dislike_count,
                bool(user_like_status),
                bool(user_dislike_status)
            )

        except Exception as e:
            db.session.rollback()
            raise e

    @staticmethod
    def delete_post(post_id, user):
        """게시글을 삭제합니다."""
        post = Post.query.get(post_id)

        if not post:
            raise ValueError('존재하지 않는 게시글입니다')

        if post.deleted_at:
            raise ValueError('이미 삭제된 게시글입니다')

        if post.user_id != user.id:
            raise ValueError('게시글을 삭제할 권한이 없습니다')

        try:
            post.deleted_at = datetime.utcnow()
            db.session.commit()
        except Exception as e:
            db.session.rollback()
            raise e

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