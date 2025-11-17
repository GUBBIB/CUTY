import { useEffect, useState } from "react";
import Header from "../Header/Header";
import axios from "axios";
import { Link } from "react-router-dom";
import "./Requests.css";
import Select from "./SelectSection/Select";
import { useAuth } from "../../context/useAuth";

interface RequestItem {
  requestsId: number;
  reqType: string;
  status: string;
  createdAt: string | null;
  userId: number;
  userName: string | null;
}

const Requests = () => {
  const [reqList, setReqList] = useState<RequestItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const { userType } = useAuth();

  const fetchReqList = async () => {
    try {
      const token = localStorage.getItem("accessToken");

      const res = await axios.get(`/api/v1/requests/`, {
        headers: token
          ? { Authorization: `Bearer ${token}` }
          : undefined,
      });

      console.log("GET /api/v1/requests response:", res.data);

      const items = Array.isArray(res.data?.items) ? res.data.items : [];
      setReqList(items);
      setError("");
    } catch (err: any) {
      console.error("GET /api/v1/requests error:", err);

      setError("알 수 없는 오류가 발생했습니다.");
    } finally {
      setLoading(false);
    };
  }

  useEffect(() => {
    fetchReqList();
  }, []);

  const isAdminOrSchool = userType === "ADMIN" || userType === "SCHOOL";

  const hasData = !loading && !error && reqList.length > 0;

  return (
    <div id="Requests">
      <div className="Header">
        <Header />
      </div>

      {isAdminOrSchool ? (
        <div className="admin-school-section">
          <div style={{ padding: "20px" }}>
            <h2>📄 신청 목록</h2>

            {loading && <p>불러오는 중...</p>}

            {!loading && !error && reqList.length === 0 && (
              <p>신청자가 없습니다.</p>
            )}

            {hasData && (
              <ul>
                {reqList.map((req, idx) => (
                  <li key={req.requestsId ?? idx}>
                    <Link to={`/user-info/${req.userId}`}>
                      {(req.userName ?? "이름 없음")}님의 신청서 보기
                    </Link>
                  </li>
                ))}
              </ul>
            )}
          </div>

          <div className="select-section">
            <Select />
          </div>
        </div>
      ) : (
        <div className="no-permission">
          <p>이 페이지는 관리자/학교 권한만 접근 가능합니다.</p>
        </div>
      )}

    </div>
  );
};

export default Requests;
