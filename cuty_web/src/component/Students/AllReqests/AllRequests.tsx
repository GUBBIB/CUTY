import { useEffect, useState } from "react";
import axios from "axios";
import "./AllRequests.css";

interface UserData {
  id: number;
  name: string;
  email: string;
  country: string | null;
  school: string | null;
  visa?: string;
}

interface RequestItem {
  requestsId: number;
  reqType: string;    // 신청 유형 (예: 서빙알바)
  status: string;     // 진행 상태 (예: 승인 대기)
  createdAt: string;  // 날짜 (ISO String)
  userId: number;
  userName: string;
  user: UserData;
}

interface ApiResponse {
  items: RequestItem[];
  total: number;
  page: number;
  per_page: number;
  has_next: boolean;
  has_prev: boolean;
}

const AllRequests = () => {
  const [data, setData] = useState<RequestItem[]>([]);
  const [loading, setLoading] = useState<boolean>(true);

  const fetchRequests = async () => {
    try {
      const token = localStorage.getItem("accessToken");

      const response = await axios.get<ApiResponse>("/api/v1/requests/", {
        params: {
          page: 1,
          per_page: 10,
        },
        headers: token
          ? { Authorization: `Bearer ${token}` }
          : undefined,
      });
      setData(response.data.items);
    } catch (error) {
      console.error("데이터 로딩 실패:", error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchRequests();
  }, []);

  const getStatusClass = (status: string) => {
    switch (status) {
      case "승인 대기": return "badge-waiting";
      case "출입국 제출": return "badge-submitted";
      case "출입국 반려": return "badge-rejected";
      case "최종 승인": return "badge-approved";
      default: return "badge-default";
    }
  };

  const formatDate = (isoString: string) => {
    if (!isoString) return "-";
    const date = new Date(isoString);
    return date.toLocaleDateString("ko-KR", {
      year: "numeric",
      month: "2-digit",
      day: "2-digit"
    }).replace(/\. /g, ".").replace(".", ""); // 2026.01.13 형식으로 다듬기
  };

  if (loading) return <div className="loading-msg">데이터를 불러오는 중...</div>;

  return (
    <div id="AllRequests">

      <div className="table-container">
        <div className="table-header-row">
          <h3>신청 현황</h3>
          <button className="download-btn">⬇ 통계 및 데이터 다운로드</button>
        </div>

        <div className="table-wrapper">
          <table className="custom-table">
            <thead>
              <tr>
                <th className="th-left">학생명(국적)</th>
                <th>비자타입</th>
                <th>신청 유형</th>
                <th className="th-center">진행 상태</th>
                <th className="th-right">승인 기간 (신청일)</th>
              </tr>
            </thead>
            <tbody>
              {data.map((item) => (
                <tr key={item.requestsId}>
                  <td className="td-name">
                    {item.user?.name}
                    <span className="sub-text">
                      ({item.user?.country || "국적미상"})
                    </span>
                  </td>
                  <td className="td-gray">
                    {item.user?.visa || "D-2"}
                  </td>
                  <td className="td-gray">{item.reqType}</td>
                  <td className="td-center">
                    <span className={`status-badge ${getStatusClass(item.status)}`}>
                      {item.status}
                    </span>
                  </td>
                  <td className="td-right td-gray">
                    {formatDate(item.createdAt)}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>

  );
};

export default AllRequests;