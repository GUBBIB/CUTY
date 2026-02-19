import os
from flask import Blueprint, request, jsonify

from src.services.image_service import ImageService
from src.utils.auth import token_required
from flasgger import swag_from
from src.utils.swagger_helper import get_swagger_config

from src.config.env import ALLOWED_EXTENSIONS

images_bp = Blueprint('images', __name__, url_prefix='/images')

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@images_bp.route("/presigned-url", methods=['POST'])
@token_required
@swag_from(get_swagger_config('docs/v1/image/presigned_url.yml'))
def get_presigned_url(current_user):
    """
    이미지 업로드를 위한 presigned URL을 생성합니다.
    클라이언트는 이 URL을 사용하여 S3에 직접 업로드해야 합니다.
    """
    try:
        data = request.get_json()
        content_type = data.get('content_type')
        file_size = data.get('file_size', 0)
        original_filename = data.get('filename', '')
        
        if not content_type:
            return jsonify({"detail": "Content type is required"}), 400
            
        if not allowed_file(original_filename):
            return jsonify({"detail": "File type not allowed"}), 400
            
        result, error = ImageService.get_presigned_url(
            content_type=content_type,
            original_filename=original_filename,
            file_size=file_size
        )
        
        if error:
            return jsonify({"detail": error}), 400
            
        return jsonify(result)
        
    except Exception as e:
        print(f"Error in get_presigned_url route: {str(e)}")
        return jsonify({"detail": "Failed to process upload request"}), 500