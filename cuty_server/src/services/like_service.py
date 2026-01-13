from datetime import datetime
from sqlalchemy import func, case, distinct, and_
from src.models import db, Post, PostLike, PostComment, PostView
from src.utils.formatters import get_post_data

class LikeService:
    @staticmethod
    def _get_post_data(post_id, user_id):
        """게시글 데이터를 조회합니다."""
        
        post = Post.query.get(post_id)
        if not post:
            raise ValueError('존재하지 않는 게시글입니다')
        if post.deleted_at:
            raise ValueError('삭제된 게시글입니다')

        user_status = db.session.query(
            func.max(case((PostLike.type == 'like', 1), else_=0)).label('is_like'),
            func.max(case((PostLike.type == 'dislike', 1), else_=0)).label('is_dislike')
        ).filter(PostLike.post_id == post_id, PostLike.user_id == user_id).first()

        return get_post_data(
            post, 
            post.views_count, 
            post.comments_count, 
            post.likes_count, 
            post.dislikes_count,
            bool(user_status.is_like if user_status else False),
            bool(user_status.is_dislike if user_status else False)
        )

    @staticmethod
    def like_post(user, post_id):
        """게시글에 좋아요를 추가합니다."""
        # 게시글 존재 여부 확인
        post = Post.query.get(post_id)
        if not post:
            raise ValueError('존재하지 않는 게시글입니다')
            
        if post.deleted_at:
            raise ValueError('삭제된 게시글입니다')
            
        # 자신의 학교의 게시글인지 확인
        if user.school_id != post.school_id:
            raise ValueError('자신의 학교의 게시글에만 좋아요를 할 수 있습니다')

        # 기존 좋아요/싫어요 확인
        existing_like = PostLike.query.filter_by(
            user_id=user.id,
            post_id=post_id
        ).first()

        if existing_like:
            if existing_like.type == 'like':
                raise ValueError('이미 좋아요한 게시글입니다')
            # 싫어요를 좋아요로 변경
            existing_like.type = 'like'
            post.dislikes_count -= 1
            post.likes_count += 1
            existing_like.updated_at = datetime.utcnow()
        else:
            # 새로운 좋아요 생성
            new_like = PostLike(
                user_id=user.id,
                post_id=post_id,
                type='like'
            )
            db.session.add(new_like)
            post.likes_count += 1

        post.update_popularity_score()

        try:
            db.session.commit()
            return LikeService._get_post_data(post_id, user.id)
        except Exception as e:
            db.session.rollback()
            raise e

    @staticmethod
    def unlike_post(user, post_id):
        """게시글의 좋아요를 취소합니다."""
        # 게시글 존재 여부 확인
        post = Post.query.get(post_id)
        if not post:
            raise ValueError('존재하지 않는 게시글입니다')
            
        if post.deleted_at:
            raise ValueError('삭제된 게시글입니다')

        # 좋아요 확인
        like = PostLike.query.filter_by(
            user_id=user.id,
            post_id=post_id,
            type='like'
        ).first()

        if not like:
            raise ValueError('좋아요하지 않은 게시글입니다')

        try:
            db.session.delete(like)
            db.session.commit()
            return LikeService._get_post_data(post_id, user.id)
        except Exception as e:
            db.session.rollback()
            raise e

    @staticmethod
    def dislike_post(user, post_id):
        """게시글에 싫어요를 추가합니다."""
        # 게시글 존재 여부 확인
        post = Post.query.get(post_id)
        if not post:
            raise ValueError('존재하지 않는 게시글입니다')
            
        if post.deleted_at:
            raise ValueError('삭제된 게시글입니다')
            
        # 자신의 학교의 게시글인지 확인
        if user.school_id != post.school_id:
            raise ValueError('자신의 학교의 게시글에만 싫어요를 할 수 있습니다')

        # 기존 좋아요/싫어요 확인
        existing_like = PostLike.query.filter_by(
            user_id=user.id,
            post_id=post_id
        ).first()

        if existing_like:
            if existing_like.type == 'dislike':
                raise ValueError('이미 싫어요한 게시글입니다')
            # 좋아요를 싫어요로 변경
            existing_like.type = 'dislike'
            existing_like.updated_at = datetime.utcnow()
        else:
            # 새로운 싫어요 생성
            new_like = PostLike(
                user_id=user.id,
                post_id=post_id,
                type='dislike'
            )
            db.session.add(new_like)

        try:
            db.session.commit()
            return LikeService._get_post_data(post_id, user.id)
        except Exception as e:
            db.session.rollback()
            raise e

    @staticmethod
    def undislike_post(user, post_id):
        """게시글의 싫어요를 취소합니다."""
        # 게시글 존재 여부 확인
        post = Post.query.get(post_id)
        if not post:
            raise ValueError('존재하지 않는 게시글입니다')
            
        if post.deleted_at:
            raise ValueError('삭제된 게시글입니다')

        # 싫어요 확인
        like = PostLike.query.filter_by(
            user_id=user.id,
            post_id=post_id,
            type='dislike'
        ).first()

        if not like:
            raise ValueError('싫어요하지 않은 게시글입니다')

        try:
            db.session.delete(like)
            db.session.commit()
            return LikeService._get_post_data(post_id, user.id)
        except Exception as e:
            db.session.rollback()
            raise e
