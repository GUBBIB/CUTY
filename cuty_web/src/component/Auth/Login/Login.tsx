import { type FormEvent, useState } from "react";
import { Link, useLocation, useNavigate } from "react-router-dom";
import { useAuth } from "../../../context/useAuth";
import "./Login.css";

const Login = () => {
  const [email, setEmail] = useState("");
  const [pw, setPw] = useState("");

  const { Login, authError } = useAuth();
  const location = useLocation();
  const navigate = useNavigate();

  const from = (location.state as any)?.from?.pathname || "/dashboard";

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();

    const ok = await Login({ email, pw });

    if (ok) {
      navigate(from, { replace: true });
    }
  };

  return (
    <div id="Login">
      <div className="login-section">
        <div className="header-section">
          <div className="title">
            CUTY
          </div>
          <div className="description">
            관리 시스템에 로그인하세요
          </div>
        </div>

        <div className="login-form">
          <form onSubmit={handleSubmit}>
            <div className="email">
              <label htmlFor="email-input">이메일</label>
              <input
                id="email-input"
                type="text"
                placeholder="이메일"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
              />
            </div>

            <div className="password">
              <label htmlFor="password-input">비밀번호</label>
              <input
                id="password-input"
                type="password"
                placeholder="비밀번호"
                value={pw}
                onChange={(e) => setPw(e.target.value)}
              />
            </div>

            <button className="login-btn" type="submit">
              로그인
            </button>

            <div>
              <Link to="/register">
                회원가입
              </Link>
            </div>
          </form>
        </div>

        {authError && <p className="err">{authError}</p>}
      </div>
    </div>
  );
};

export default Login;
