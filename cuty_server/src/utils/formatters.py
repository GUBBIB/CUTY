from datetime import datetime

def get_country_data(country):
    return {
        'id': country.id,
        'name': country.name,
        'code': country.code,

    }


def get_school_data(school):
    return {
        'id': school.id,
        'name': school.name,
    
    }

def get_college_data(college):
    return {
        'id': college.id,
        'name': college.name,

    }

def get_department_data(department):
    return {
        'id': department.id,
        'name': department.name,

    }

def get_post_data(post, view_count, comment_count, like_count, dislike_count, user_like_status=None, user_dislike_status=None):
    """게시글 데이터를 포맷팅합니다."""
    # 삭제된 게시글인 경우
    if post.deleted_at:
        return {
            'id': post.id,
            'title': None,
            'content': None,
            'category': post.category,
            'user': None,
            'nickname': None,
            'school': {
                'id': post.school.id,
                'name': post.school.name
            },
            'college': {
                'id': post.college.id,
                'name': post.college.name
            },
            'department': {
                'id': post.department.id,
                'name': post.department.name
            },
            'view_count': view_count,
            'comment_count': comment_count,
            'like_count': like_count,
            'dislike_count': dislike_count,
            'user_like_status': user_like_status,
            'user_dislike_status': user_dislike_status,
            'created_at': post.created_at.isoformat(),
            'updated_at': post.updated_at.isoformat(),
            'deleted_at': post.deleted_at.isoformat() if post.deleted_at else None
        }
    
    return {
        'id': post.id,
        'title': post.title,
        'content': post.content,
        'category': post.category,
        'user': get_current_user_data(post.user) if post.user else None,
        'nickname': post.nickname,
        'school': {
            'id': post.school.id,
            'name': post.school.name
        },
        'college': {
            'id': post.college.id,
            'name': post.college.name
        },
        'department': {
            'id': post.department.id,
            'name': post.department.name
        },
        'view_count': view_count,
        'comment_count': comment_count,
        'like_count': like_count,
        'dislike_count': dislike_count,
        'user_like_status': user_like_status,
        'user_dislike_status': user_dislike_status,
        'created_at': post.created_at.isoformat(),
        'updated_at': post.updated_at.isoformat(),
        'deleted_at': None
    }


def get_comment_data(comment, reply_count):
    # 삭제된 댓글인 경우
    if comment.deleted_at:
        return {
            'id': comment.id,
            'content': None,
            'nickname': None,
            'parent_id': comment.parent_id,
            'post_id': comment.post_id,
            'reply_count': reply_count,
            'created_at': comment.created_at.isoformat(),
            'updated_at': comment.updated_at.isoformat(),
            'deleted_at': comment.deleted_at.isoformat() 
        }
    
    return {
        'id': comment.id,
        'content': comment.content,
        'user': get_user_data(comment.user),
        'nickname': comment.nickname,
        'parent_id': comment.parent_id,
        'post_id': comment.post_id,
        'reply_count': reply_count,
        'created_at': comment.created_at.isoformat(),
        'updated_at': comment.updated_at.isoformat(),
        'deleted_at': None
    }

def get_user_data(user):
    if user.is_deleted:
        return {
            'id': user.id,
            'country': None,
            'school': None,
            'college': None,
            'department': None,

            'deleted_at': user.deleted_at.isoformat() if user.deleted_at else None
        }
    
    return {
        'id': user.id,
        'country': {
            'id': user.country.id,
            'name': user.country.name,
            'code': user.country.code
        },
        'school': {
            'id': user.school.id,
            'name': user.school.name
        },
        'college': {
            'id': user.college.id,
            'name': user.college.name
        },
        'department': {
            'id': user.department.id,
            'name': user.department.name
        },
        'deleted_at': user.deleted_at.isoformat() if user.deleted_at else None
    }

def get_current_user_data(user):
    return {
        'id': user.id,
        'email': user.email,
        'name': user.name,
        'country': {
            'id': user.country.id,
            'name': user.country.name,
            'code': user.country.code
        },
        'school': {
            'id': user.school.id,
            'name': user.school.name
        },
        'college': {
            'id': user.college.id,
            'name': user.college.name
        },
        'department': {
            'id': user.department.id,
            'name': user.department.name
        },
        'created_at': user.created_at.isoformat(),
        'updated_at': user.updated_at.isoformat()
    }

def get_presigned_url_data(image_store, presigned_post):
    """
    Presigned URL 결과와 이미지 데이터를 API 응답 형식으로 변환합니다.
    
    Args:
        image_store: 이미지 저장소 모델 객체
        presigned_post: S3 presigned post 객체
        
    Returns:
        dict: 포맷팅된 presigned URL 응답 데이터
    """
    return {
        'image': get_image_store_data(image_store),
        'upload': {
            'url': presigned_post['url'],
            'fields': presigned_post['fields'],
            'key': image_store.relative_path,
            'bucket_name': image_store.bucket_name
        }
    }

def get_image_store_data(image_store):
    """
    이미지 저장소 객체를 API 응답 형식으로 변환합니다.
    
    Args:
        image_store: 이미지 저장소 모델 객체
        
    Returns:
        dict: 포맷팅된 이미지 데이터
    """
    return {
        'id': image_store.id,
        'url': image_store.full_url,
        'content_type': image_store.content_type,
        'original_filename': image_store.original_filename,
        'description': image_store.description if image_store.description else None,
        'created_at': image_store.created_at.isoformat() if image_store.created_at else None,
        'updated_at': image_store.updated_at.isoformat() if image_store.updated_at else None
    }


def get_document_data(document):
    """서류 데이터를 포맷팅합니다."""
    return {
        'id': document.id,
        'name': document.name,
        'document_type': document.document_type.value,
        'user': get_user_data(document.user) if document.user else None,
        'image_store': get_image_store_data(document.image_store) if document.image_store else None,
        'created_at': document.created_at.isoformat(),
        'updated_at': document.updated_at.isoformat()
    }