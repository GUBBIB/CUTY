# CUTY

## 웹 주소
- [CUTY_WEB](https://cutyweb.duckdns.org)

## 비고
### cuty_app

---

### cuty_server
- src/routes/view_routes.py 빈 파일인데 모르겠어서 놔뒀습니다
- src/services/view_service.py 빈 파일인데 모르겠어서 놔뒀습니다

---

### cuty_web
#### 로그인
- 인증 방식: JWT
- 전달 방식: Authorization 헤더 (Bearer 토큰)
- 토큰 저장 위치: localStorage
- 세션 관리: 서버 비저장(stateless)
