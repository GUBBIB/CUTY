import { useState } from "react";
import axios from "axios";
import { Link } from "react-router-dom";

interface SelectUser {
    id: number;
    name: string | null;
    email: string | null;

    country: {
        id: number | null;
        name: string | null;
    };

    school: {
        id: number | null;
        name: string | null;
    };

    college: {
        id: number | null;
        name: string | null;
    };

    department: {
        id: number | null;
        name: string | null;
    };
}

const Select = () => {
    const [error, setError] = useState("");
    const [loading, setLoading] = useState(false);
    const [userEmail, setUserEmail] = useState("");
    const [selectUser, setSelectUser] = useState<SelectUser | null>(null);

    const selectUserHandler = async (e: any) => {
        e.preventDefault();

        setLoading(true);

        try {
            const token = localStorage.getItem("accessToken");

            const res = await axios.get(`/api/v1/users/select`, {
                params: {
                    user_email: userEmail
                },
                headers: token
                    ? { Authorization: `Bearer ${token}` }
                    : undefined,
            })

            console.log("GET /api/v1/users/select response:", res.data);
            setSelectUser(res.data);
            setError("");
        } catch (err) {
            console.error("GET /api/v1/users/select error:", err);

            setError("알 수 없는 오류가 발생했습니다.");
        } finally {
            setLoading(false);
        }
    }

    return (
        <div id="Select">
            <div className="select-section">
                <form onSubmit={selectUserHandler}>
                    <input type="text" placeholder="email을 입력하세요" value={userEmail} onChange={(e) => setUserEmail(e.target.value)} />
                    <button type="submit">검색</button>
                </form>
            </div>
            <div className="result-section">
                {loading && <p>로딩 중...</p>}

                {!loading && error && (
                    <p className="error-msg">{error}</p>
                )}

                {!loading && !error && !selectUser && (
                    <p>검색 결과가 없습니다.</p>
                )}

                {selectUser && (
                    <div className="user-info">
                        <h3>사용자 정보</h3>
                        <ul>
                            <li><strong>ID:</strong> {selectUser.id}</li>
                            <li><strong>이름:</strong> {selectUser.name}</li>
                            <li><strong>이메일:</strong> {selectUser.email}</li>

                            <li><strong>국가:</strong> {selectUser.country?.name}</li>
                            <li><strong>학교:</strong> {selectUser.school?.name}</li>
                            <li><strong>단과대학:</strong> {selectUser.college?.name}</li>
                            <li><strong>학과:</strong> {selectUser.department?.name}</li>
                        </ul>

                        {/* 필요하면 유저 상세 페이지 이동 */}
                        <Link to={`/user-info/${selectUser.id}`} className="detail-btn">
                            {selectUser.name} 상세 보기
                        </Link>
                    </div>
                )}
            </div>

        </div>
    );
}

export default Select;