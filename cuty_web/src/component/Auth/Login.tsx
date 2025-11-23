import { useState } from "react";
import { Link } from "react-router-dom";
import { useAuth } from "../../context/useAuth";
import "./Auth.css";

const Login = () => {

  const [email, setEmail] = useState("");
  const [pw, setPw] = useState("");
  const { Login, authError, authMessage } = useAuth();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    Login({
      email,
      pw
    });
    console.log("authMessage:", authMessage);
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
