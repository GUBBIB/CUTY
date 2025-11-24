import { useNavigate } from "react-router-dom";
import { Search, FileText } from "lucide-react";
import Header from "../Header/Header";
import "./Dashboard.css";


const Dashboard = () => {
  const navigate = useNavigate();

  const menuItems = [
    {
      title: "학생 검색",
      description: "등록된 학생 정보를 검색하고 조회합니다",
      icon: Search,
      path: "/students"
    },
    {
      title: "신청자 목록",
      description: "신규 신청자 목록을 확인합니다",
      icon: FileText,
      path: "/applicants"
    }
  ];

  return (
    <div id="Dashboard">
      <div className="header">
        <Header />
      </div>

      <div className="container">
        <div className="page-description">
          <h2 className="title">학생 관리 시스템</h2>
          <p className="description">학생 정보를 관리하고 조회할 수 있습니다</p>
        </div>

        <div className="menu-grid">
          {menuItems.map((item) => (
            (
              <div
                key={item.title}
                className="menu-card"
                onClick={() => navigate(item.path)}>
                <div className="card-container">
                  <div className="">
                    <item.icon className="menu-icon" />
                    <div className="card-title">
                      {item.title}
                    </div>
                  </div>
                  <div className="card-description">
                    {item.description}
                  </div>
                </div>
              </div>
            )
          ))}

        </div>
      </div>
      {/* 
      <main className="container mx-auto px-4 py-8">
        <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
          {menuItems.map((item) => (
            <Card
              key={item.title}
              className="cursor-pointer hover:shadow-lg transition-shadow"
              onClick={() => navigate(item.path)}
            >
              <CardHeader>
                <div className="flex items-center gap-2 mb-2">
                  <item.icon className="h-6 w-6 text-primary" />
                  <CardTitle>{item.title}</CardTitle>
                </div>
                <CardDescription>{item.description}</CardDescription>
              </CardHeader>
            </Card>
          ))}
        </div>
      </main> */}
    </div>
  );
};

export default Dashboard;