import { useEffect, useState } from "react";
import Header from "../Header/Header";
import axios from "axios";
import { Link } from "react-router-dom";
import "Requests.css";


interface RequestItem {
  requestsId: number;
  reqType: string;
  status: string;
  createdAt: string;
  userId: number;
  userName: string;
}

const Pdf = () => {
  const [reqList, setReqList] = useState<RequestItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchPdfList = async () => {
      try {
        const token = localStorage.getItem("accessToken");

        const res = await axios.get(`/api/v1/requests/`, {
          headers: token ?
            { Authorization: `Bearer ${token}` }
            : undefined,
        });

        /*
          items = [{
            "requestsId" : req.id,
            "reqType" : req.req_type.value if hasattr(req.req_type, "value") else req.req_type,
            "status" : req.status.value if hasattr(req.status, "value") else req.status,
            "createdAt" : req.created_at.isoformat(),
            "userId" : req.user_id,
            "userName" : req.user.name,
          } for req in pagination.items]
        */
        setReqList(res.data.items);
      } catch (err: any) {
        if (axios.isAxiosError(err)) {
          const data = err.response?.data;

          let msg = "PDF 목록 불러오기 실패";

          if (data) {
            if (typeof data === "string") {
              msg = data;
            } else if (typeof data === "object" && "error" in data) {
              // { error: "토큰이 필요합니다" } 같은 형태
              msg = (data as any).error ?? msg;
            }
          } else if (err.message) {
            msg = err.message;
          }

          setError(msg);
        } else {
          setError("알 수 없는 오류가 발생했습니다.");
        }
      } finally {
        setLoading(false);
      }
    };
    fetchPdfList();
  }, []);


  return (
    <div id="Requests">
      <div className="Header">
        <Header />
      </div>

      <div style={{ padding: "20px" }}>
        <h2>📄 신청 목록</h2>

        {loading && <p>불러오는 중...</p>}
        {error && <p className="err">오류: {error}</p>}

        {!loading && !error && reqList.length === 0 && (
          <p>신청자가 없습니다.</p>
        )}

        {!loading && !error && reqList.length > 0 && (
          <ul>
            {reqList.map((req) => (
              <li key={req.requestsId}>
                <Link to={`/user-info/${req.userId}`}>
                  {req.userName}님의 신청서 보기
                </Link>
              </li>
            ))}
          </ul>
        )}
      </div>
    </div>
  );
};

export default Pdf;
