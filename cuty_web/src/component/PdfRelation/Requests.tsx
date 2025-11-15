import { useEffect, useState } from "react";
import Header from "../Header/Header";
import axios from "axios";
import { Link } from "react-router-dom";
import "./Requests.css";

interface RequestItem {
  requestsId: number;
  reqType: string;
  status: string;
  createdAt: string;
  userId: number;
  userName: string;
}

const Requests = () => {
  const [reqList, setReqList] = useState<RequestItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchReqList = async () => {
      try {
        const token = localStorage.getItem("accessToken");

        const res = await axios.get(`/api/v1/requests/`, {
          headers: token
            ? { Authorization: `Bearer ${token}` }
            : undefined,
        });

        console.log("GET /api/v1/requests response:", res.data);

        // 방어적으로 items 파싱
        const rawItems: any[] = Array.isArray(res.data?.items)
          ? res.data.items
          : [];

        const mapped: RequestItem[] = rawItems.map((item) => ({
          requestsId: Number(item.requestsId),
          reqType: String(item.reqType ?? ""),
          status: String(item.status ?? ""),
          createdAt: String(item.createdAt ?? ""),
          userId: Number(item.userId),
          // userName이 객체여도 문자열로 강제
          userName:
            typeof item.userName === "string"
              ? item.userName
              : String(item.userName?.message ?? "이름 없음"),
        }));

        setReqList(mapped);
        setError(null);
      } catch (err: any) {
        console.error("GET /api/v1/requests error:", err);

        if (axios.isAxiosError(err)) {
          const data = err.response?.data;

          let msg: unknown = "신청 목록 불러오기 실패";

          if (data) {
            if (typeof data === "string") {
              msg = data;
            } else if (typeof data === "object") {
              if ("error" in data) {
                // { error: "토큰이 필요합니다" }
                msg = (data as any).error ?? msg;
              } else if ("message" in data) {
                // { message: "..." }
                msg = (data as any).message ?? msg;
              }
            }
          } else if (err.message) {
            msg = err.message;
          }

          setError(String(msg)); 
        } else {
          setError("알 수 없는 오류가 발생했습니다.");
        }
      } finally {
        setLoading(false);
      }
    };

    fetchReqList();
  }, []);

  const hasData = !loading && !error && reqList.length > 0;

  return (
    <div id="Requests">
      <div className="Header">
        <Header />
      </div>

      <div style={{ padding: "20px" }}>
        <h2>📄 신청 목록</h2>

        {loading && <p>불러오는 중...</p>}

        {!loading && !error && reqList.length === 0 && (
          <p>신청자가 없습니다.</p>
        )}

        {hasData && (
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

export default Requests;
