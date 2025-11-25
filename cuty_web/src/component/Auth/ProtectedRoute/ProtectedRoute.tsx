import { Navigate, Outlet, useLocation } from 'react-router-dom'
import { useAuth } from '../../../context/useAuth'

export default function ProtectedRoute() {
  const { isLogin } = useAuth()
  const location = useLocation()

  // 로그인 안 돼 있으면 /login 으로 보내기 + 원래 가려던 주소 저장
  if (!isLogin) {
    return <Navigate to="/login" replace state={{ from: location }} />
  }

  // 통과
  return <Outlet />
}