import { useEffect, useState } from "react";
import Header from "../../Header/Header";
import axios from "axios";
import { Link } from "react-router-dom";
import "./Requests.css";
import { useAuth } from "../../../context/useAuth";

interface RequestUser {
  id: number;
  name: string | null;
  email: string | null;
  country: string | null;
  school: string | null;
  college: string | null;
  department: string | null;
}

interface RequestItem {
  requestsId: number;
  reqType: string;
  status: string;
  createdAt: string | null;
  userId: number;
  userName: string | null;
  user?: RequestUser | null;
}


const Requests = () => {
  const [reqList, setReqList] = useState<RequestItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const { userType, isLogin } = useAuth();

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

  const isAdminOrSchool = isLogin && userType === "ADMIN" || userType === "SCHOOL";

  const hasData = !loading && !error && reqList.length > 0;

  return (
    <div id="Requests">
      <div className="Header">
        <Header />
      </div>
      <div className="container">
        {isAdminOrSchool ? (
          <div className="admin-school-section">
            <div style={{ padding: "20px" }}>
              <h2>📄 신청 목록</h2>

              {loading && <p>불러오는 중...</p>}

              {!loading && !error && reqList.length === 0 && (
                <p>신청자가 없습니다.</p>
              )}

              {hasData && (
                <ul className="request-list">
                  {reqList.map((req, idx) => {
                    const name = req.user?.name ?? "이름 없음";

                    const formatDate = (date: string | null) => {
                      if (!date) return "날짜 없음";
                      return new Date(date).toLocaleDateString("ko-KR");
                    };

                    const statusLabel = (() => {
                      if (req.status === "APPROVED") return "승인";
                      if (req.status === "PENDING") return "대기";
                      return req.status;
                    })();

                    const statusClass = (() => {
                      if (req.status === "APPROVED") return "status-approved";
                      if (req.status === "PENDING") return "status-pending";
                      return "status-etc";
                    })();

                    return (
                      <li key={req.requestsId ?? idx} className="request-item">
                        <Link to={`/user-info/${req.user?.id}`} className="request-card">
                          <div className="request-main">
                            <div className="request-left">
                              <div className="request-name">{name}</div>
                              <div className="request-sub">
                                학과: {req.user?.department ?? "없음"}
                              </div>
                            </div>

                            <div className="request-right">
                              <div className="request-info">
                                이메일: {req.user?.email}
                              </div>
                              <div className="request-info">
                                신청일: {formatDate(req.createdAt)}
                              </div>
                            </div>
                          </div>

                          <div className={`status-badge ${statusClass}`}>
                            {statusLabel}
                          </div>
                        </Link>
                      </li>
                    );
                  })}
                </ul>
              )}

            </div>
          </div>
        ) : (
          <div className="no-permission">
            <p>이 페이지는 관리자/학교 권한만 접근 가능합니다.</p>
          </div>
        )}

      </div>
    </div>
  );
};

export default Requests;
