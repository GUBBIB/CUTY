import { createContext, useState, type ReactNode } from "react";
import axios from "axios";
import { useNavigate } from "react-router-dom";

type LoginParam = {
    email: string;
    pw: string;
}

type RegisterParam = {
    email: string;
    pw: string;
    name: string;
    country_id?: number;
    school_id?: number;
    college_id?: number;
    department_id?: number;
}

type userType = "USER" | "ADMIN" | "SCHOOL";

type AuthCotextType = {
    isLogin: boolean;
    userType: userType | null;
    Login: (params: LoginParam) => Promise<boolean>;
    Logout: () => void;
    Register: (params: RegisterParam) => Promise<boolean>;
    authMessage: string | null;
    authError: string | null;
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
        navigate("/");
    };

    const Register = async (params: RegisterParam): Promise<boolean> => {
    try {
        const res = await axios.post("/api/v1/auth/register", params);

        const token = res.data.access_token;
        localStorage.setItem("accessToken", token);
        localStorage.setItem("userType", res.data.user_type);

        setUserType(res.data.user_type);
        setIsLogin(true);
        setAuthMessage("회원가입 성공!");
        setAuthError(null);

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
        <AuthContext.Provider value={{ isLogin, Login, Logout, Register, userType, authMessage, authError }}>
            {children}
        </AuthContext.Provider>
    );
};