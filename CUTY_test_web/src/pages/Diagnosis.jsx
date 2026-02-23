import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
// eslint-disable-next-line no-unused-vars
import { motion, AnimatePresence } from 'framer-motion';
import kvtiQuestions from '../data/kvti_questions.json';
import { calculateKvtiResult } from '../utils/kvtiLogic';
import LikertScale from '../components/LikertScale';
import SectionIntro from '../components/SectionIntro';
import SectionGuideScreen from '../components/SectionGuideScreen';
import BaseProfileForm from '../components/BaseProfileForm';
import { TEXTS } from '../data/locales';

// Defines the order and keys of sections
const SECTION_KEYS = [
    'part1_riasec',      // Step 1
    'part3_job_pref',    // Step 2
    'part4_industry_pref', // Step 3
    'part5_org_culture', // Step 4
    'part2_competency',  // Step 5
    'part6_residency'    // Step 6
];

const QUESTIONS_PER_PAGE = 5;

function Diagnosis() {
    const navigate = useNavigate();
    const [lang] = useState('ko'); // Default Language
    const t = TEXTS[lang].diagnosis;

    const [diagnosticGrade, setDiagnosticGrade] = useState(null); // 'junior' or 'senior'
    const [phase0Data, setPhase0Data] = useState(() => {
        const saved = localStorage.getItem('kvti_base_profile');
        return saved ? JSON.parse(saved) : null;
    });

    const [currentSectionIdx, setCurrentSectionIdx] = useState(0);
    const [currentPage, setCurrentPage] = useState(0);
    const [showGuide, setShowGuide] = useState(true);
    const [answers, setAnswers] = useState(() => {
        const saved = localStorage.getItem('kvti_answers');
        return saved ? JSON.parse(saved) : {};
    });

    // Dynamic Section Config based on Language and Order
    const SECTIONS = [
        { key: 'part1_riasec', ...t.steps.part1 },      // Part 1
        { key: 'part3_job_pref', ...t.steps.part2 },    // Part 2 (Job)
        { key: 'part4_industry_pref', ...t.steps.part3 },// Part 3 (Industry)
        { key: 'part5_org_culture', ...t.steps.part4 }, // Part 4 (Culture)
        { key: 'part2_competency', ...t.steps.part5 },  // Part 5 (Competency)
        { key: 'part6_residency', ...t.steps.part6 }    // Part 6 (Residency)
    ];

    const currentSection = SECTIONS[currentSectionIdx];
    const currentSectionKey = currentSection.key;
    const allRawQuestions = kvtiQuestions[currentSectionKey];

    // Filter Logic...
    const allSectionQuestions = allRawQuestions.filter(q => {
        if (!q) return false;
        const qToTest = q.question ? String(q.question) : "";
        const idToTest = q.id ? String(q.id) : "";
        const isHeader = idToTest === 'ID' || q.type === '코드'
            || qToTest.includes('문항')
            || /^[A-F]\.\s/.test(qToTest)
            || idToTest.includes('가이드')
            || idToTest.includes('척도')
            || idToTest.includes('로직')
            || idToTest.includes('UI')
            || qToTest.includes('개발자 가이드')
            || (q.question === null && q.type === 'select' && q.options && q.options.length === 0);
        return !isHeader;
    });

    const totalPages = Math.ceil(allSectionQuestions.length / QUESTIONS_PER_PAGE);
    const currentQuestions = allSectionQuestions.slice(
        currentPage * QUESTIONS_PER_PAGE,
        (currentPage + 1) * QUESTIONS_PER_PAGE
    );

    const progress = ((currentSectionIdx + ((currentPage + 1) / totalPages)) / SECTIONS.length) * 100;

    useEffect(() => {
        localStorage.setItem('kvti_answers', JSON.stringify(answers));
    }, [answers]);

    const handleAnswer = (qid, value) => {
        setAnswers(prev => ({ ...prev, [qid]: value }));
    };

    const handleNext = () => {
        const isComplete = currentQuestions.every(q => answers[q.id] !== undefined);
        if (!isComplete) {
            alert(lang === 'ko' ? "모든 문항에 답변해주세요." : "Please answer all questions.");
            return;
        }

        if (currentPage < totalPages - 1) {
            setCurrentPage(prev => prev + 1);
            window.scrollTo(0, 0);
        } else {
            if (currentSectionIdx < SECTIONS.length - 1) {
                setCurrentSectionIdx(prev => prev + 1);
                setCurrentPage(0);
                setShowGuide(true);
                window.scrollTo(0, 0);
            } else {
                try {
                    const result = calculateKvtiResult(answers, diagnosticGrade, phase0Data);
                    localStorage.removeItem('kvti_answers');
                    navigate('/result', { state: { result } });
                } catch (error) {
                    console.error("Error:", error);
                    alert("Error calculating result.");
                }
            }
        }
    };

    const handleSkipSection = () => {
        const updates = {};
        allSectionQuestions.forEach(q => {
            updates[q.id] = 3; // Neutral / No Preference Auto-fill
        });

        const newAnswers = { ...answers, ...updates };
        setAnswers(newAnswers);

        if (currentSectionIdx < SECTIONS.length - 1) {
            setCurrentSectionIdx(prev => prev + 1);
            setCurrentPage(0);
            setShowGuide(true);
            window.scrollTo(0, 0);
        } else {
            try {
                const result = calculateKvtiResult(newAnswers, diagnosticGrade, phase0Data);
                localStorage.removeItem('kvti_answers');
                navigate('/result', { state: { result } });
            } catch (error) {
                console.error("Error during calculation:", error);
                alert("Error calculating result.");
            }
        }
    };

    const handlePhase0Submit = (data) => {
        setPhase0Data(data);
        localStorage.setItem('kvti_base_profile', JSON.stringify(data));

        // Auto-route diagnostic grade based on selected grade
        if (data.grade === '1학년' || data.grade === '2학년') {
            setDiagnosticGrade('junior');
        } else {
            // Even if they are senior, the senior module is currently disabled.
            // For now, let them see the gateway so they know what's coming, or default to junior.
            // We'll just leave diagnosticGrade as null so they see the Gateway screen (and the lock).
        }
    };

    if (!phase0Data) {
        return <BaseProfileForm onSubmit={handlePhase0Submit} />;
    }

    // --- PHASE 3: Diagnosis Gateway (Junior vs Senior) ---
    if (!diagnosticGrade) {
        return (
            <div className="min-h-screen bg-kvti-bg text-white flex flex-col justify-center items-center p-6 relative overflow-hidden">
                {/* Background Details */}
                <div className="absolute top-1/4 -left-32 w-96 h-96 bg-blue-500/10 rounded-full blur-[100px]"></div>
                <div className="absolute bottom-1/4 -right-32 w-96 h-96 bg-purple-500/10 rounded-full blur-[100px]"></div>

                <div className="max-w-4xl w-full z-10">
                    <div className="text-center mb-16">
                        <span className="inline-block px-4 py-1 rounded-full bg-white/10 text-cyan-300 text-xs font-bold tracking-widest uppercase mb-4 border border-white/10 backdrop-blur-sm">Phase 2 Enabled</span>
                        <h1 className="text-4xl md:text-5xl font-black mb-6">KVTI 진단 모듈 선택</h1>
                        <p className="text-slate-400 text-lg md:text-xl max-w-2xl mx-auto">
                            KVTI 엔진이 완벽한 컨설팅을 제공하기 위해 귀하의 <span className="text-white font-bold">현재 단계</span>를 확인합니다. 정확한 렌즈를 선택해 주세요.
                        </p>
                    </div>

                    <div className="grid md:grid-cols-2 gap-8">
                        {/* Junior Card */}
                        <button
                            onClick={() => setDiagnosticGrade('junior')}
                            className="group relative bg-[#1a1c29] border border-blue-500/30 p-10 rounded-3xl hover:border-blue-400 transition-all hover:shadow-[0_0_40px_rgba(59,130,246,0.15)] hover:-translate-y-2 text-left"
                        >
                            <div className="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-blue-400 to-cyan-400 rounded-t-3xl opacity-50 group-hover:opacity-100 transition-opacity"></div>
                            <div className="w-16 h-16 bg-blue-500/10 rounded-2xl flex items-center justify-center mb-8 border border-blue-500/20 group-hover:scale-110 transition-transform">
                                <span className="text-3xl">🌱</span>
                            </div>
                            <h2 className="text-2xl font-black text-white mb-2">탐색형 모의고사</h2>
                            <p className="text-blue-400 font-bold mb-6">1~2학년 / 진로 탐색 중</p>
                            <p className="text-slate-400 leading-relaxed mb-8">
                                개인의 타고난 <strong className="text-slate-200">내재적 성향(Soft-spec)</strong>을 중심으로 잠재력을 발굴합니다. 어떤 산업군과 조직 문화가 어울리는지 큰 그림을 그려줍니다.
                            </p>
                            <div className="flex items-center text-sm font-bold text-blue-300 group-hover:text-blue-200">
                                진단 시작하기 <svg className="w-4 h-4 ml-2 group-hover:translate-x-2 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M14 5l7 7m0 0l-7 7m7-7H3" /></svg>
                            </div>
                        </button>

                        {/* Senior Card (Disabled for Phase 4) */}
                        <button
                            disabled
                            className="group relative bg-[#1a1c29]/50 border border-slate-700 p-10 rounded-3xl text-left cursor-not-allowed opacity-80 overflow-hidden"
                        >
                            <div className="absolute top-6 right-6 bg-rose-500 text-white text-xs font-bold px-3 py-1 rounded-full shadow-lg z-20 animate-pulse">Coming Phase 4</div>
                            <div className="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-slate-600 to-slate-500 rounded-t-3xl opacity-30"></div>
                            <div className="w-16 h-16 bg-slate-800 rounded-2xl flex items-center justify-center mb-8 border border-slate-700">
                                <span className="text-3xl grayscale opacity-50">⚔️</span>
                            </div>
                            <h2 className="text-2xl font-black text-slate-300 mb-2 flex items-center gap-3">
                                실전형 모의고사
                                <span className="text-xs bg-slate-800 px-2 py-1 rounded text-slate-400 border border-slate-600">개발 중</span>
                            </h2>
                            <p className="text-slate-500 font-bold mb-6">3~4학년 / 취업 준비생 (하드스펙 전용)</p>
                            <p className="text-slate-500 leading-relaxed mb-8">
                                GNI 80% 이상의 목표 연봉 달성률, 실무 포트폴리오 유무 등 증빙 가능한 스펙(Hard-spec)을 법무부 E-7 기준에 직대입하여 냉혹하게 판별합니다.
                            </p>
                            <div className="flex items-center text-sm font-bold text-slate-500">
                                하드스펙 전용 모듈 준비 중입니다 🔒
                            </div>
                        </button>
                    </div>
                </div>
            </div>
        );
    }

    if (showGuide) {
        return (
            <SectionGuideScreen
                title={currentSection.title}
                description={currentSection.description}
                guide={currentSection.guide}
                buttonText={t.buttons.start}
                skipText={(currentSectionKey === 'part4_industry_pref') ? t.buttons.skip : null}
                onStart={() => setShowGuide(false)}
                onSkip={(currentSectionKey === 'part4_industry_pref') ? handleSkipSection : undefined}
            />
        );
    }

    const renderQuestionInput = (q) => {
        if (q.options) {
            return (
                <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                    {q.options.map(opt => (
                        <button
                            key={opt.value}
                            onClick={() => handleAnswer(q.id, opt.value)}
                            className={`p-4 rounded-xl border text-left transition-all ${answers[q.id] === opt.value
                                ? 'bg-kvti-primary/10 text-kvti-primary border-kvti-primary/50 shadow-[0_0_10px_rgba(252,211,77,0.1)]'
                                : 'bg-white/5 border-white/5 hover:bg-white/10 text-zinc-400 hover:text-white'
                                }`}
                        >
                            {opt.label}
                        </button>
                    ))}
                </div>
            );
        } else {
            let customLabels = undefined;
            if (currentSectionKey === 'part2_competency') {
                customLabels = t.labels.competency;
            } else if (currentSectionKey === 'part3_job_pref' || currentSectionKey === 'part4_industry_pref') {
                customLabels = t.labels.interested;
            } else {
                customLabels = t.labels.agreement;
            }

            return (
                <LikertScale
                    selected={answers[q.id]}
                    onSelect={(val) => handleAnswer(q.id, val)}
                    labels={customLabels}
                />
            );
        }
    };

    return (
        <div className="theme-charcoal min-h-screen bg-kvti-bg text-white flex flex-col items-center py-10 px-4 md:px-0 transition-colors duration-500">
            <div className="w-full max-w-2xl">
                {/* Header Phase */}
                <div className="mb-10">
                    <div className="flex justify-between items-center mb-2 px-2">
                        <span className="text-kvti-primary font-bold tracking-widest text-sm uppercase">KVTI Assessment</span>
                        <div className="flex items-center gap-4">
                            <span className="text-slate-500 font-mono text-xs">
                                Sec {currentSectionIdx + 1}/{SECTIONS.length} • Pg {currentPage + 1}/{totalPages}
                            </span>
                            <button
                                onClick={() => {
                                    if (window.confirm("진단을 종료하고 첫 화면으로 돌아가시겠습니까?")) {
                                        navigate('/');
                                    }
                                }}
                                className="p-1 rounded-full hover:bg-white/10 text-slate-400 hover:text-white transition-colors"
                                title="Exit Diagnosis"
                            >
                                <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                                </svg>
                            </button>
                        </div>
                    </div>
                    <div className="w-full bg-white/5 h-1 rounded-full overflow-hidden">
                        <motion.div
                            className="h-full bg-kvti-primary"
                            initial={{ width: 0 }}
                            animate={{ width: `${progress}%` }}
                            transition={{ duration: 0.5 }}
                        />
                    </div>
                </div>

                <AnimatePresence mode='wait'>
                    <motion.div
                        key={`${currentSectionIdx}-${currentPage}`}
                        initial={{ opacity: 0, x: 20 }}
                        animate={{ opacity: 1, x: 0 }}
                        exit={{ opacity: 0, x: -20 }}
                        transition={{ duration: 0.3 }}
                    >
                        <SectionIntro
                            title={SECTIONS[currentSectionIdx].title}
                            description={SECTIONS[currentSectionIdx].description}
                            guide={SECTIONS[currentSectionIdx].guide}
                            isActive={true}
                        />

                        <div className="space-y-6">
                            {currentQuestions.map((q) => {
                                return (
                                    <motion.div
                                        key={q.id}
                                        initial={{ opacity: 0, y: 20 }}
                                        animate={{ opacity: 1, y: 0 }}
                                        viewport={{ once: true }}
                                        className={`glass-card p-6 md:p-8 rounded-3xl transition-all duration-300 ${answers[q.id] ? 'border-kvti-primary/40 bg-kvti-primary/5 shadow-[0_4px_24px_rgba(0,0,0,0.5)]' : ''
                                            }`}
                                    >
                                        <div className="mb-6 flex flex-col md:flex-row md:items-center gap-4">
                                            <h3 className="text-lg md:text-xl font-medium text-gray-100 leading-snug flex-1">
                                                {q.question || q.id}
                                            </h3>
                                            {answers[q.id] && (
                                                <div className="text-kvti-primary text-sm font-bold flex items-center gap-1">
                                                    <span className="w-2 h-2 rounded-full bg-kvti-primary"></span>
                                                    Checked
                                                </div>
                                            )}
                                        </div>
                                        {renderQuestionInput(q)}
                                    </motion.div>
                                );
                            })}
                        </div>

                        <div className="mt-12 mb-20 flex justify-center gap-4">
                            {/* Back Button */}
                            {(currentPage > 0 || currentSectionIdx > 0) && (
                                <button
                                    onClick={() => {
                                        if (currentPage > 0) setCurrentPage(prev => prev - 1);
                                        else if (currentSectionIdx > 0) {
                                            setCurrentSectionIdx(prev => prev - 1);
                                            setCurrentPage(0); // Ideally set to last page of prev section, kept as 0 for MVP
                                            setShowGuide(true);
                                        }
                                        window.scrollTo({ top: 0, behavior: 'smooth' });
                                    }}
                                    className="px-8 py-4 rounded-full bg-white/5 text-slate-400 font-bold hover:bg-white/10 transition-colors"
                                >
                                    {t.buttons.prev}
                                </button>
                            )}

                            <button
                                onClick={handleNext}
                                className="px-12 py-4 rounded-full bg-gradient-to-r from-amber-400 to-orange-500 text-zinc-900 font-bold text-lg shadow-lg shadow-amber-500/20 hover:scale-105 transition-transform"
                            >
                                {(currentPage < totalPages - 1)
                                    ? t.buttons.next
                                    : (currentSectionIdx < SECTIONS.length - 1 ? t.buttons.next : t.buttons.submit)}
                            </button>
                        </div>
                    </motion.div>
                </AnimatePresence>
            </div>
        </div>
    );
}

export default Diagnosis;
