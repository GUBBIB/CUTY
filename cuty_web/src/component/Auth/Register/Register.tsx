import { type FormEvent, useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "../../../context/useAuth";
import SearchSelectDialog, {
  type OptionItem,
} from "./Dialog/SearchSelectDialog";
import "./Register.css";
import axios from "axios";

const Register = () => {
  const [email, setEmail] = useState("");
  const [pw, setPw] = useState("");
  const [name, setName] = useState("");

  const [countryId, setCountryId] = useState<number>(1);
  const [countryName, setCountryName] = useState<string | null>(null);
  const [country, setCountry] = useState<OptionItem[] | null>(null);

  const [schoolId, setSchoolId] = useState<number>(1);
  const [schoolName, setSchoolName] = useState<string | null>(null);
  const [school, setSchool] = useState<OptionItem[] | null>(null);

  const [collegeId, setCollegeId] = useState<number>(1);
  const [collegeName, setCollegeName] = useState<string | null>(null);
  const [college, setCollege] = useState<OptionItem[] | null>(null);

  const [departmentId, setDepartmentId] = useState<number>(1);
  const [departmentName, setDepartmentName] = useState<string | null>(null);
  const [department, setDepartment] = useState<OptionItem[] | null>(null);

  const { Register, authError, authMessage } = useAuth();
  const navigate = useNavigate();

  const token = localStorage.getItem("token") || "";

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();

    const ok = await Register({
      email: email,
      password: pw,
      name: name,
      country_id: countryId,
      school_id: schoolId,
      college_id: collegeId,
      department_id: departmentId,
    });

    if (ok) {
      navigate("/login", { replace: true });
    }
  };

  const countryFetch = async () => {
    const res = await axios.get("/api/v1/countries/?page=1&per_page=216", {
      headers: { Authorization: `Bearer ${token}` }
    });

    const data = res.data?.countries ?? [];

    const mapped: OptionItem[] = data.map((c: any) => ({
      id: c.id,
      label: c.name,
      eng_name: c.eng_name ?? null,
    }));

    setCountry(mapped);
  };

  const schoolsFetch = async () => {
    const res = await axios.get("/api/v1/schools", {
      params: { page: 1, per_page: 1600 },
      headers: { Authorization: `Bearer ${token}` }
    });

    const data = res.data?.schools ?? [];

    const mapped: OptionItem[] = data.map((s: any) => ({
      id: s.id,
      label: s.name,
      eng_name: s.eng_name ?? null,
    }));

    setSchool(mapped);
  }

  const collegesFetch = async () => {
    const res = await axios.get(`/api/v1/schools/${schoolId}/colleges`, {
      params: { page: 1, per_page: 1600 },
      headers: { Authorization: `Bearer ${token}` }
    });

    const data = res.data?.colleges ?? [];

    const mapped: OptionItem[] = data.map((c: any) => ({
      id: c.id,
      label: c.name,
      eng_name: c.eng_name ?? null,
    }));

    setCollege(mapped);
  }

  const departmentsFetch = async () => {
    const res = await axios.get(`/api/v1/schools/${schoolId}/colleges/${collegeId}/departments`, {
      params: { page: 1, per_page: 1600 },
      headers: { Authorization: `Bearer ${token}` }
    });

    const data = res.data?.departments ?? [];
    const mapped: OptionItem[] = data.map((d: any) => ({
      id: d.id,
      label: d.name,
      eng_name: d.eng_name ?? null,
    }));
    setDepartment(mapped);
  }

  useEffect(() => {
    countryFetch();
    schoolsFetch();
  }, []);

  useEffect(() => {
    collegesFetch();
  }, [schoolId]);

  useEffect(() => {
    departmentsFetch();
  }, [collegeId]);

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
          options={country || []}
          onSelect={(opt) => {
            setCountryId(opt.id);
            setCountryName(opt.label);
          }}
        />

        <SearchSelectDialog
          label="학교"
          valueLabel={schoolName}
          placeholder="학교를 검색해서 선택하세요"
          options={school || []}
          onSelect={(opt) => {
            setSchoolId(opt.id);
            setSchoolName(opt.label);
          }}
        />

        <SearchSelectDialog
          label="단과대학"
          valueLabel={collegeName}
          placeholder="단과대를 검색해서 선택하세요"
          options={college || []}
          onSelect={(opt) => {
            setCollegeId(opt.id);
            setCollegeName(opt.label);
          }}
        />

        <SearchSelectDialog
          label="학과"
          valueLabel={departmentName}
          placeholder="학과를 검색해서 선택하세요"
          options={department || []}
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
