import Header from "../Header/Header";
import "./Error.css";

interface ErrorProps {
    message?: string; // 선택적, 기본값 있음
}

const Error = ({ message = "잘못된 경로의 페이지입니다." }: ErrorProps) => {
    return (
        <div id="Error">
            <div className="Header">
                <Header />
            </div>
            <div className="Error-Content">
                {message}
            </div>
        </div>
    );
};

export default Error;
