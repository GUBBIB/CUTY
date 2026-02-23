import { BrowserRouter as Router, Routes, Route, useNavigate } from 'react-router-dom';
// eslint-disable-next-line no-unused-vars
import { motion } from 'framer-motion';
import Diagnosis from './pages/Diagnosis';
import Result from './pages/Result';
import ComprehensiveReport from './pages/ComprehensiveReport';
import kvtiQuestions from './data/kvti_questions.json';
import { calculateKvtiResult } from './utils/kvtiLogic';

function LandingPage() {
  const navigate = useNavigate();

  const handleDevTest = () => {
    // Hidden Dev Feature for Demo: Truly Random Test
    if (!window.confirm("개발자 모드: 모든 문항에 완전 무작위(Random) 값을 입력하시겠습니까? (다양한 페르소나/비자 결과 테스트용)")) return;

    const allSections = [
      'part1_riasec', 'part2_competency', 'part3_job_pref',
      'part4_industry_pref', 'part5_org_culture', 'part6_residency'
    ];

    // To avoid the "Law of Large Numbers" averaging out the scores and always resulting in the same persona,
    // we need to force a distinct peak in one RIASEC trait and one Industry trait.
    const riasecKeys = ['R', 'I', 'A', 'S', 'E', 'C'];
    const chosenRiasec = riasecKeys[Math.floor(Math.random() * riasecKeys.length)];

    const industryKeys = ['IT', 'BIZ', 'DES', 'MFG'];
    const chosenIndustry = industryKeys[Math.floor(Math.random() * industryKeys.length)];

    const randomAnswers = {};

    allSections.forEach(sectionKey => {
      const questions = kvtiQuestions[sectionKey] || [];
      questions.forEach(q => {
        if (!q || !q.id) return;
        // Skip headers
        if (q.id === 'ID' || q.type === '코드' || q.question?.includes('문항')) return;

        if (q.options) {
          if (q.options.length > 0) {
            const randomOptionIndex = Math.floor(Math.random() * q.options.length);
            randomAnswers[q.id] = q.options[randomOptionIndex].value;
          }
        } else {
          // Default random 1-3
          let val = Math.floor(Math.random() * 3) + 1;

          // Force peaks for distinct personas
          if (sectionKey === 'part1_riasec' && q.type?.startsWith(chosenRiasec)) {
            val = 5;
          } else if (sectionKey === 'part4_industry_pref') {
            // IDs: IND_I (IT), IND_M (MFG), IND_C (DES), IND_T/IND_B (BIZ)
            const isMatch = (chosenIndustry === 'IT' && q.id.includes('IND_I')) ||
              (chosenIndustry === 'MFG' && q.id.includes('IND_M')) ||
              (chosenIndustry === 'DES' && q.id.includes('IND_C')) ||
              (chosenIndustry === 'BIZ' && (q.id.includes('IND_T') || q.id.includes('IND_B')));
            if (isMatch) {
              val = 5;
            } else {
              // Ensure non-matches don't tie with 5
              val = Math.floor(Math.random() * 3) + 1; // 1 to 3 max
            }
          } else if (sectionKey === 'part3_job_pref') {
            // IDs: JP_I (IT), JP_R (MFG), JP_A (DES), JP_E/JP_C/JP_S (BIZ)
            const isMatch = (chosenIndustry === 'IT' && q.id.includes('JP_I')) ||
              (chosenIndustry === 'MFG' && q.id.includes('JP_R')) ||
              (chosenIndustry === 'BIZ' && (q.id.includes('JP_E') || q.id.includes('JP_S') || q.id.includes('JP_C'))) ||
              (chosenIndustry === 'DES' && q.id.includes('JP_A'));

            if (isMatch) {
              val = 5;
            } else {
              val = Math.floor(Math.random() * 3) + 1;
            }
          } else if (sectionKey === 'part2_competency' || sectionKey === 'part6_residency') {
            // High competency and residency for better visa odds
            val = Math.floor(Math.random() * 2) + 4; // 4 or 5
          }

          randomAnswers[q.id] = val;
        }
      });
    });

    try {
      const majorMap = { 'IT': '소프트웨어공학', 'BIZ': '경영학', 'DES': '시각디자인', 'MFG': '기계공학' };
      const uniList = [
        '서울대학교', '연세대학교', '고려대학교', '카이스트(KAIST)', '포스텍(POSTECH)',
        '한양대학교', '성균관대학교', '경희대학교', '한국외국어대학교',
        '부산대학교', '경북대학교', '전남대학교', '충남대학교', '전북대학교',
        '인하대학교', '아주대학교', '영남대학교', '계명대학교', '동아대학교', '조선대학교'
      ];
      const regionList = ['서울', '경기', '인천', '대전', '부산', '대구'];
      const gradeList = ['3학년', '4학년', '석박사'];
      const randomPhase0 = {
        name: 'DevTester',
        age: Math.floor(Math.random() * 10) + 20,
        nationality: 'USA',
        region: regionList[Math.floor(Math.random() * regionList.length)],
        university: uniList[Math.floor(Math.random() * uniList.length)], // Randomize university
        major: majorMap[chosenIndustry],
        grade: gradeList[Math.floor(Math.random() * gradeList.length)],
        topik: Math.floor(Math.random() * 4) + 3 + "", // 3 to 6
        kiip: '0',
        secondaryLanguages: []
      };

      // Ensure answers are actually stored in localStorage for the Comprehensive Report to fetch
      localStorage.setItem('kvti_answers', JSON.stringify(randomAnswers));
      localStorage.setItem('kvti_base_profile', JSON.stringify(randomPhase0));

      const result = calculateKvtiResult(randomAnswers, 'senior', randomPhase0);
      navigate('/result', { state: { result } });
    } catch (e) {
      console.error(e);
      alert("Dev Test Failed: " + e.message);
    }
  };

  return (
    <div className="min-h-screen bg-kvti-bg text-white flex flex-col items-center justify-center relative overflow-hidden">
      {/* Background Ambience */}
      <div className="absolute top-0 left-0 w-full h-full overflow-hidden z-0 pointer-events-none">
        <div className="absolute top-[-20%] left-[-20%] w-[60%] h-[60%] bg-blue-900/10 rounded-full blur-[120px]"></div>
        <div className="absolute bottom-[-20%] right-[-20%] w-[60%] h-[60%] bg-kvti-primary/5 rounded-full blur-[120px]"></div>
      </div>

      <div className="z-10 text-center px-6 max-w-5xl w-full">
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8, ease: "easeOut" }}
        >
          <div className="mb-4">
            <span className="text-white text-lg md:text-xl font-light tracking-[0.3em] uppercase opacity-80 block mb-2">
              Design Your Future in Korea
            </span>
            <div className="relative inline-block">
              <h1 className="text-8xl md:text-9xl font-black mb-2 leading-none tracking-tighter gold-gradient-text">
                KVTI
              </h1>
              <div className="h-1 w-full bg-kvti-primary rounded-full mt-2 opacity-50"></div>
            </div>
            <p className="text-kvti-primary text-sm md:text-base font-bold tracking-[0.2em] mt-4 uppercase">
              Korea Visa Type Indicator
            </p>
          </div>

          <p className="text-slate-400 text-lg md:text-xl mb-12 max-w-2xl mx-auto leading-relaxed font-light mt-8">
            KVTI provides a comprehensive AI-driven analysis of your visa suitability and career potential tailored for global talents.
          </p>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, scale: 0.95 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ delay: 0.4, duration: 0.5 }}
          className="flex flex-col md:flex-row items-center justify-center gap-4"
        >
          <button
            onClick={() => {
              localStorage.removeItem('kvti_base_profile');
              localStorage.removeItem('kvti_answers');
              navigate('/diagnosis');
            }}
            className="group relative inline-flex items-center justify-center px-12 py-5 text-lg font-bold text-slate-900 transition-all duration-300 bg-kvti-primary rounded-none clip-path-slant focus:outline-none hover:bg-white hover:shadow-[0_0_30px_rgba(56,189,248,0.4)]"
            style={{ clipPath: 'polygon(10% 0, 100% 0, 100% 70%, 90% 100%, 0 100%, 0 30%)' }}
          >
            <span className="relative flex items-center gap-3">
              START ASSESSMENT
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor" className="w-5 h-5 transition-transform group-hover:translate-x-1">
                <path strokeLinecap="round" strokeLinejoin="round" d="M17.25 8.25L21 12m0 0l-3.75 3.75M21 12H3" />
              </svg>
            </span>
          </button>

          {/* Dev Test Button (Next to Start) */}
          <button
            onClick={handleDevTest}
            className="px-6 py-4 text-xs font-bold text-white/40 hover:text-white hover:bg-white/10 border border-white/10 transition-all uppercase tracking-widest rounded"
          >
            [DEV: Random Test]
          </button>
        </motion.div>

        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 1, duration: 1 }}
          className="mt-20 grid grid-cols-3 gap-8 text-center border-t border-white/5 pt-10"
        >
          {[
            { label: "Diagnosis Time", value: "20-25 min" },
            { label: "Analysis Areas", value: "6 Sectors" },
            { label: "Visa Strategy", value: "AI Report" }
          ].map((item, idx) => (
            <div key={idx}>
              <div className="text-kvti-primary text-2xl md:text-3xl font-bold mb-1 font-display">{item.value}</div>
              <div className="text-slate-500 text-xs md:text-sm uppercase tracking-wider">{item.label}</div>
            </div>
          ))}
        </motion.div>
      </div>

      <footer className="absolute bottom-6 w-full text-center z-50">
        <p className="text-slate-600 text-xs tracking-widest uppercase">
          © 2026 Global Career Center. All rights reserved.
        </p>
      </footer>
    </div>
  );
}

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<LandingPage />} />
        <Route path="/diagnosis" element={<Diagnosis />} />
        <Route path="/result" element={<Result />} />
        <Route path="/report" element={<ComprehensiveReport />} />
      </Routes>
    </Router>
  );
}

export default App;
