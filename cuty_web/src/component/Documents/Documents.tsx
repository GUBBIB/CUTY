import { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import axios from "axios";

const Documents = () => {
  const { userId } = useParams(); // URL에서 userId 가져오기
  const [pdfUrl, setPdfUrl] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchPdf = async () => {
      try {
        const token = localStorage.getItem("accessToken");
        
        const response = await axios.get(`/api/v1/requests/${userId}/merged-document`, {
          headers: {
            Authorization: `Bearer ${token}`,
          },
          responseType: "blob", // 중요: PDF 데이터 받기
        });

        // 2. 받아온 데이터를 Blob URL로 변환
        const blob = new Blob([response.data], { type: "application/pdf" });
        const url = URL.createObjectURL(blob);
        setPdfUrl(url);
      } catch (err) {
        console.error(err);
        setError("서류를 불러오지 못했습니다.");
      } finally {
        setLoading(false);
      }
    };

    if (userId) {
      fetchPdf();
    }
  }, [userId]);

  if (loading) return <div style={{ padding: 20 }}>서류를 불러오는 중입니다...</div>;
  if (error) return <div style={{ padding: 20, color: 'red' }}>{error}</div>;

  return (
    <div style={{ width: "100vw", height: "100vh", overflow: "hidden" }}>
      {/* 3. 화면 가득 채워서 PDF 보여주기 */}
      {pdfUrl && (
        <iframe
          src={pdfUrl}
          style={{ width: "100%", height: "100%", border: "none" }}
          title="Document Viewer"
        />
      )}
    </div>
  );
};

export default Documents;