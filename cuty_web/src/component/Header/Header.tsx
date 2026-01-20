import React from "react";
import { FiFolder, FiBell } from "react-icons/fi"; 
import "./Header.css";

interface HeaderProps {
    title: string;
}

const Header = ({title}: HeaderProps) => {
    return (
        <header id="Header">
            <div className="header-left">
                <h2>{title}</h2>
            </div>

            <div className="header-right">
                <button className="icon-btn">
                    <FiFolder />
                </button>
                <button className="icon-btn">
                    <FiBell />
                </button>
                
                <div className="user-profile">
                </div>
            </div>
        </header>
    );
};

export default Header;