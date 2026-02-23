import { useLocation, useNavigate } from "react-router-dom";
import DashboardTop from "../components/DashboardTop";
import RoadmapTimeline from "../components/RoadmapTimeline";

function Result() {
  const location = useLocation();
  const navigate = useNavigate();
  const { result } = location.state || {};

  if (!result) {
    return (
      <div className="min-h-screen bg-kvti-bg text-white flex items-center justify-center">
        <div className="text-center">
          <h2 className="text-xl mb-4 text-slate-300">
            결과 데이터가 없습니다.
          </h2>
          <button
            onClick={() => navigate("/")}
            className="text-kvti-primary underline"
          >
            홈으로 돌아가기
          </button>
        </div>
      </div>
    );
  }

  const { diagnosis, roadmap } = result;

  return (
    <div className="min-h-screen bg-kvti-bg text-white p-4 md:p-8 overflow-y-auto font-sans">
      <div className="max-w-5xl mx-auto space-y-16 pt-12 pb-24">
        {/* Navigation Header */}
        <div className="fixed top-6 right-6 z-50">
          <button
            onClick={() => {
              localStorage.removeItem('kvti_base_profile');
              localStorage.removeItem('kvti_answers');
              navigate("/");
            }}
            className="bg-black/20 hover:bg-black/40 backdrop-blur-md px-4 py-2 rounded-full transition-all text-white border border-white/10 shadow-lg text-sm font-medium"
          >
            처음으로
          </button>
        </div>

        {/* Phase 3: POSITIVE FRAMING DASHBOARD */}
        <DashboardTop reportData={result} />

        {/* Phase 4: GAMIFIED ACTION ROADMAP */}
        <RoadmapTimeline
          roadmapData={roadmap}
          d10Simulation={diagnosis.d10_sim}
          userProfile={diagnosis.user_profile}
        />

        {/* Footer */}
        <div className="text-center pt-10 border-t border-white/5">
          <button
            onClick={() => {
              localStorage.removeItem('kvti_base_profile');
              localStorage.removeItem('kvti_answers');
              navigate("/");
            }}
            className="px-10 py-4 rounded-full bg-kvti-primary hover:bg-white text-slate-900 font-black shadow-lg hover:shadow-[0_0_30px_rgba(56,189,248,0.4)] hover:scale-105 transition-all tracking-wide"
          >
            다시 진단하기 (Restart)
          </button>
          <p className="mt-6 text-xs text-slate-600">
            KVTI System v2.1 • Based on Ministry of Justice Guidelines (2026)
            • Designed for Student Success
          </p>
        </div>
      </div>
    </div>
  );
}

export default Result;
