import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App'
import { BrowserRouter, Route, Routes } from 'react-router-dom'
import Privacy from './component/Privacy/Privacy'
import Register from './component/Auth/Register/Register'
import Login from './component/Auth/Login/Login'
import UserInfo from './component/Students/UserInfo/UserInfo'
import { AuthProvider } from './context/AuthContext'
import Error from './component/Error/Error'
import ProtectedRoute from './component/Auth/ProtectedRoute/ProtectedRoute'
import Dashboard from './component/DashBoard/Dashboard'
import Select from './component/Students/SelectSection/Search'
import AdminSchoolProtectRoute from './component/Auth/ProtectedRoute/AdminSchoolProtectRoute'
import PartTimeManagement from './component/PartTimeManagement/PartTimeManagement'
import Documents from './component/Documents/Documents'


createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <BrowserRouter>
      <AuthProvider>
        <Routes>
          <Route path="/" element={<App />} />


          <Route element={<ProtectedRoute />}>
            <Route element={<AdminSchoolProtectRoute />} >
              {/* 관리자 페이지 */}
              <Route path="/dashboard" element={<Dashboard />} />
              <Route path="/part-time-management" element={<PartTimeManagement />} />
              <Route path='/search-student' element={<Select />} />

              <Route path="/documents/:userId" element={<Documents />} />

              {/* 유저 상세 정보 */}
              <Route path="/user-info/:userId" element={<UserInfo />} />
            </Route>
          </Route>



          {/* Auth 관련 페이지 */}
          <Route path="/login" element={<Login />} />
          <Route path="/register" element={<Register />} />

          {/* 정책 페이지 */}
          <Route path="/privacy-policy" element={<Privacy />} />
          
          {/* 미할당 에러 페이지 */}
          <Route path="/no-permission" element={<Error message='접근 권한이 없습니다.' />} />
          <Route path='*' element={<Error />} />
        </Routes>
      </AuthProvider>
    </BrowserRouter>
  </StrictMode >,
)
