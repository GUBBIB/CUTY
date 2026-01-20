import "./PartTimeManagement.css";
import Header from "../Header/Header";
import SideBar from "../SideBar/SideBar";
import PendingRequests from "../Students/PendingRequests/PendingRequests";

const PartTimeManagement = () => {

    return(
        <div id="PartTimeManagement">
            <div className="part-time-management-container">
                <SideBar />
            </div>
            <div className="part-time-management-content">
                <Header title="승인 대기 목록"/>

                <div className="part-time-management-section">
                    <PendingRequests />
                </div>
            </div>
        </div>
    );
};

export default PartTimeManagement;