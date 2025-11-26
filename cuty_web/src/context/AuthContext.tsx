import { createContext, useState, type ReactNode, useEffect } from "react";
import axios from "axios";
import { useNavigate } from "react-router-dom";

type LoginParam = {
    email: string;
    pw: string;
}

type RegisterParam = {
    email: string;
    password: string;
    name: string;
    country_id?: number;
    school_id?: number;
    college_id?: number;
    department_id?: number;
}

type userType = "USER" | "ADMIN" | "SCHOOL";

type UserInfo = {
    id: number;
    email: string;
    name: string;
    country: {
        id: number;
        name: string;
        code: string;
    };
    school: {
        id: number;
        name: string;
    };
    college: {
        id: number;
        name: string;
    };
    department: {
        id: number;
        name: string;
    };
    created_at: string;
    updated_at: string;
}

type AuthCotextType = {
    isLogin: boolean;
    userType: userType | null;
    Login: (params: LoginParam) => Promise<boolean>;
    Logout: () => void;
    Register: (params: RegisterParam) => Promise<boolean>;
    authMessage: string | null;
    authError: string | null;
    user: UserInfo | null;
};

export const AuthContext = createContext<AuthCotextType | null>(null);

export const AuthProvider = ({ children }: { children: ReactNode }) => {
    const [isLogin, setIsLogin] = useState<boolean>(() => {
        return !!localStorage.getItem("accessToken");
    });
    const [userType, setUserType] = useState<userType | null>(() => {
        const stored = localStorage.getItem("userType");
        if (stored === "USER" || stored === "ADMIN" || stored === "SCHOOL") {
            return stored;
        }
        return null;
    });
    const [authError, setAuthError] = useState<string | null>(null);
    const [authMessage, setAuthMessage] = useState<string | null>(null);
    const navigate = useNavigate();
    const [user, setUser] = useState<UserInfo | null>(null);


    useEffect(() => {
        const token = localStorage.getItem("accessToken");
        if (!token) return;

        const fetchMe = async () => {
            try {
                const res = await axios.get("/api/v1/users/me", {
                    headers: { Authorization: `Bearer ${token}` }
                });
                setUser(res.data);
            } catch {
                setIsLogin(false);
            }
        };

        fetchMe();
    }, []);

    const Login = async ({ email, pw }: LoginParam): Promise<boolean> => {
        try {
            setAuthError(null);

            const res = await axios.post("/api/v1/auth/login", {
                email: email,
                password: pw,
            });

            const token = res.data.access_token;
            localStorage.setItem("accessToken", token);
            localStorage.setItem("userType", res.data.user_type);

            setUserType(res.data.user_type);
            setIsLogin(true);
            setAuthError(null);

            const me = await axios.get("/api/v1/users/me", {
                headers: {
                    Authorization: `Bearer ${token}`
                }
            });

            setUser(me.data);

            return true;
        } catch (err: any) {
            setIsLogin(false);

            if (err.response?.data?.error) {
                setAuthError(err.response.data.error);
            } else {
                setAuthError("로그인 실패");
            }

            return false;
        }
    };
    const Logout = () => {
        localStorage.removeItem("accessToken");
        localStorage.removeItem("userType");
        setIsLogin(false);
        setUser(null);
        navigate("/");
    };

    const Register = async (params: RegisterParam): Promise<boolean> => {
        try {
            const res = await axios.post("/api/v1/auth/register", {
                email: params.email,
                password: params.password,
                name: params.name,
                country_id: params.country_id,
                school_id: params.school_id,
                college_id: params.college_id,
                department_id: params.department_id,
            });

            const token = res.data.access_token;
            localStorage.setItem("accessToken", token);
            localStorage.setItem("userType", res.data.user_type);

            setUserType(res.data.user_type);
            setIsLogin(true);
            setAuthMessage("회원가입 성공!");
            setAuthError(null);

            const me = await axios.get("/api/v1/users/me", {
                headers: {
                    Authorization: `Bearer ${token}`
                }
            });

            setUser(me.data);

            return true;
        } catch (err: any) {
            if (err.response?.data?.error) {
                setAuthError(err.response.data.error);
            } else {
                setAuthError("회원가입 실패");
            }

            return false;
        }
    };

    return (
        <AuthContext.Provider value={{ isLogin, Login, Logout, Register, userType, authMessage, authError, user }}>
            {children}
        </AuthContext.Provider>
    );
};