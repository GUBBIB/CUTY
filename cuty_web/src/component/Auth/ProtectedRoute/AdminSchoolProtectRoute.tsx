import { Navigate, Outlet, useLocation } from "react-router-dom";
import { useAuth } from "../../../context/useAuth";

export default function AdminSchoolProtectRoute() {
    const { isLogin, userType } = useAuth();
    const location = useLocation();

    if (!isLogin) {
        return <Navigate to="/login" replace state={{ from: location }} />;
    }


    if (!userType) {
        return <Navigate to="/login" replace state={{ from: location }} />;
    }

    const allowedRoles = ["ADMIN", "SCHOOL"];
    if (!allowedRoles.includes(userType)) {
        return <Navigate to="/no-permission" replace />;
    }

    return <Outlet />;
}
