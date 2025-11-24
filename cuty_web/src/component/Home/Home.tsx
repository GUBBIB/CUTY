import { Link } from 'react-router-dom';
import './Home.css';
import { useAuth } from '../../context/useAuth';

const Home = () => {
    const { isLogin } = useAuth();

    const path = isLogin ? '/dashboard' : '/login';

    return (
        <div id="Home">
            <div className='container'>
                <div className='title'>
                    CUTY
                </div>

                <div className='description'>
                    관리 시스템
                </div>

                <div className='btn-section'>
                    <Link to={path}>
                        <div className='login-btn'>
                            시작하기
                        </div>
                    </Link>
                </div>
            </div>
        </div>
    );
}
export default Home;