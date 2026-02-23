import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { FileText } from 'lucide-react';
import JobDetailModal from './JobDetailModal';
import AnalysisSummary from './AnalysisSummary';
import { E7_DB } from '../data/persona_data';
import { KVTI_DICTIONARY } from '../data/kvti_dictionary';
import TypeDictionaryModal from './TypeDictionaryModal';

/**
 * [기획 반영: Deficit Model 지양 & 긍정적 프레이밍]
 * 역량 점수가 낮거나 요건에 미달하더라도 부정적 피드백("취업 불가", "요건 미달")을 원천 차단합니다.
 * 수학적 척도(1~5점)를 긍정적인 '성장 단계(Milestone)' 언어로 치환하여 렌더링합니다.
 */


export default function DashboardTop({ reportData }) {
    const navigate = useNavigate();
    const [selectedJobCode, setSelectedJobCode] = useState(null);
    const [isExplanationModalOpen, setIsExplanationModalOpen] = useState(false);

    if (!reportData) return <div>분석 데이터를 불러오는 중입니다...</div>;

    const { dashboard } = reportData;

    // 백엔드 다중 추천 코드가 없을 경우를 대비한 Fallback (이전 단일 코드를 배열로 매핑)
    const recommendedJobs = dashboard.recommended_jobs || [
        { code: dashboard.job_code || "2742", title: E7_DB[dashboard.job_code]?.name_ko || "추천 직무 1순위", readiness: 85 },
        { code: "2733", title: E7_DB["2733"]?.name_ko || "광고 및 홍보 전문가", readiness: 70 },
        { code: "2731", title: E7_DB["2731"]?.name_ko || "상품 기획 전문가", readiness: 55 }
    ];

    const kvtiCode = dashboard.kvti_code || "MPHK";
    const kvtiBreakdown = dashboard.kvti_breakdown || [
        { char: "M", name: "제조업" },
        { char: "P", name: "실용/현장" },
        { char: "H", name: "대기업형" },
        { char: "K", name: "한국정주" },
    ];

    const e7Jobs = recommendedJobs.filter(job => !job.isExtraTrack);
    const extraTracks = recommendedJobs.filter(job => job.isExtraTrack);

    return (
        <section className="dashboard-top-container space-y-12">

            {/* --- 1. MBTI Style Hero Section --- */}
            <div className="relative overflow-hidden rounded-[2.5rem] bg-gradient-to-br from-[#1a1c29] via-[#222638] to-[#12131c] border border-white/10 shadow-2xl p-10 md:p-16 text-center">

                <div className="relative z-10 flex flex-col items-center justify-center">
                    <div className="flex items-center justify-center gap-3 mb-6 relative">
                        <p className="inline-block bg-white/10 px-6 py-2 rounded-full border border-white/20 text-cyan-400 tracking-widest text-sm font-bold uppercase shadow-lg backdrop-blur-sm m-0 flex space-x-2">
                            <span>✨</span>
                            <span className="text-white">{reportData.baseProfile?.name || 'Guest'}</span>
                            <span>님의 KVTI 유형</span>
                        </p>
                        <button
                            className="text-white/50 hover:text-white transition-colors group relative"
                            onClick={() => setIsExplanationModalOpen(true)}
                            title="KVTI에는 뭐가 있나요?"
                        >
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor" className="w-8 h-8">
                                <path strokeLinecap="round" strokeLinejoin="round" d="M9.879 7.519c1.171-1.025 3.071-1.025 4.242 0 1.172 1.025 1.172 2.687 0 3.712-.203.179-.43.326-.67.442-.745.361-1.45.999-1.45 1.827v.75M21 12a9 9 0 11-18 0 9 9 0 0118 0zm-9 5.25h.008v.008H12v-.008z" />
                            </svg>
                            {/* CSS Tooltip */}
                            <span className="absolute -top-10 left-1/2 -translate-x-1/2 w-max bg-slate-800 text-xs text-white px-3 py-1.5 rounded opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none shadow-lg border border-white/10 whitespace-nowrap z-50">
                                KVTI에는 뭐가 있나요?
                            </span>
                        </button>
                    </div>

                    {/* Huge 3 or 4-Letter Core Code */}
                    <div className="flex justify-center items-end gap-1 md:gap-4 mb-6">
                        {kvtiCode.split('').map((char, index) => {
                            let gradientClass = "";
                            if (index === 0) gradientClass = "from-pink-400 to-rose-600 drop-shadow-[0_5px_15px_rgba(244,63,94,0.5)]";
                            else if (index === 1) gradientClass = "from-cyan-400 to-blue-600 drop-shadow-[0_5px_15px_rgba(6,182,212,0.5)]";
                            else if (index === 2) gradientClass = "from-amber-300 to-orange-500 drop-shadow-[0_5px_15px_rgba(245,158,11,0.5)]";
                            else gradientClass = "from-emerald-300 to-teal-500 drop-shadow-[0_5px_15px_rgba(16,185,129,0.5)]";

                            return (
                                <span key={index} className={`text-8xl md:text-[9rem] font-black text-transparent bg-clip-text bg-gradient-to-b ${gradientClass} leading-none`}>
                                    {char}
                                </span>
                            );
                        })}
                    </div>

                    {/* Breakdown Badges (Core 3) */}
                    <div className="flex flex-wrap gap-3 justify-center mb-8 w-full max-w-2xl mx-auto">
                        {kvtiBreakdown.map((item, idx) => {
                            let displayName = item.name;
                            return (
                                <div key={idx} className="bg-white/5 border border-white/10 rounded-2xl px-5 py-3 flex items-center gap-3 shadow-sm backdrop-blur-sm hover:bg-white/10 transition-colors">
                                    <span className="text-white font-extrabold text-xl">{item.char}</span>
                                    <div className="w-px h-5 bg-white/20"></div>
                                    <span className="text-slate-300 font-medium whitespace-nowrap">{displayName}</span>
                                </div>
                            );
                        })}
                    </div>

                    {/* Subtitle (Nickname & Role) */}
                    {(() => {
                        const coreCode = kvtiCode.substring(0, 3);
                        const personaData = KVTI_DICTIONARY[coreCode] || KVTI_DICTIONARY[kvtiCode] || { nickname: "글로벌 혁신 인재", role: dashboard.persona_title };
                        const tags = dashboard.tags || [];

                        return (
                            <div className="flex flex-col items-center px-4 text-center mb-6 w-full">
                                <div className="inline-block px-8 py-3 rounded-full border border-pink-500/40 bg-pink-500/10 mb-5 shadow-[0_0_20px_rgba(236,72,153,0.3)] backdrop-blur-md">
                                    <span className="text-xl md:text-3xl font-black text-transparent bg-clip-text bg-gradient-to-r from-pink-400 via-purple-400 to-indigo-400 tracking-wide">
                                        {personaData.nickname}
                                    </span>
                                </div>
                                <p className="text-lg md:text-xl text-slate-400 italic font-light max-w-2xl mb-6">
                                    "{dashboard.characteristics || "한국 시장에서 성공을 이끌어갈 글로벌 인재"}"
                                </p>
                                {/* Dynamic Tags Rendering */}
                                {tags.length > 0 && (
                                    <div className="flex flex-wrap justify-center gap-2 mt-2">
                                        {tags.map((tag, i) => (
                                            <span key={i} className="text-sm font-bold text-blue-300 bg-blue-900/40 px-3 py-1 rounded-full border border-blue-500/30">
                                                {tag}
                                            </span>
                                        ))}
                                    </div>
                                )}
                            </div>
                        );
                    })()}

                    {/* --- NEW: Score Breakdown Visualizer (MBTI Style for Dashboard) --- */}
                    {dashboard.scoreBreakdown && (
                        <div className="mt-12 w-full max-w-4xl mx-auto px-4">
                            <h3 className="text-2xl font-black text-white mb-8 flex items-center justify-center gap-3">
                                <span className="text-3xl">📊</span> KVTI 세부 성향 스탯
                            </h3>
                            <div className="grid grid-cols-1 md:grid-cols-2 gap-6 md:gap-8">

                                {/* Axis 1: Industry */}
                                <div className="bg-slate-900/60 border border-white/10 p-6 rounded-3xl shadow-lg backdrop-blur-md">
                                    <div className="text-base font-bold text-slate-300 mb-6 flex items-center gap-2">
                                        <span className="text-xl">🏢</span> 타겟 산업군 (Industry)
                                    </div>
                                    <div className="space-y-4">
                                        {Object.entries(dashboard.scoreBreakdown.industry)
                                            .sort(([, a], [, b]) => b - a)
                                            .map(([key, val]) => (
                                                <div key={key} className="flex items-center gap-4 text-sm font-medium">
                                                    <span className="w-12 text-slate-400 text-right font-bold">{key}</span>
                                                    <div className="flex-1 h-4 bg-slate-950 rounded-full overflow-hidden flex items-center border border-white/5 shadow-inner">
                                                        <div
                                                            className={`h-full rounded-r-full ${key.charAt(0) === kvtiCode.charAt(0) ? 'bg-indigo-500 shadow-[0_0_12px_rgba(99,102,241,0.6)]' : 'bg-slate-700'}`}
                                                            style={{ width: `${Math.max(val, 2)}%` }}>
                                                        </div>
                                                    </div>
                                                    <span className={`w-12 text-right font-black ${key.charAt(0) === kvtiCode.charAt(0) ? 'text-indigo-400' : 'text-slate-500'}`}>{val}%</span>
                                                </div>
                                            ))}
                                    </div>
                                </div>

                                {/* Axis 2: Work Style */}
                                <div className="bg-slate-900/60 border border-white/10 p-6 rounded-3xl shadow-lg backdrop-blur-md">
                                    <div className="text-base font-bold text-slate-300 mb-6 flex items-center gap-2">
                                        <span className="text-xl">💼</span> 업무 스타일 (Work Style)
                                    </div>
                                    <div className="space-y-4">
                                        {Object.entries(dashboard.scoreBreakdown.style)
                                            .sort(([, a], [, b]) => b - a)
                                            .map(([key, val]) => {
                                                const labels = { 'A': '분석(A)', 'C': '창의(C)', 'P': '현장(P)', 'E': '리더(E)' };
                                                return (
                                                    <div key={key} className="flex items-center gap-4 text-sm font-medium">
                                                        <span className="w-14 text-slate-400 text-right font-bold">{labels[key]}</span>
                                                        <div className="flex-1 h-4 bg-slate-950 rounded-full overflow-hidden flex items-center border border-white/5 shadow-inner">
                                                            <div
                                                                className={`h-full rounded-r-full ${key === kvtiCode.charAt(1) ? 'bg-rose-500 shadow-[0_0_12px_rgba(244,63,94,0.6)]' : 'bg-slate-700'}`}
                                                                style={{ width: `${Math.max(val, 2)}%` }}>
                                                            </div>
                                                        </div>
                                                        <span className={`w-12 text-right font-black ${key === kvtiCode.charAt(1) ? 'text-rose-400' : 'text-slate-500'}`}>{val}%</span>
                                                    </div>
                                                )
                                            })}
                                    </div>
                                </div>

                                {/* Axis 3: Culture Fit */}
                                <div className="bg-slate-900/60 border border-white/10 p-6 rounded-3xl shadow-lg backdrop-blur-md">
                                    <div className="text-base font-bold text-slate-300 mb-6 flex items-center gap-2">
                                        <span className="text-xl">🤝</span> 조직 문화 (Culture Fit)
                                    </div>
                                    <div className="space-y-4">
                                        {Object.entries(dashboard.scoreBreakdown.culture).map(([key, val]) => {
                                            const labels = { 'H': '수직/대기업(H)', 'F': '수평/스타트업(F)' };
                                            return (
                                                <div key={key} className="flex items-center gap-4 text-sm font-medium">
                                                    <span className="w-28 text-slate-400 text-right font-bold">{labels[key]}</span>
                                                    <div className="flex-1 h-4 bg-slate-950 rounded-full overflow-hidden flex items-center border border-white/5 shadow-inner">
                                                        <div
                                                            className={`h-full rounded-r-full ${key === kvtiCode.charAt(2) ? 'bg-emerald-500 shadow-[0_0_12px_rgba(16,185,129,0.6)]' : 'bg-slate-700'}`}
                                                            style={{ width: `${Math.max(val, 2)}%` }}>
                                                        </div>
                                                    </div>
                                                    <span className={`w-12 text-right font-black ${key === kvtiCode.charAt(2) ? 'text-emerald-400' : 'text-slate-500'}`}>{val}%</span>
                                                </div>
                                            )
                                        })}
                                    </div>
                                </div>

                                {/* Axis 4: Residency Intent (NEW) */}
                                <div className="bg-slate-900/60 border border-white/10 p-6 rounded-3xl shadow-lg backdrop-blur-md">
                                    <div className="text-base font-bold text-slate-300 mb-6 flex items-center gap-2">
                                        <span className="text-xl">🌏</span> 정주 의지 (Residency)
                                    </div>
                                    <div className="space-y-4">
                                        {Object.entries(dashboard.scoreBreakdown.residency || { K: 50, G: 50 }).map(([key, val]) => {
                                            const labels = { 'K': '한국 정착(K)', 'G': '글로벌/귀국(G)' };
                                            return (
                                                <div key={key} className="flex items-center gap-4 text-sm font-medium">
                                                    <span className="w-28 text-slate-400 text-right font-bold">{labels[key]}</span>
                                                    <div className="flex-1 h-4 bg-slate-950 rounded-full overflow-hidden flex items-center border border-white/5 shadow-inner">
                                                        <div
                                                            className={`h-full rounded-r-full ${key === kvtiCode.charAt(3) ? 'bg-amber-400 shadow-[0_0_12px_rgba(251,191,36,0.6)]' : 'bg-slate-700'}`}
                                                            style={{ width: `${Math.max(val, 2)}%` }}>
                                                        </div>
                                                    </div>
                                                    <span className={`w-12 text-right font-black ${key === kvtiCode.charAt(3) ? 'text-amber-400' : 'text-slate-500'}`}>{val}%</span>
                                                </div>
                                            )
                                        })}
                                    </div>
                                </div>

                            </div>
                        </div>
                    )}
                </div>
            </div>

            {/* --- NEW: Phase 0. Base Profile (My Spec) Display --- */}
            {reportData.baseProfile && (
                <div className="card bg-slate-900/80 border border-white/10 p-6 md:p-8 rounded-3xl mt-8 shadow-xl backdrop-blur-md">
                    <h3 className="text-lg font-bold text-slate-300 mb-6 flex items-center gap-2">
                        <span className="text-xl">📊</span> 적용된 나의 기본 스펙 (Phase 0)
                    </h3>
                    <div className="grid grid-cols-2 md:grid-cols-5 gap-4">
                        <div className="bg-white/5 border border-white/5 p-4 rounded-xl hover:bg-white/10 transition-colors">
                            <span className="text-xs text-slate-500 font-bold uppercase tracking-widest block mb-1">전공 분야</span>
                            <span className="text-lg font-bold text-white">{reportData.baseProfile.major}</span>
                        </div>
                        <div className="bg-white/5 border border-white/5 p-4 rounded-xl hover:bg-white/10 transition-colors">
                            <span className="text-xs text-slate-500 font-bold uppercase tracking-widest block mb-1">출신 대학 / 학년</span>
                            <span className="text-lg font-bold text-white max-w-full truncate block" title={reportData.baseProfile.university}>{reportData.baseProfile.university}</span>
                            <span className="text-sm font-medium text-slate-400 block mt-0.5">{reportData.baseProfile.grade}</span>
                        </div>
                        <div className="bg-white/5 border border-white/5 p-4 rounded-xl hover:bg-white/10 transition-colors">
                            <span className="text-xs text-slate-500 font-bold uppercase tracking-widest block mb-1">한국어 능력(TOPIK)</span>
                            <span className="text-lg font-bold text-emerald-400">{reportData.baseProfile.topik ? `${reportData.baseProfile.topik}급` : "선택 안 함"}</span>
                        </div>
                        <div className="bg-white/5 border border-white/5 p-4 rounded-xl hover:bg-white/10 transition-colors">
                            <span className="text-xs text-slate-500 font-bold uppercase tracking-widest block mb-1">외국어 능력</span>
                            <span className="text-lg font-bold text-blue-400">
                                {reportData.baseProfile.secondaryLanguages && reportData.baseProfile.secondaryLanguages.length > 0
                                    ? reportData.baseProfile.secondaryLanguages.map(l => l.language).join(', ')
                                    : "해당 없음"}
                            </span>
                        </div>
                        <div className="bg-white/5 border border-white/5 p-4 rounded-xl hover:bg-white/10 transition-colors">
                            <span className="text-xs text-slate-500 font-bold uppercase tracking-widest block mb-1">사회통합프로그램</span>
                            <span className="text-lg font-bold text-teal-400">{reportData.baseProfile.kiip ? `${reportData.baseProfile.kiip}단계` : "해당 없음"}</span>
                        </div>
                    </div>
                </div>
            )}

            {/* --- 4. KVTI 종합 분석 리포트 요약본 (Moved up for UX flow) --- */}
            <AnalysisSummary reportData={reportData} />

            {/* --- 2. Multiple E-7 Code 추천 및 달성도 --- */}
            <div className="card bg-slate-800/60 border border-white/10 p-8 md:p-10 rounded-3xl backdrop-blur-md shadow-xl mt-12">
                <h2 className="text-2xl font-bold text-white mb-8 flex items-center gap-3">
                    <span className="text-3xl">🏆</span> KVTI 추천 직종 TOP 3
                </h2>
                <div className="space-y-6">
                    {e7Jobs.map((job, idx) => {
                        const jobData = E7_DB[job.code];
                        const jobName = jobData ? jobData.name_ko : job.title;
                        const medal = idx === 0 ? "🥇 1순위 타겟" : idx === 1 ? "🥈 2순위 대안" : idx === 2 ? "🥉 3순위 대안" : `🎯 ${idx + 1}순위 대안`;

                        return (
                            <div key={idx} className="bg-slate-900/50 border border-white/5 p-6 rounded-2xl hover:bg-white/10 transition-all flex flex-col items-start gap-4 group hover:border-kvti-primary/50 relative">
                                <div className="flex justify-between items-center w-full">
                                    <div className="flex items-center gap-3">
                                        <span className="max-md:text-xs text-sm font-bold px-3 py-1 bg-white/10 rounded-md text-slate-300">{medal}</span>
                                        <h3 className="text-lg md:text-xl font-bold text-white group-hover:text-kvti-primary transition-colors">{jobName} ({job.code})</h3>
                                    </div>
                                    <button
                                        onClick={() => setSelectedJobCode(job.code)}
                                        className="shrink-0 px-4 py-2 bg-kvti-primary/20 hover:bg-kvti-primary border border-kvti-primary/50 hover:border-kvti-primary rounded-xl font-bold text-sm text-white transition-all shadow-md group-hover:shadow-kvti-primary/20"
                                    >
                                        상세 ➔
                                    </button>
                                </div>
                                <div className="flex-1 w-full bg-slate-800/50 p-4 rounded-xl border border-white/5 relative">
                                    <div className="flex justify-between items-center mb-2">
                                        <div className="flex items-center gap-2 relative group-tooltip">
                                            <span className="text-sm font-medium text-slate-300">직무 성향 일치도 (Personality Fit)</span>
                                            {idx === 0 && dashboard.isMajorCompensated && (
                                                <span className="cursor-help bg-white/10 text-slate-300 w-5 h-5 rounded-full inline-flex items-center justify-center text-xs ml-1 hover:bg-white/20 transition-colors">ℹ</span>
                                            )}
                                        </div>
                                        <span className="text-kvti-primary font-black text-lg">{job.readiness}%</span>
                                    </div>
                                    <div className="h-3 bg-slate-900 rounded-full overflow-hidden w-full relative shadow-inner border border-white/5">
                                        <div
                                            className={`absolute top-0 left-0 h-full rounded-full bg-gradient-to-r ${idx === 0 ? 'from-green-400 to-emerald-600' : idx === 1 ? 'from-blue-400 to-indigo-600' : 'from-purple-400 to-pink-600'}`}
                                            style={{ width: `${job.readiness}%`, transition: 'width 1s ease-out' }}
                                        ></div>
                                    </div>
                                    {idx === 0 && dashboard.isMajorCompensated && (
                                        <p className="text-xs text-slate-400 mt-3 border-l-2 border-emerald-500 pl-2">
                                            * 뛰어난 실무 포트폴리오(Tech/OA) 능력으로 전공 매칭의 약점이 상쇄 적용되었습니다.
                                        </p>
                                    )}
                                </div>
                            </div>
                        );
                    })}
                </div>
            </div>

            {/* --- 3. Extra Tracks (Conditional rendering for D-8-4) --- */}
            {extraTracks.length > 0 && (
                <div className="card bg-gradient-to-br from-indigo-900/60 to-purple-900/40 border border-indigo-500/30 p-8 md:p-10 rounded-3xl backdrop-blur-md shadow-[0_0_30px_rgba(99,102,241,0.15)] mt-8 relative overflow-hidden">
                    <div className="absolute top-0 right-0 p-6 opacity-20 text-8xl transform translate-x-4 -translate-y-4">✨</div>
                    <div className="relative z-10">
                        <div className="inline-block px-4 py-1 rounded-full bg-yellow-400/20 border border-yellow-400/50 text-yellow-300 text-xs font-bold tracking-widest uppercase mb-4 shadow-[0_0_10px_rgba(250,204,21,0.3)]">
                            Special Feature
                        </div>
                        <h2 className="text-2xl font-black text-white mb-6">
                            숨겨진 재능: <span className="text-transparent bg-clip-text bg-gradient-to-r from-yellow-300 to-pink-400">프리미엄 트랙 발견!</span>
                        </h2>
                        <p className="text-indigo-200 text-sm mb-8">
                            일반적인 E-7 취업 경로 외에도, 귀하의 설문 응답(진취성 및 주도성)을 정밀 분석한 결과 다음과 같은 특별한 체류형 비자 트랙에 매우 높은 적성(80% 이상)을 보였습니다.
                        </p>

                        <div className="grid gap-6">
                            {extraTracks.map((job, idx) => (
                                <div key={`extra-${idx}`} className="bg-black/40 border border-indigo-400/30 p-6 rounded-2xl flex flex-col md:flex-row shadow-inner items-start gap-4 hover:bg-white/5 transition-all">
                                    <div className="flex-1 w-full">
                                        <div className="flex justify-between items-center mb-4">
                                            <h3 className="text-xl font-bold text-white flex items-center gap-2">
                                                🚀 기술 창업 (D-8-4)
                                            </h3>
                                            <button
                                                onClick={() => setSelectedJobCode(job.code)}
                                                className="px-4 py-2 border border-yellow-400/50 text-yellow-300 hover:bg-yellow-400/20 rounded-lg text-xs font-bold transition-all shadow-md backdrop-blur-sm"
                                            >
                                                전략 보기 ➔
                                            </button>
                                        </div>
                                        <div className="flex justify-between items-end">
                                            <span className="text-sm text-indigo-300">내재된 성공 잠재력 산출치</span>
                                            <span className="text-3xl font-black text-transparent bg-clip-text bg-gradient-to-r from-yellow-300 to-amber-500 drop-shadow-md">{job.readiness}%</span>
                                        </div>
                                    </div>
                                </div>
                            ))}
                        </div>
                    </div>
                </div>
            )}



            {/* Modal for Job Detail */}
            <JobDetailModal
                isOpen={!!selectedJobCode}
                jobCode={selectedJobCode}
                kvtiCode={kvtiCode}
                matchScore={recommendedJobs.find(job => job.code === selectedJobCode)?.readiness || 82}
                onClose={() => setSelectedJobCode(null)}
            />

            {/* Modal for KVTI Explanation */}
            {isExplanationModalOpen && (
                <TypeDictionaryModal onClose={() => setIsExplanationModalOpen(false)} />
            )}
            {/* Floating button to navigate to the full PDF-optimized Comprehensive Report */}
            <button
                onClick={() => navigate('/report', { state: { result: { dashboard: dashboard, reportData: reportData } } })}
                className="fixed bottom-8 right-8 z-50 flex items-center gap-3 bg-gradient-to-r from-emerald-500 to-teal-500 hover:from-emerald-400 hover:to-teal-400 text-white px-6 py-4 rounded-full shadow-[0_0_30px_rgba(16,185,129,0.4)] transition-all transform hover:scale-105 hover:-translate-y-1"
            >
                <div className="bg-white/20 p-2 rounded-full">
                    <FileText className="w-5 h-5" />
                </div>
                <div className="flex flex-col text-left">
                    <span className="text-[10px] font-bold tracking-widest uppercase text-emerald-100">Premium Feature</span>
                    <span className="font-bold tracking-wide text-sm">종합 분석 리포트 보기</span>
                </div>
            </button>
        </section>
    );
};
