import SideBar from "../SideBar/SideBar";
import "./Dashboard.css";
import Header from "../Header/Header";
import StatCard from "../StatCard/StatCard";
import AllRequests from "../Students/AllReqests/AllRequests";


const Dashboard = () => {

  const cardData = [
    { label: "승인 대기", color: "#f59e0b" },    // 주황색
    { label: "출입국 제출", color: "#3b82f6" },   // 파란색
    { label: "출입국 반려", color: "#ef4444" },   // 빨간색
    { label: "최종 승인 (금월)", color: "#22c55e" } // 초록색
  ];

  return (
    <div id="Dashboard">
      <div className="dashboard-container">
        <SideBar />
      </div>
      <div className="dashboard-content">
        <Header title="홈" />

        <div className="dashboard-stats">
          <div style={{ padding: "30px" }}>
            <div style={{ display: "flex", gap: "20px", flexWrap: "wrap" }}>
              {cardData.map((data) => (
                <StatCard
                  label={data.label}
                  color={data.color}
                />
              ))}
            </div>

            <div className="students-table-section">
              <AllRequests />
            </div>
          </div>
        </div>
      </div>


    </div>
  );
};

export default Dashboard;