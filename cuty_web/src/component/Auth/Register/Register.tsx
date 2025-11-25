import { type FormEvent, useState } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "../../../context/useAuth";
import SearchSelectDialog, {
  type OptionItem,
} from "./Dialog/SearchSelectDialog";
import "./Register.css";

const mockCountries: OptionItem[] = [
  { id: 1, label: "대한민국" },
  { id: 2, label: "일본" },
  { id: 3, label: "미국" },
];

const mockSchools: OptionItem[] = [
  { id: 1, label: "서울대학교" },
  { id: 2, label: "부산대학교" },
  { id: 3, label: "연세대학교" },
];

const mockColleges: OptionItem[] = [
  { id: 1, label: "공과대학" },
  { id: 2, label: "인문대학" },
];

const mockDepartments: OptionItem[] = [
  { id: 1, label: "컴퓨터공학과" },
  { id: 2, label: "전자공학과" },
];

const Register = () => {
  const [email, setEmail] = useState("");
  const [pw, setPw] = useState("");
  const [name, setName] = useState("");

  const [countryId, setCountryId] = useState<number>(1);
  const [countryName, setCountryName] = useState<string | null>("대한민국");

  const [schoolId, setSchoolId] = useState<number>(1);
  const [schoolName, setSchoolName] = useState<string | null>(null);

  const [collegeId, setCollegeId] = useState<number>(1);
  const [collegeName, setCollegeName] = useState<string | null>(null);

  const [departmentId, setDepartmentId] = useState<number>(1);
  const [departmentName, setDepartmentName] = useState<string | null>(null);

  const { Register, authError, authMessage } = useAuth();
  const navigate = useNavigate();

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();

    const ok = await Register({
      email,
      pw,
      name,
      country_id: countryId,
      school_id: schoolId,
      college_id: collegeId,
      department_id: departmentId,
    });

    if (ok) {
      navigate("/login", { replace: true });
    }
  };

  return (
    <div id="Register">
      <form onSubmit={handleSubmit}>
        <div className="field-group">
          <label>이메일</label>
          <input
            type="email"
            placeholder="이메일"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
          />
        </div>

        <div className="field-group">
          <label>비밀번호</label>
          <input
            type="password"
            placeholder="비밀번호"
            value={pw}
            onChange={(e) => setPw(e.target.value)}
          />
        </div>

        <div className="field-group">
          <label>이름</label>
          <input
            type="text"
            placeholder="이름"
            value={name}
            onChange={(e) => setName(e.target.value)}
          />
        </div>
        <SearchSelectDialog
          label="국가"
          valueLabel={countryName}
          options={mockCountries}
          onSelect={(opt) => {
            setCountryId(opt.id);
            setCountryName(opt.label);
          }}
        />

        <SearchSelectDialog
          label="학교"
          valueLabel={schoolName}
          placeholder="학교를 검색해서 선택하세요"
          options={mockSchools}
          onSelect={(opt) => {
            setSchoolId(opt.id);
            setSchoolName(opt.label);
          }}
        />

        <SearchSelectDialog
          label="단과대학"
          valueLabel={collegeName}
          placeholder="단과대를 검색해서 선택하세요"
          options={mockColleges}
          onSelect={(opt) => {
            setCollegeId(opt.id);
            setCollegeName(opt.label);
          }}
        />

        <SearchSelectDialog
          label="학과"
          valueLabel={departmentName}
          placeholder="학과를 검색해서 선택하세요"
          options={mockDepartments}
          onSelect={(opt) => {
            setDepartmentId(opt.id);
            setDepartmentName(opt.label);
          }}
        />

        <button type="submit">회원가입</button>

        {authError && <p className="err">{authError}</p>}
        {authMessage && <p>{authMessage}</p>}
      </form>
    </div>
  );
};

export default Register;
