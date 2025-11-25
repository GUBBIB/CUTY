import Header from "../Header/Header";
import "./Error.css";

const Error = () => {
    return (
        <div id="Error">
            <div className="Header">
                <Header />
            </div>
            <div className="Error-Content">
                경로가 잘 못 된 페이지 입니다.
            </div>
        </div>
    );
}

export default Error;