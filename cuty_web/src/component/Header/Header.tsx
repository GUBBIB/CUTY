import { Link } from "react-router-dom";
import { LogOut } from "lucide-react";
import { useAuth } from "../../context/useAuth";
import "./Header.css";

const Header = () => {
    const { Logout, user } = useAuth();

    const handleLogout = () => {
        Logout();
    }

    return (
        <div id="Header">
            <div className="container">
                <div className="title-user">
                    <Link to="/dashboard">
                        <h1 className="title">CUTY</h1>
                    </Link>
                    <p className="user-name">{user?.email}</p>
                </div>
                <button className="logout-btn" onClick={handleLogout}>
                    <LogOut className="h-4 w-4   mr-2" />
                    로그아웃
                </button>
            </div>
        </div>
    );
}

export default Header;