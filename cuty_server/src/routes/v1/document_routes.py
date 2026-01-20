from flask import Blueprint, request, jsonify
from src.services.document_service import DocumentService
from src.utils.auth import token_required, admin_or_school_required
from flask import send_file

document_bp = Blueprint('document', __name__)

@document_bp.route('', methods=['GET'])
@token_required
def get_documents(current_user):
    """사용자의 서류 목록을 조회합니다."""
    try:
        page = request.args.get('page', 1, type=int)
        per_page = min(request.args.get('per_page', 10, type=int), 100)  # 최대 100개로 제한
        document_type = request.args.get('type')  # 서류 타입 필터
        
        result = DocumentService.get_documents(
            user_id=current_user.id,
            page=page,
            per_page=per_page,
            document_type=document_type
        )
        
        return jsonify({
            'success': True,
            'data': result
        }), 200
        
    except ValueError as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 400
    except Exception as e:
        return jsonify({
            'success': False,
            'error': '서류 목록을 가져오는 중 오류가 발생했습니다'
        }), 500

@document_bp.route('/<int:document_id>', methods=['GET'])
@token_required
def get_document(current_user, document_id):
    """서류 상세 정보를 조회합니다."""
    try:
        document = DocumentService.get_document_by_id(
            document_id=document_id,
            user_id=current_user.id
        )
        
        return jsonify({
            'success': True,
            'data': document
        }), 200
        
    except ValueError as e:
        error_message = str(e)
        # 삭제된 서류/이미지인 경우 410 Gone, 그 외에는 404 Not Found
        if "삭제된" in error_message:
            return jsonify({
                'success': False,
                'error': error_message
            }), 410
        else:
            return jsonify({
                'success': False,
                'error': error_message
            }), 404
    except Exception as e:
        return jsonify({
            'success': False,
            'error': '서류를 가져오는 중 오류가 발생했습니다'
        }), 500

@document_bp.route('', methods=['POST'])
@token_required
def create_document(current_user):
    """새로운 서류를 생성합니다."""
    try:
        data = request.get_json()
        
        if not data:
            return jsonify({
                'success': False,
                'error': '요청 데이터가 필요합니다'
            }), 400
        
        name = data.get('name')
        document_type = data.get('document_type')
        image_store_id = data.get('image_store_id')
        
        if not document_type:
            return jsonify({
                'success': False,
                'error': '서류 타입이 필요합니다'
            }), 400
        
        if not image_store_id:
            return jsonify({
                'success': False,
                'error': '이미지 ID가 필요합니다'
            }), 400
        
        document = DocumentService.create_document(
            user_id=current_user.id,
            name=name,
            document_type=document_type,
            image_store_id=image_store_id
        )
        
        return jsonify({
            'success': True,
            'data': document
        }), 201
        
    except ValueError as e:
        error_message = str(e)
        # 삭제된 이미지인 경우 410 Gone, 그 외에는 400 Bad Request
        if "삭제된" in error_message:
            return jsonify({
                'success': False,
                'error': error_message
            }), 410
        else:
            return jsonify({
                'success': False,
                'error': error_message
            }), 400
    except Exception as e:
        return jsonify({
            'success': False,
            'error': '서류 생성 중 오류가 발생했습니다'
        }), 500

@document_bp.route('/<int:document_id>', methods=['PUT'])
@token_required
def update_document(current_user, document_id):
    """서류 정보를 업데이트합니다."""
    try:
        data = request.get_json()
        
        if not data:
            return jsonify({
                'success': False,
                'error': '요청 데이터가 필요합니다'
            }), 400
        
        name = data.get('name')
        document_type = data.get('document_type')
        image_store_id = data.get('image_store_id')
        
        if not name and not document_type and not image_store_id:
            return jsonify({
                'success': False,
                'error': '업데이트할 데이터가 필요합니다'
            }), 400
        
        document = DocumentService.update_document(
            document_id=document_id,
            user_id=current_user.id,
            name=name,
            document_type=document_type,
            image_store_id=image_store_id
        )
        
        return jsonify({
            'success': True,
            'data': document
        }), 200
        
    except ValueError as e:
        error_message = str(e)
        # 삭제된 서류/이미지인 경우 410 Gone, 그 외에는 400 Bad Request
        if "삭제된" in error_message:
            return jsonify({
                'success': False,
                'error': error_message
            }), 410
        else:
            return jsonify({
                'success': False,
                'error': error_message
            }), 400
    except Exception as e:
        return jsonify({
            'success': False,
            'error': '서류 업데이트 중 오류가 발생했습니다'
        }), 500

