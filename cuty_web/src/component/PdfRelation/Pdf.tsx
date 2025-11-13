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
        const token = localStorage.getItem("accessToken");

        const res = await axios.get(`/api/v1/requests/`, {
          headers: token ?
            { Authorization: `Bearer ${token}`}
            : undefined,
        });

        // 예: [{ name: "file1.pdf" }, { name: "file2.pdf" }]
        setPdfList(res.data.map((item: any) => item.name));
      } catch (err: any) {
        if (axios.isAxiosError(err)) {
          const data = err.response?.data;

          let msg = "PDF 목록 불러오기 실패";

          if (data) {
            if (typeof data === "string") {
              msg = data;
            } else if (typeof data === "object" && "error" in data) {
              // { error: "토큰이 필요합니다" } 같은 형태
              msg = (data as any).error ?? msg;
            }
          } else if (err.message) {
            msg = err.message;
          }

          setError(msg);
        } else {
          setError("알 수 없는 오류가 발생했습니다.");
        }
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
        {error && <p className="err">오류: {error}</p>}

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
