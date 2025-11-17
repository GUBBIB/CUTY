import { Link } from 'react-router-dom';
import Header from './Header/Header';
import { useAuth } from '../context/useAuth';
import './Home.css';

const Home = () => {
    const { Logout } = useAuth();

    return (
        <div id="Main">
            <div>
                <Header />
            </div>
            <div>
                <Link to="/student-pdf">student-pdf</Link>
            </div>

            <div>
                <Link to="/login">로그인</Link>
                <div className="logout-btn" onClick={() => Logout()}>로그아웃</div>
            </div>
        </div>  
    );
}
export default Home;