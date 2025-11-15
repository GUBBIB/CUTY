import { useEffect, useState } from 'react';
import axios from 'axios';

interface PingResponse{
    message: string;
}

const Header = () => {
    const [ping, setPing] = useState<PingResponse | null>(null);

    useEffect(() => {
        const fetchTest = async () => {
            try {
                const res = await axios.get(`/api/v1/auth/ping`);
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
            <span className='testPing'>{ping?.message}</span>
        </div>
    );
}

export default Header;