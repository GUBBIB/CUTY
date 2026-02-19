import os

def get_swagger_config(relative_path):
    """
    프로젝트 루트를 기준으로 절대 경로를 생성합니다.
    """
    base_dir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    
    full_path = os.path.join(base_dir, relative_path)
        
    return full_path