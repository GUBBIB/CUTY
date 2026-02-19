import { BrowserRouter as Router, Routes, Route, useNavigate } from 'react-router-dom';
import { motion } from 'framer-motion';
import Diagnosis from './pages/Diagnosis';
import Result from './pages/Result';

function LandingPage() {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-kvti-bg text-white flex flex-col items-center justify-center relative overflow-hidden">
      {/* Background Ambience */}
      <div className="absolute top-0 left-0 w-full h-full overflow-hidden z-0 pointer-events-none">
        <div className="absolute top-[-20%] left-[-20%] w-[60%] h-[60%] bg-blue-900/20 rounded-full blur-[120px]"></div>
        <div className="absolute bottom-[-20%] right-[-20%] w-[60%] h-[60%] bg-kvti-gold/10 rounded-full blur-[120px]"></div>
      </div>

      <div className="z-10 text-center px-6 max-w-5xl w-full">
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8, ease: "easeOut" }}
        >
          <div className="inline-block px-4 py-1.5 mb-6 border border-kvti-gold/30 rounded-full bg-kvti-gold/5 backdrop-blur-sm">
            <span className="text-kvti-primary text-xs md:text-sm font-bold tracking-[0.2em] uppercase">
              Korea Visa Type Indicator
            </span>
          </div>

          <h1 className="text-5xl md:text-7xl font-bold mb-6 leading-tight tracking-tight">
            <span className="text-white">Design Your </span>
            <br className="md:hidden" />
            <span className="gold-gradient-text">Future in Korea</span>
          </h1>

          <p className="text-slate-400 text-lg md:text-xl mb-12 max-w-2xl mx-auto leading-relaxed font-light">
            KVTI provides a comprehensive AI-driven analysis of your visa suitability and career potential tailored for global talents.
          </p>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, scale: 0.95 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ delay: 0.4, duration: 0.5 }}
        >
          <button
            onClick={() => navigate('/diagnosis')}
            className="group relative inline-flex items-center justify-center px-10 py-5 text-lg font-bold text-kvti-bg transition-all duration-300 bg-kvti-primary rounded-none clip-path-slant focus:outline-none hover:bg-white hover:shadow-[0_0_40px_rgba(251,191,36,0.5)]"
            style={{ clipPath: 'polygon(10% 0, 100% 0, 100% 70%, 90% 100%, 0 100%, 0 30%)' }}
          >
            <span className="relative flex items-center gap-3">
              START ASSESSMENT
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor" className="w-5 h-5 transition-transform group-hover:translate-x-1">
                <path strokeLinecap="round" strokeLinejoin="round" d="M17.25 8.25L21 12m0 0l-3.75 3.75M21 12H3" />
              </svg>
            </span>
          </button>
        </motion.div>

        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 1, duration: 1 }}
          className="mt-20 grid grid-cols-3 gap-8 text-center border-t border-white/5 pt-10"
        >
          {[
            { label: "Diagnosis Time", value: "5 min" },
            { label: "Analysis Areas", value: "6 Sectors" },
            { label: "Visa Strategy", value: "AI Report" }
          ].map((item, idx) => (
            <div key={idx}>
              <div className="text-kvti-gold text-2xl md:text-3xl font-bold mb-1 font-display">{item.value}</div>
              <div className="text-slate-500 text-xs md:text-sm uppercase tracking-wider">{item.label}</div>
            </div>
          ))}
        </motion.div>
      </div>

      <footer className="absolute bottom-6 w-full text-center">
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
      </Routes>
    </Router>
  );
}

export default App;
