import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App'
import Rquests from './component/PdfRelation/Requests'
import { BrowserRouter, Route, Routes } from 'react-router-dom'
import Privacy from './component/Privacy/Privacy'
import Register from './component/Auth/Register'
import Login from './component/Auth/Login'
import UserInfo from './component/PdfRelation/UserInfo'
import { AuthProvider } from './context/AuthContext'
import Error from './component/Error'


createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <BrowserRouter>
      <AuthProvider>
        <Routes>
          <Route path="/" element={<App />} />

          {/* 관리자 페이지 */}
          <Route path="/student-pdf" element={<Rquests />} />

          {/* Auth 관련 페이지 */}
          <Route path="/login" element={<Login />} />
          <Route path="/register" element={<Register />} />

          {/* 유저 상세 정보 */}
          <Route path="/user-info/:userId" element={<UserInfo />} />

          {/* 정책 페이지 */}
          <Route path="/privacy-policy" element={<Privacy />} />
          {/* 미할당 에러 페이지 */}
          <Route path='*' element={<Error />} />
        </Routes>
      </AuthProvider>
    </BrowserRouter>
  </StrictMode>,
)
