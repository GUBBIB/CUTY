import os
from flask import Blueprint, send_from_directory

swagger_bp = Blueprint('swagger', __name__)

@swagger_bp.record
def register_global_routes(state):
    """
    Blueprint가 app에 등록될 때 실행됩니다.
    app.register_blueprint 시 설정된 url_prefix('/api/v1/swagger')의 영향을 받지 않고,
    강제로 루트 경로('/docs/v1/models/...')에 라우트를 꽂아버립니다.
    """
    app = state.app
    # 브라우저가 요청하는 주소 그대로 등록
    app.add_url_rule(
        '/docs/v1/models/<path:filename>', 
        view_func=serve_yaml_models_global
    )

def serve_yaml_models_global(filename):
    """
    실제 파일을 찾아서 보내주는 함수
    """
    root_dir = os.getcwd() # 현재 작업 경로 (Zappa에서는 /var/task)
    
    # Zappa 배포 환경을 고려해 여러 경로 탐색
    possible_paths = [
        os.path.join(root_dir, 'docs', 'v1', 'models'),       # 기본
        os.path.join(root_dir, 'src', 'docs', 'v1', 'models') # src 구조
    ]
    
    found_dir = None
    
    # 파일이 있는 폴더 찾기
    for path in possible_paths:
        if os.path.exists(path):
            found_dir = path
            break
    
    # 폴더가 있다면 파일 전송
    if found_dir:
        # 디버깅용 로그 (CloudWatch에서 확인 가능)
        print(f"[DEBUG] Serving {filename} from {found_dir}")
        return send_from_directory(found_dir, filename)
    else:
        # 폴더를 못 찾았을 때
        print(f"[FATAL ERROR] Cannot find 'docs/v1/models' in {root_dir}")
        print(f"[DEBUG] Current Dir List: {os.listdir(root_dir)}")
        return "Models directory not found on server", 404

from flasgger import swag_from
from src.utils.swagger_helper import get_swagger_config

@swagger_bp.route('/__models', methods=['GET'])
@swag_from(get_swagger_config('docs/v1/_models.yml'))
def swagger_models():
    pass