@document_bp.route('/<int:document_id>', methods=['DELETE'])
@token_required
def delete_document(current_user, document_id):
    """서류를 삭제합니다."""
    try:
        DocumentService.delete_document(
            document_id=document_id,
            user_id=current_user.id
        )
        
        return jsonify({
            'success': True,
            'message': '서류가 성공적으로 삭제되었습니다'
        }), 200
        
    except ValueError as e:
        error_message = str(e)
        # 삭제된 서류인 경우 410 Gone, 그 외에는 404 Not Found
        if "삭제된" in error_message:
            return jsonify({
                'success': False,
                'error': error_message
            }), 410
        else:
            return jsonify({
                'success': False,
                'error': error_message
            }), 404
    except Exception as e:
        return jsonify({
            'success': False,
            'error': '서류 삭제 중 오류가 발생했습니다'
        }), 500

@document_bp.route('/bulk-delete', methods=['DELETE'])
@token_required
def delete_multiple_documents(current_user):
    """여러 서류를 한 번에 삭제합니다."""
    try:
        data = request.get_json()
        
        if not data:
            return jsonify({
                'success': False,
                'error': '요청 데이터가 필요합니다'
            }), 400
        
        document_ids = data.get('document_ids')
        
        if not document_ids:
            return jsonify({
                'success': False,
                'error': '삭제할 서류 ID 목록이 필요합니다'
            }), 400
        
        if not isinstance(document_ids, list):
            return jsonify({
                'success': False,
                'error': '서류 ID 목록은 배열 형태여야 합니다'
            }), 400
        
        # 모든 ID가 정수인지 확인
        try:
            document_ids = [int(doc_id) for doc_id in document_ids]
        except (ValueError, TypeError):
            return jsonify({
                'success': False,
                'error': '유효하지 않은 서류 ID가 포함되어 있습니다'
            }), 400
        
        result = DocumentService.delete_multiple_documents(
            document_ids=document_ids,
            user_id=current_user.id
        )
        
        # 응답 메시지 구성
        message = f"{result['deleted_count']}개의 서류가 성공적으로 삭제되었습니다"
        
        if result.get('not_found_count', 0) > 0:
            message += f" ({result['not_found_count']}개는 찾을 수 없거나 이미 삭제된 서류입니다)"
        
        return jsonify({
            'success': True,
            'message': message,
            'data': result
        }), 200
        
    except ValueError as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 400
    except Exception as e:
        return jsonify({
            'success': False,
            'error': '서류 삭제 중 오류가 발생했습니다'
        }), 500

@document_bp.route('/types', methods=['GET'])
@token_required
def get_document_types(current_user):
    """사용 가능한 서류 타입 목록을 조회합니다."""
    try:
        document_types = DocumentService.get_document_types()
        
        return jsonify({
            'success': True,
            'data': document_types
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'error': '서류 타입을 가져오는 중 오류가 발생했습니다'
        }), 500

@document_bp.route('/requests/<int:user_id>/merged-document', methods=['GET'])
@token_required
@admin_or_school_required
def get_studnet_merged_document(current_user, user_id):
    """
    특정 유저의 모든 PDF/이미지 서류를 하나로 합쳐서 반환    
    """
    try:
        pdf_stream = DocumentService.get_merged_pdf(user_id)

        return send_file(
            pdf_stream,
            mimetype='application/pdf',
            as_attachment=False,
            download_name=f'student_{user_id}_documents.pdf'
        )

    except Exception as e:
        return jsonify({"error": str(e)}), 500
