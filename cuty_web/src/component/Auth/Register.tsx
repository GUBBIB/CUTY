import { useState } from "react";
import { useAuth } from "../../context/useAuth";

const Register = () => {

  const [email, setEmail] = useState("");
  const [pw, setPw] = useState("");
  const [name, setName] = useState("");
  const { Register, authError, authMessage } = useAuth();


  const handleSubmit = async (e: React.FormEvent) => { // 회원가입시 {나라, 학교, 단과대, 학과} 아이디는 임시로 고정
    e.preventDefault();
    Register({
      email,
      pw,
      name,
      country_id: 1,
      school_id: 1,
      college_id: 1,
      department_id: 1,
    })
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
        <input
          type="text"
          placeholder="이름"
          value={name}
          onChange={(e) => setName(e.target.value)}
        />
        <button type="submit">회원가입</button>

        {authError && <p className="err">{authError}</p>}
        {authMessage && <p>{authMessage}</p>}
      </form>
    </div>
  );
};

export default Register;
