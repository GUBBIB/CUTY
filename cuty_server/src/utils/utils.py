from datetime import datetime

def get_current_academic_term():
    """
    현재 날짜를 기준으로 (학년도, 학기)를 반환합니다.
    학기 코드: 1=1학기, 2=2학기, 3=여름학기, 4=겨울학기
    """
    now = datetime.now()
    month = now.month
    year = now.year

    # 1월, 2월은 '작년도' 겨울학기로 침
    if month <= 2:
        return year - 1, 4 # 예: 2026년 2월 -> 2025년 겨울학기
    
    # 3월 ~ 6월: 1학기
    elif 3 <= month <= 6:
        return year, 1
    
    # 7월 ~ 8월: 여름학기
    elif 7 <= month <= 8:
        return year, 3
    
    # 9월 ~ 12월: 2학기
    elif 9 <= month <= 12:
        return year, 2
        
    return year, 1 # fallback (혹시 모를 에러 방지)