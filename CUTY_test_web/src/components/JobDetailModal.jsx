// eslint-disable-next-line no-unused-vars
import { motion, AnimatePresence } from 'framer-motion';
import { X, Briefcase, FileCheck, CheckCircle2, Target, ScrollText, PercentSquare } from 'lucide-react';
import { E7_DB } from '../data/persona_data';
import { E7_DESCRIPTIONS } from '../data/e7_official_descriptions';
import { E7_REQUIREMENTS } from '../data/e7_requirements';

export default function JobDetailModal({ isOpen, onClose, jobCode, kvtiCode, matchScore = 85 }) {
    if (!isOpen) return null;

    // TODO: Replace with actual backend DB fetch in future phases.
    // For now, using dynamic mock data for demonstration based on user requirements.
    const jobData = E7_DB[jobCode];
    const officialNameText = jobData ? `${jobCode} ${jobData.name_ko}` : `${jobCode || "2351"} 기계공학 기술자`;

    // 1. Extract Official Job Code
    let extractedCode = jobCode;
    if (officialNameText.includes("숙련기능")) {
        extractedCode = "E-7-4";
    } else if (officialNameText) {
        const match = officialNameText.match(/[a-zA-Z0-9-]+/);
        if (match) extractedCode = match[0];
    }

    const officialDescription = E7_DESCRIPTIONS[extractedCode] || "대한민국 법무부 특정활동(E-7) 관련 규정에 따른 전문외국인력 직무입니다.";

    // Find matching requirement: exact match or partial match (e.g., 'S2855' for '2855')
    let reqKey = Object.keys(E7_REQUIREMENTS).find(k => k === extractedCode || k.includes(extractedCode));
    const reqs = E7_REQUIREMENTS[reqKey] || {
        education: "관련 분야 석사 이상, 또는 관련 전공 학사 + 1년 이상 경력",
        salary: "전년도 국민총소득(GNI)의 80% 이상",
        employer: "해당 전문 직무와 연관된 산업 분야의 유망 기업 및 연구기관",
        special: null
    };

    const data = {
        officialName: officialNameText,
        code: extractedCode,
        visaClass: "E-7-1 전문인력",
        officialDescription: officialDescription,
        requirements: {
            eduExp: reqs.education,
            wage: reqs.salary,
            employer: reqs.employer,
            special: reqs.special
        },
        fitAnalysis: {
            totalFit: matchScore,
            subFits: [
                { icon: '🔥', label: `직무 특성 적합도`, value: matchScore > 90 ? 92 : matchScore - 2, desc: `선택하신 직무와 회원님의 특성 성향 상호작용 지수 양호` },
                { label: `환경 유연성 일치도`, value: matchScore > 80 ? matchScore - 5 : matchScore, desc: "업무 환경 및 커뮤니케이션 방식에 대한 상호 기대치 부합" },
                { label: `산업 도메인 관심도`, value: matchScore - 8 > 60 ? matchScore - 8 : 65, desc: "관련 산업군에 대한 이해도와 기본 스킬 매칭 확률" }
            ]
        },
        quests: [
            "목표 설정: 한국어능력시험(TOPIK) 4급 취득 또는 사회통합프로그램(KIIP) 이수 시작하기",
            "전공 탐색: 이 직무와 관련된 전공 기초 과목 수강하고 학점 관리하기",
            "정보 수집: 교내 유학생 지원센터나 선배들을 통해 관련 인턴십/알바 경험담 들어보기"
        ]
    };

    return (
        <AnimatePresence>
            <motion.div
                className="fixed inset-0 z-[120] flex items-center justify-center p-4 sm:p-6 bg-black/80 backdrop-blur-sm"
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                exit={{ opacity: 0 }}
                onClick={onClose}
            >
                <motion.div
                    className="bg-slate-900 border border-white/10 rounded-3xl w-full max-w-3xl max-h-[90vh] flex flex-col overflow-hidden shadow-2xl relative"
                    initial={{ scale: 0.95, opacity: 0, y: 20 }}
                    animate={{ scale: 1, opacity: 1, y: 0 }}
                    exit={{ scale: 0.95, opacity: 0, y: 20 }}
                    transition={{ type: "spring", damping: 25, stiffness: 300 }}
                    onClick={e => e.stopPropagation()}
                >
                    {/* Header Controls */}
                    <button
                        onClick={onClose}
                        className="absolute top-4 sm:top-6 right-4 sm:right-6 text-slate-400 hover:text-white transition-colors bg-white/5 hover:bg-white/10 rounded-full p-2 z-10"
                    >
                        <X className="w-5 h-5 sm:w-6 sm:h-6" />
                    </button>

                    <div className="overflow-y-auto w-full custom-scrollbar">
                        <div className="p-6 sm:p-8 md:p-10 space-y-8">

                            {/* Section 1: Official E-7 Info */}
                            <section className="animate-in fade-in slide-in-from-bottom-4 duration-500 delay-100 fill-mode-both">
                                <div className="flex flex-wrap items-center gap-3 mb-4">
                                    <h2 className="text-2xl sm:text-3xl font-bold text-white tracking-tight">
                                        {data.officialName}
                                    </h2>
                                    <span className="px-3 py-1 bg-blue-500/20 text-blue-300 border border-blue-500/30 rounded-full text-sm font-semibold tracking-wide">
                                        {data.visaClass}
                                    </span>
                                </div>
                                <div className="bg-slate-800/50 border border-slate-700/50 rounded-2xl p-5">
                                    <h3 className="text-sm font-bold text-slate-400 uppercase tracking-wider mb-2 flex items-center gap-2">
                                        <Briefcase className="w-4 h-4" /> 법무부 직무 정의
                                    </h3>
                                    <p className="text-slate-300 leading-relaxed text-[15px] sm:text-base">
                                        {data.officialDescription}
                                    </p>
                                </div>
                            </section>

                            {/* Section 2: Visa Requirements */}
                            <section className="animate-in fade-in slide-in-from-bottom-4 duration-500 delay-200 fill-mode-both">
                                <h3 className="text-xl font-bold text-white mb-4 flex items-center gap-2">
                                    <FileCheck className="w-5 h-5 text-indigo-400" /> E-7-1 비자 주요 발급 요건
                                </h3>
                                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <div className="bg-slate-900 border border-slate-700 rounded-xl p-4 shadow-inner">
                                        <div className="text-xs text-indigo-400 font-bold mb-1 uppercase tracking-wider">학력 및 경력</div>
                                        <div className="text-slate-200 text-sm font-medium">{data.requirements.eduExp}</div>
                                    </div>
                                    <div className="bg-slate-900 border border-slate-700 rounded-xl p-4 shadow-inner">
                                        <div className="text-xs text-emerald-400 font-bold mb-1 uppercase tracking-wider">임금 조건 (GNI)</div>
                                        <div className="text-slate-200 text-sm font-medium">{data.requirements.wage}</div>
                                    </div>
                                    <div className="bg-slate-900 border border-slate-700 rounded-xl p-4 shadow-inner md:col-span-2">
                                        <div className="text-xs text-orange-400 font-bold mb-1 uppercase tracking-wider">예시 기업 분야</div>
                                        <div className="text-slate-200 text-sm font-medium">{data.requirements.employer}</div>
                                    </div>
                                    {data.requirements.special && (
                                        <div className="bg-slate-900 border border-slate-700/80 bg-rose-900/10 rounded-xl p-4 shadow-inner md:col-span-2">
                                            <div className="text-xs text-rose-400 font-bold mb-1 uppercase tracking-wider">특기사항 및 추천서 요건</div>
                                            <div className="text-slate-200 text-sm font-medium">{data.requirements.special}</div>
                                        </div>
                                    )}
                                </div>
                            </section>

                            {/* Section 3: Personality Fit Analysis */}
                            <section className="animate-in fade-in slide-in-from-bottom-4 duration-500 delay-300 fill-mode-both">
                                <h3 className="text-xl font-bold text-white mb-5 flex items-center gap-2">
                                    <PercentSquare className="w-5 h-5 text-pink-400" /> KVTI 성향 일치도 분석
                                </h3>
                                <div className="bg-gradient-to-br from-pink-500/10 to-purple-500/10 border border-pink-500/20 rounded-2xl p-6">
                                    <div className="flex flex-col sm:flex-row items-center gap-6 mb-8">
                                        {/* Total Fit Circular-ish Metric */}
                                        <div className="relative flex-shrink-0 flex items-center justify-center w-28 h-28 bg-slate-900 rounded-full border-4 border-slate-800 shadow-[0_0_20px_rgba(236,72,153,0.15)]">
                                            <svg className="absolute inset-0 w-full h-full transform -rotate-90">
                                                <circle
                                                    cx="50%" cy="50%" r="46%"
                                                    stroke="currentColor" strokeWidth="6"
                                                    fill="transparent"
                                                    className="text-slate-800"
                                                />
                                                <circle
                                                    cx="50%" cy="50%" r="46%"
                                                    stroke="currentColor" strokeWidth="6"
                                                    fill="transparent"
                                                    strokeDasharray={`${data.fitAnalysis.totalFit * 2.89} 300`} // Magic number for pseudo circle length
                                                    strokeLinecap="round"
                                                    className="text-pink-500 shadow-[0_0_10px_rgba(236,72,153,0.8)]"
                                                />
                                            </svg>
                                            <div className="flex flex-col items-center justify-center z-10 text-center">
                                                <span className="text-3xl font-black text-transparent bg-clip-text bg-gradient-to-b from-white to-pink-200 leading-none">
                                                    {data.fitAnalysis.totalFit}<span className="text-lg">%</span>
                                                </span>
                                                <span className="text-[10px] text-pink-300/80 font-bold uppercase tracking-widest mt-1">Match</span>
                                            </div>
                                        </div>

                                        <div className="flex-1 text-center sm:text-left">
                                            <h4 className="text-lg font-bold text-white mb-2">
                                                왜 이 직무가 <span className="text-pink-400">[{kvtiCode.substring(0, 3)}]</span> 성향과 찰떡일까요?
                                            </h4>
                                            <p className="text-slate-400 text-sm leading-relaxed">
                                                단순 스펙을 넘어, 회원님의 선천적인 업무 스타일 및 문제 해결 방식과 실제 현장에서 요구하는 기질이 얼마나 일치하는지 분석한 결과입니다.
                                            </p>
                                        </div>
                                    </div>

                                    {/* Sub Fits */}
                                    <div className="space-y-4">
                                        {data.fitAnalysis.subFits.map((fit, idx) => (
                                            <div key={idx} className="flex flex-col sm:flex-row gap-2 sm:gap-4 sm:items-center w-full">
                                                <div className="w-full sm:w-48 text-sm font-semibold text-slate-300 flex items-center gap-1.5 shrink-0">
                                                    {fit.icon && <span>{fit.icon}</span>}{fit.label}
                                                </div>
                                                <div className="flex-1">
                                                    <div className="h-2.5 w-full bg-slate-900/50 rounded-full overflow-hidden border border-white/5">
                                                        <motion.div
                                                            className="h-full bg-gradient-to-r from-purple-500 to-pink-500"
                                                            initial={{ width: 0 }}
                                                            animate={{ width: `${fit.value}%` }}
                                                            transition={{ duration: 1, delay: 0.5 + (idx * 0.1) }}
                                                        />
                                                    </div>
                                                </div>
                                                <div className="w-10 text-right text-sm font-bold text-pink-300 shrink-0">
                                                    {fit.value}%
                                                </div>
                                                <div className="hidden md:block w-56 text-xs text-slate-400 truncate pl-2 border-l border-white/10">
                                                    {fit.desc}
                                                </div>
                                            </div>
                                        ))}
                                    </div>
                                </div>
                            </section>

                        </div>
                    </div>
                </motion.div>
            </motion.div>
        </AnimatePresence>
    );
}
