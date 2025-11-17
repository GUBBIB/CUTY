import { useState } from "react";
import { Link } from "react-router-dom";
import { useAuth } from "../../context/useAuth";
import Header from "../Header/Header";

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
      <div className="Header">
        <Header />
      </div>
      <div className="LoginForm">
        <form onSubmit={handleSubmit}>
          <input
            type="text"
            placeholder="이메일"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
          />

          <input
            type="password"
            placeholder="비밀번호"
            value={pw}
            onChange={(e) => setPw(e.target.value)}
          />

          <button type="submit">로그인</button>
          <Link to="/register">회원가입</Link>

          {authError && <p className="err">{authError}</p>}
        </form>
      </div>
    </div>
  );
};

export default Login;
