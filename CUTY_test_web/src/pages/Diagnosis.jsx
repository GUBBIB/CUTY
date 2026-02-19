import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { motion, AnimatePresence } from 'framer-motion';
import kvtiQuestions from '../data/kvti_questions.json';
import { calculateKvtiResult } from '../utils/kvtiLogic';
import LikertScale from '../components/LikertScale';
import SectionIntro from '../components/SectionIntro';
import SectionGuideScreen from '../components/SectionGuideScreen';
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
    const [lang, setLang] = useState('ko'); // Default Language
    const t = TEXTS[lang].diagnosis;

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
                    const result = calculateKvtiResult(answers);
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
        // Mark all current section questions as "Neutral" (3) or specific "Skipped" value
        // For now, let's just bypass validation and move next? 
        // Strategy: Auto-fill '3' (Neutral) for all questions in this section to satisfy logic
        const updates = {};
        allSectionQuestions.forEach(q => {
            updates[q.id] = 3; // Neutral / No Preference
        });
        setAnswers(prev => ({ ...prev, ...updates }));

        // Move to next section logic (duplicate of handleNext part)
        if (currentSectionIdx < SECTIONS.length - 1) {
            setCurrentSectionIdx(prev => prev + 1);
            setCurrentPage(0);
            setShowGuide(true);
            window.scrollTo(0, 0);
        } else {
            // If it was last section (unlikely for skip), finish
            const result = calculateKvtiResult({ ...answers, ...updates });
            navigate('/result', { state: { result } });
        }
    };

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
                                ? 'bg-kvti-primary text-kvti-bg border-kvti-gold'
                                : 'bg-white/5 border-white/10 hover:bg-white/10 text-slate-300'
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
        <div className="min-h-screen bg-kvti-bg text-white flex flex-col items-center py-10 px-4 md:px-0">
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
                            {currentQuestions.map((q, idx) => {
                                return (
                                    <motion.div
                                        key={q.id}
                                        initial={{ opacity: 0, y: 20 }}
                                        animate={{ opacity: 1, y: 0 }}
                                        viewport={{ once: true }}
                                        className={`glass-card p-6 md:p-8 rounded-3xl transition-all duration-300 ${answers[q.id] ? 'border-kvti-primary/30 bg-kvti-primary/5' : ''
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
                            {/* Back Button (Optional but good for UX) */}
                            {(currentPage > 0 || currentSectionIdx > 0) && (
                                <button
                                    onClick={() => {
                                        if (currentPage > 0) setCurrentPage(prev => prev - 1);
                                        else if (currentSectionIdx > 0) {
                                            setCurrentSectionIdx(prev => prev - 1);
                                            // Ideally set page to last page of prev section, but 0 is safe MVP
                                            setCurrentPage(0);
                                            setShowGuide(true); // Show guide when going back to start of section
                                        }
                                        window.scrollTo(0, 0);
                                    }}
                                    className="px-8 py-4 rounded-full bg-white/5 text-slate-400 font-bold hover:bg-white/10 transition-colors"
                                >
                                    {t.buttons.prev}
                                </button>
                            )}

                            <button
                                onClick={handleNext}
                                className="px-12 py-4 rounded-full bg-gradient-to-r from-kvti-primary to-kvti-gold text-kvti-bg font-bold text-lg shadow-lg shadow-kvti-gold/20 hover:scale-105 transition-transform"
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
