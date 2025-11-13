import { useEffect, useState } from 'react';
import axios from 'axios';


const Header = () => {
    const [ping, setPing] = useState("");

    useEffect(() => {
        const fetchTest = async () => {
            try {
                const res = await axios.get(`${__API_BASE__}/auth/ping`);
                setPing(res.data);
            } catch (err) {
                console.log(err);
            }
        }
        fetchTest();
    }, []);

    return(
        <div id="Header">
            header test header
            <span className='testPing'>{ping}</span>
        </div>
    );
}

export default Header;