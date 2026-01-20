import React from "react";
import "./StatCard.css";

interface statCardProps {
    label: string;
    color: string; 
}

const StatCard = ({ label, color }: statCardProps) => {
    return (
        <div 
            className="stat-card" 
            style={{ borderBottomColor: color }} // 전달받은 색상을 하단 테두리에 적용
        >
            <div className="stat-label">{label}</div>
            <div className="stat-value">{"값 수정"}</div>
        </div>
    );
};

export default StatCard;