import { useEffect, useState } from "react";
import Header from "../Header/Header";
import axios from "axios";

const Pdf = () => {
  const [pdfList, setPdfList] = useState<string[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchPdfList = async () => {
      try {
        const res = await axios.get(`/requests/`);
        // 예: [{ name: "file1.pdf" }, { name: "file2.pdf" }]
        setPdfList(res.data.map((item: any) => item.name));
      } catch (err: any) {
        setError(err.message || "PDF 목록 불러오기 실패");
      } finally {
        setLoading(false);
      }
    };
    fetchPdfList();
  }, []);

    
  return (
    <div id="PDF">
      <div className="Header">
        <Header />
      </div>

      <div style={{ padding: "20px" }}>
        <h2>📄 PDF 목록</h2>

        {loading && <p>불러오는 중...</p>}
        {error && <p style={{ color: "red" }}>오류: {error}</p>}

        {!loading && !error && pdfList.length === 0 && (
          <p>PDF가 없습니다.</p>
        )}

        <ul>
          {pdfList.map((name, idx) => (
            <li key={idx}>{name}</li>
          ))}
        </ul>
      </div>
    </div>
  );
};

export default Pdf;
