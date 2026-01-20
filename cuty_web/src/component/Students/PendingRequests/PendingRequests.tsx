import React, { useEffect, useState } from "react";
import axios from "axios";
// 1. 여기서 react-icons를 불러옵니다.
import { FiFileText } from "react-icons/fi";
import "./PendingRequests.css";
import { Link } from "react-router";

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
    reqType: string;
    status: string;
    createdAt: string;
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

const PendingRequests = () => {
    const [data, setData] = useState<RequestItem[]>([]);
    const [loading, setLoading] = useState<boolean>(true);
    const [selectedIds, setSelectedIds] = useState<number[]>([]);

    const fetchRequests = async () => {
        try {
            const token = localStorage.getItem("accessToken");
            const response = await axios.get<ApiResponse>("/api/v1/requests/", {
                params: {
                    page: 1,
                    per_page: 10,
                    status: "PENDING",
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

    const formatDate = (isoString: string) => {
        if (!isoString) return "-";
        const date = new Date(isoString);
        return (
            date.toLocaleDateString("ko-KR", {
                year: "numeric",
                month: "2-digit",
                day: "2-digit",
            }).replace(/\. /g, ".").replace(".", "") +
            " " +
            date.toLocaleTimeString("ko-KR", {
                hour: "2-digit",
                minute: "2-digit",
                hour12: false,
            })
        );
    };

    const handleCheck = (id: number) => {
        if (selectedIds.includes(id)) {
            setSelectedIds(selectedIds.filter((sid) => sid !== id));
        } else {
            setSelectedIds([...selectedIds, id]);
        }
    };

    const handleAllCheck = (checked: boolean) => {
        if (checked) {
            const allIds = data.map((item) => item.requestsId);
            setSelectedIds(allIds);
        } else {
            setSelectedIds([]);
        }
    };

    if (loading) return <div id="PendingRequests">로딩 중...</div>;

    return (
        <div id="PendingRequests">
            <div className="pending-container">
                <div className="pending-header">
                    <h3>승인 대기 목록 <span className="count-text">(총 {data.length}건)</span></h3>
                    <button className="approve-btn">일괄 승인 및 직인 날인</button>
                </div>

                <div className="table-wrapper">
                    <table className="pending-table">
                        <thead>
                            <tr>
                                <th className="th-check">
                                    <div className="checkbox-wrapper">
                                        <input
                                            type="checkbox"
                                            onChange={(e) => handleAllCheck(e.target.checked)}
                                            checked={data.length > 0 && selectedIds.length === data.length}
                                        />
                                        <span className="checkbox-label">전체선택</span>
                                    </div>
                                </th>
                                <th className="th-left">이름</th>
                                <th className="th-left">국적/비자</th>
                                <th className="th-left">근무처</th>
                                <th className="th-center">신청일시</th>
                                <th className="th-center">서류보기</th>
                                <th className="th-center">상태</th>
                            </tr>
                        </thead>
                        <tbody>
                            {data.map((item) => (
                                <tr key={item.requestsId} className={selectedIds.includes(item.requestsId) ? "row-selected" : ""}>
                                    <td className="td-check">
                                        <input
                                            type="checkbox"
                                            checked={selectedIds.includes(item.requestsId)}
                                            onChange={() => handleCheck(item.requestsId)}
                                        />
                                    </td>
                                    <td className="td-name">
                                        {item.user?.name}
                                    </td>
                                    <td className="td-gray">
                                        {item.user?.country || "국적미상"} / {item.user?.visa || "D-2"}
                                    </td>
                                    <td className="td-gray">
                                        {item.reqType || "-"}
                                    </td>
                                    <td className="td-center td-gray">
                                        {formatDate(item.createdAt)}
                                    </td>
                                    <td className="td-center">
                                        <div className="icon-btn-file">
                                            <Link to={`/documents/${item.user?.id}`} target="_blank" rel="noopener noreferrer">
                                                <FiFileText size={18} />
                                            </Link>
                                        </div>
                                    </td>
                                    <td className="td-center">
                                        <span className="status-badge-pending">승인 대기</span>
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

export default PendingRequests;