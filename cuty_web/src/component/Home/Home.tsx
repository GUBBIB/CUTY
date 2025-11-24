import { Link } from 'react-router-dom';
import './Home.css';

const Home = () => {

    return (
        <div id="Home">
            <div className='title'>
                CUTY
            </div>

            <div className='description'>
                관리 시스템
            </div>

            <div className='btn-section'>
                <Link to='/login'>
                    <div className='login-btn'>
                        시작하기
                    </div>
                </Link>
            </div>
        </div>  
    );
}
export default Home;