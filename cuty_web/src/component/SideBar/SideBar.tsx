import { Link, useLocation } from "react-router-dom";
import { FiHome, FiCheckSquare, FiUsers, FiDatabase } from "react-icons/fi"; 
import "./SideBar.css";

const SideBar = () => {
    const location = useLocation(); 

    const menus = [
        { name: "홈", path: "/dashboard", icon: <FiHome /> },
        { name: "알바 승인 관리", path: "/part-time-management", icon: <FiCheckSquare /> },
        { name: "학생 현황", path: "/students", icon: <FiUsers /> },
        { name: "데이터 센터", path: "/data-center", icon: <FiDatabase /> },
    ];

    return (
        <div id="SideBar">
            <div className="container">
                <div className="logo-area">
                    <h1><Link to="/dashboard">CUTY</Link></h1>
                </div>

                <nav className="menu-list">
                    {menus.map((menu, index) => {
                        const isActive = location.pathname === menu.path;
                        
                        return (
                            <Link 
                                key={index} 
                                to={menu.path} 
                                className={`menu-item ${isActive ? "active" : ""}`}
                            >
                                <span className="icon">{menu.icon}</span>
                                <span className="text">{menu.name}</span>
                            </Link>
                        );
                    })}
                </nav>
            </div>
        </div>
    );
}

export default SideBar;