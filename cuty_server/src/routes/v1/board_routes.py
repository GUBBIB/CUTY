from flask import Blueprint, current_app, request, jsonify
from src.services.board_service import BoardService
from src.utils.auth import token_required
import jwt
from flasgger import swag_from
from src.utils.swagger_helper import get_swagger_config
from src.utils.exceptions import ServiceError

board_bp = Blueprint('board', __name__)

@board_bp.route('/', methods=['GET'])
@swag_from(get_swagger_config('docs/v1/board/list.yml'))
def get_boards():
    """
    게시판 목록 조회
    """
    boards_data = BoardService.get_board_list()

    return jsonify({
        "status": success",
        "data" : boards_data
    }), 200

@board_bp.route('/<int:board_id>', methods=['GET'])
@swag_from(get_swagger_config('docs/v1/board/detail.yml'))
def get_board_detail(board_id):
    """
    게시판 상세 및 게시글 목록 조회 (모바일 무한 스크롤)
    """
    cursor = request.args.get('cursor', type=int)
    limit = request.args.get('limit', 20, type=int)

    board_detail_data = BoardService.get_board_detail_with_posts(board_id, cursor, limit)

    return jsonify({
        "status": "success",
        "data": board_detail_data
    }), 200