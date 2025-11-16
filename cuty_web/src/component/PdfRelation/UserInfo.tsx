import Header from "../Header/Header";
import axios from "axios";
import { useEffect, useState } from "react";
import { useParams } from "react-router-dom";

interface UserResponse {
    user: {
        id: number;
        name: string;
        email: string;
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
    };
    documents: {
        id: number;
        name: string;
        type: string;
        image: {
            id: number | null;
            url: string | undefined;
        };
        created_at: string;
    }[];
}


const UserInfo = () => {
    const { userId } = useParams<{ userId: string }>();
    const [user, setUser] = useState<UserResponse | null>(null);
    const [error, setError] = useState("");
    const [loading, setLoading] = useState(true);

    const getUserInfo = async () => {
        if (!userId) {
            setError("유저 ID가 없습니다.");
            setLoading(false);
            return;
        }

        try {
            const token = localStorage.getItem("accessToken");

            const res = await axios.get(`/api/v1/managements/user/${userId}`, {
                headers: token ? { Authorization: `bearer ${token}` } : undefined,
            });

            console.log("GET /api/v1/managements/user/:id response:", res.data);
            setUser(res.data);
            setError("");
        } catch (err) {
            console.error("GET /api/v1/managements/user/:id error:", err);
            setError("유저 정보를 불러오지 못했습니다.");
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        getUserInfo();
    }, [userId]);


    return (
        <div id="UserInfo">
            <div className="Header">
                <Header />
            </div>

            <div>
                <h2>👤 유저 정보</h2>

                {loading && <p>불러오는 중...</p>}
                {error && <p style={{ color: "red" }}>{error}</p>}

                {!loading && !error && user && (
                    <div>
                        <p>이름: {user.user.name}</p>
                        <p>이메일: {user.user.email}</p>

                        <p>국가: {user.user.country.name ?? "없음"}</p>
                        <p>학교: {user.user.school.name ?? "없음"}</p>
                        <p>대학: {user.user.college.name ?? "없음"}</p>
                        <p>학과: {user.user.department.name ?? "없음"}</p>

                        <h3>📄문서</h3>
                        <ul>
                            {user.documents.map(doc => (
                                <li key={doc.id}>
                                <a 
                                    href={doc.image.url} 
                                    target="_blank" 
                                    rel="noopener noreferrer"
                                    download
                                >
                                    {doc.name} ({doc.type})
                                </a>
                            </li>
                            ))}
                        </ul>
                    </div>
                )}

            </div>
        </div>
    );
}

export default UserInfo;