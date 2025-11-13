import { Link } from 'react-router-dom';
import Login from './Auth/Login';

const Home = () => {

    return (
        <div id="Main">
            <div>
                Home test home
            </div>
            <div>
                <Link to="/student-pdf">student-pdf</Link>
            </div>

            <div>
                <Link to="/login">로그인</Link>
            </div>
        </div>
    );
}
export default Home;