import { useState } from "react";
import axios from "axios";
import { useNavigate } from "react-router-dom";

const Register = () => {
  const navigate = useNavigate();

  const [email, setEmail] = useState("");
  const [pw, setPw] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setSuccess(null);
//['email', 'password', 'name', 'country_id']
//['school_id', 'college_id', 'department_id']

    try {
      const res = await axios.post("/api/v1/auth/register", {
        email: email,
        password: pw,
      });

      const token = res.data.access_token;
      localStorage.setItem("accessToken", token);

      setSuccess("회원가입 성공! 로그인 페이지로 이동합니다.");
      navigate("/");
    } catch (err: any) {
      setError("회원가입 실패");
    }
  };

  return (
    <div id="Register">
      <form onSubmit={handleSubmit}>
        <input
          type="email"
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

        <button type="submit">회원가입</button>

        {error && <p style={{ color: "red" }}>{error}</p>}
        {success && <p>{success}</p>}
      </form>
    </div>
  );
};

export default Register;
