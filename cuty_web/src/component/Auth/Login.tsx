import { useState } from "react";
import axios from "axios";
import { useNavigate, Link } from "react-router-dom";

const Login = () => {
  const navigate = useNavigate();

  const [email, setEmail] = useState("");
  const [pw, setPw] = useState("");
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);

    try {
      const res = await axios.post("/api/v1/auth/login", {
        email: email,
        password: pw,
      });

      const token = res.data.access_token;
      localStorage.setItem("accessToken", token);

      navigate("/"); // 로그인 성공 시 메인으로 이동
    } catch (err: any) {
      setError("로그인 실패");
    }
  };

  return (
    <div id="Login">
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

        {error && <p style={{ color: "red" }}>{error}</p>}
      </form>
    </div>
  );
};

export default Login;
