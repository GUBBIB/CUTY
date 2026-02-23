import React, { useEffect } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { Printer, ArrowLeft, Bookmark, Target, Briefcase, FileCheck, CheckCircle2, ClipboardList } from 'lucide-react';
import { generateReportData } from '../utils/reportGenerator';
import kvtiQuestions from '../data/kvti_questions.json';

export default function ComprehensiveReport() {
    const navigate = useNavigate();
    const location = useLocation();

    // Use state to hold the report hash to avoid impure render warnings
    const [reportHash] = React.useState(() => {
        return `KVTI-RPT-${new Date().getFullYear()}-${Math.floor(Math.random() * 10000).toString().padStart(4, '0')}`;
    });

    // Parse dynamic KVTI code from previous screen state
    let currentResultCode = "BAF"; // Fallback Test Seed
    const passedState = location.state?.result;

    if (passedState) {
        // Handle variations in how the state was passed (DashboardTop vs AnalysisSummary)
        const dashboardInfo = passedState.dashboard || passedState?.reportData?.dashboard;
        if (dashboardInfo && dashboardInfo.kvti_code) {
            currentResultCode = dashboardInfo.kvti_code.substring(0, 3);
        }
    }

    const reportData = generateReportData(currentResultCode);

    // Prioritize passedState data, fallback to localStorage
    const rawAnswers = passedState?.reportData?.raw_answers || passedState?.raw_answers || JSON.parse(localStorage.getItem('kvti_answers') || '{}');

    // Scroll to top on load
    useEffect(() => {
        window.scrollTo(0, 0);
    }, []);

    const handlePrint = () => {
        window.print();
    };

    return (
        <div className="min-h-screen bg-slate-50 text-slate-900 pb-32 font-serif selection:bg-indigo-200">

            {/* Top Navigation Bar - Hidden on print */}
            <nav className="fixed top-0 left-0 right-0 z-50 bg-white/90 backdrop-blur-md border-b border-slate-200 px-4 sm:px-6 py-4 flex justify-between items-center print-hidden transition-all duration-300 shadow-sm">
                <button
                    onClick={() => navigate(-1)}
                    className="flex items-center gap-2 text-slate-600 hover:text-slate-900 transition-colors bg-slate-100 hover:bg-slate-200 px-4 py-2 rounded-full text-sm font-medium font-sans"
                >
                    <ArrowLeft className="w-4 h-4" /> 뒤로 가기
                </button>
                <div className="text-slate-800 font-bold tracking-widest flex items-center gap-2 font-sans">
                    <div className="w-2 h-2 rounded-full bg-kvti-primary animate-pulse"></div>
                    KVTI COMPREHENSIVE DOSSIER
                </div>
            </nav>

            {/* Floating Print Button - Hidden on print */}
            <button
                onClick={handlePrint}
                className="fixed bottom-8 right-8 z-50 flex items-center gap-2 bg-slate-900 hover:bg-slate-800 text-white px-6 py-4 rounded-full shadow-2xl transition-all transform hover:scale-105 print-hidden print:hidden font-sans"
            >
                <Printer className="w-5 h-5" />
                <span className="font-bold tracking-wide">리포트 다운로드 (PDF)</span>
            </button>

            {/* Main Report Container - Styled to look like a physical document */}
            <main className="pt-32 px-4 sm:px-12 md:px-24 max-w-4xl mx-auto space-y-24 bg-white shadow-[0_0_50px_rgba(0,0,0,0.05)] print:shadow-none print:pt-0">

                {/* ==========================================
                    Document Header Profile
                ========================================== */}
                <div className="border-b-4 border-slate-900 pb-12 mb-16">
                    <p className="text-sm font-bold tracking-[0.3em] text-slate-500 uppercase mb-4 font-sans">
                        Confidential Assessment Report
                    </p>
                    <h1 className="text-4xl md:text-5xl lg:text-6xl font-black text-slate-900 mb-8 leading-tight tracking-tight mt-6">
                        KVTI 심층 커리어<br />
                        진단 결과 보고서
                    </h1>

                    <div className="flex flex-col md:flex-row gap-8 justify-between items-start mt-12 bg-slate-100 p-8 rounded-lg">
                        <div className="space-y-4 font-sans focus:outline-none">
                            <div className="flex items-center gap-4">
                                <span className="text-sm font-bold text-slate-500 uppercase tracking-widest w-24">발급 번호</span>
                                <span className="font-mono text-slate-900 font-bold">{reportHash}</span>
                            </div>
                            <div className="flex items-center gap-4">
                                <span className="text-sm font-bold text-slate-500 uppercase tracking-widest w-24">진단 결과</span>
                                <span className="text-lg font-black text-indigo-700 tracking-widest">{reportData.kvtiCode}</span>
                            </div>
                            <div className="flex items-center gap-4">
                                <span className="text-sm font-bold text-slate-500 uppercase tracking-widest w-24">지원자 특성</span>
                                <span className="text-base font-bold text-slate-800">{reportData.personaTitle}</span>
                            </div>
                        </div>
                        <div className="text-right">
                            <img src="/assets/logo/cuty_logo_dark.svg" alt="CUTY" className="h-8 opacity-50 mb-2 grayscale" />
                            <p className="text-xs text-slate-500 uppercase tracking-widest font-sans font-bold mt-2">Global Career Center</p>
                        </div>
                    </div>
                </div>

                {/* ==========================================
                    Score Breakdown Visualizer (MBTI Style)
                ========================================== */}
                {passedState?.dashboard?.scoreBreakdown && (
                    <section className="space-y-6 mb-16 page-break-avoid">
                        <h3 className="text-xl font-bold text-slate-900 mb-6 font-sans">
                            KVTI 유형 도출 세부 스탯 (Score Breakdown)
                        </h3>
                        <div className="bg-slate-50 border border-slate-200 p-6 md:p-8 rounded-xl font-sans space-y-8">

                            <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
                                {/* Axis 1: Industry */}
                                <div className="bg-white border border-slate-200 p-5 rounded-2xl shadow-sm">
                                    <div className="text-sm font-bold text-slate-600 mb-4 text-left">타겟 산업군 (Industry)</div>
                                    <div className="space-y-3">
                                        {Object.entries(passedState.dashboard.scoreBreakdown.industry)
                                            .sort(([, a], [, b]) => b - a)
                                            .map(([key, val]) => (
                                                <div key={key} className="flex items-center gap-3 text-sm font-medium">
                                                    <span className="w-10 text-slate-500 text-right">{key}</span>
                                                    <div className="flex-1 h-3 bg-slate-100 rounded-full overflow-hidden flex items-center border border-slate-200">
                                                        <div
                                                            className={`h-full ${key.charAt(0) === reportData.kvtiCode.charAt(0) ? 'bg-indigo-600' : 'bg-slate-400'}`}
                                                            style={{ width: `${Math.max(val, 2)}%` }}>
                                                        </div>
                                                    </div>
                                                    <span className="w-10 text-right text-slate-700 font-bold">{val}%</span>
                                                </div>
                                            ))}
                                    </div>
                                </div>

                                {/* Axis 2: Work Style */}
                                <div className="bg-white border border-slate-200 p-5 rounded-2xl shadow-sm">
                                    <div className="text-sm font-bold text-slate-600 mb-4 text-left">업무 스타일 (Work Style)</div>
                                    <div className="space-y-3">
                                        {Object.entries(passedState.dashboard.scoreBreakdown.style)
                                            .sort(([, a], [, b]) => b - a)
                                            .map(([key, val]) => {
                                                const labels = { 'A': '분석(A)', 'C': '창의(C)', 'P': '현장(P)', 'E': '리더(E)' };
                                                return (
                                                    <div key={key} className="flex items-center gap-3 text-sm font-medium">
                                                        <span className="w-14 text-slate-500 text-right">{labels[key]}</span>
                                                        <div className="flex-1 h-3 bg-slate-100 rounded-full overflow-hidden flex items-center border border-slate-200">
                                                            <div
                                                                className={`h-full ${key === reportData.kvtiCode.charAt(1) ? 'bg-rose-500' : 'bg-slate-400'}`}
                                                                style={{ width: `${Math.max(val, 2)}%` }}>
                                                            </div>
                                                        </div>
                                                        <span className="w-10 text-right text-slate-700 font-bold">{val}%</span>
                                                    </div>
                                                )
                                            })}
                                    </div>
                                </div>

                                {/* Axis 3: Culture Fit */}
                                <div className="bg-white border border-slate-200 p-5 rounded-2xl shadow-sm">
                                    <div className="text-sm font-bold text-slate-600 mb-4 text-left">조직 문화 (Culture Fit)</div>
                                    <div className="space-y-3">
                                        {Object.entries(passedState.dashboard.scoreBreakdown.culture).map(([key, val]) => {
                                            const labels = { 'H': '수직(H)', 'F': '수평(F)' };
                                            return (
                                                <div key={key} className="flex items-center gap-3 text-sm font-medium">
                                                    <span className="w-14 text-slate-500 text-right">{labels[key]}</span>
                                                    <div className="flex-1 h-3 bg-slate-100 rounded-full overflow-hidden flex items-center border border-slate-200">
                                                        <div
                                                            className={`h-full ${key === reportData.kvtiCode.charAt(2) ? 'bg-emerald-500' : 'bg-slate-400'}`}
                                                            style={{ width: `${Math.max(val, 2)}%` }}>
                                                        </div>
                                                    </div>
                                                    <span className="w-10 text-right text-slate-700 font-bold">{val}%</span>
                                                </div>
                                            )
                                        })}
                                    </div>
                                </div>

                                {/* Axis 4: Residency Intent (NEW) */}
                                <div className="bg-white border border-slate-200 p-5 rounded-2xl shadow-sm">
                                    <div className="text-sm font-bold text-slate-600 mb-4 text-left">정주 의지 (Residency)</div>
                                    <div className="space-y-3">
                                        {Object.entries(passedState.dashboard.scoreBreakdown.residency || { K: 50, G: 50 }).map(([key, val]) => {
                                            const labels = { 'K': '정착(K)', 'G': '귀국(G)' };
                                            return (
                                                <div key={key} className="flex items-center gap-3 text-sm font-medium">
                                                    <span className="w-14 text-slate-500 text-right">{labels[key]}</span>
                                                    <div className="flex-1 h-3 bg-slate-100 rounded-full overflow-hidden flex items-center border border-slate-200">
                                                        <div
                                                            className={`h-full ${key === reportData.kvtiCode.charAt(3) ? 'bg-amber-500' : 'bg-slate-400'}`}
                                                            style={{ width: `${Math.max(val, 2)}%` }}>
                                                        </div>
                                                    </div>
                                                    <span className="w-10 text-right text-slate-700 font-bold">{val}%</span>
                                                </div>
                                            )
                                        })}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>
                )}

                {/* ==========================================
                    Section 1: KVTI Introduction
                ========================================== */}
                <section className="space-y-8 leading-loose text-lg text-slate-800">
                    <h2 className="text-2xl font-black text-slate-900 border-l-4 border-indigo-600 pl-4 mb-8 font-sans">
                        I. 서론: 대한민국 유학생 커리어 생존 지표
                    </h2>
                    <p className="indent-8 text-justify">
                        KVTI(Korea Visa Type Indicator) 분석 모델은 대한민국 법무부 출입국·외국인정책본부의 특정활동(E-7) 사증 발급 매뉴얼과 최신 한국 노동 시장의 트렌드 데이터를 기반으로 설계된 초정밀 커리어 진단 시스템입니다. 본 시스템은 단순한 성향 테스트의 범주를 넘어섭니다. 외국인 유학생이 한국 사회에서 합법적이고 안정적으로 정착하기 위해 필수적으로 요구되는 핵심 진단 지표(산업 적합도, 직무 성향, 조직 문화 융화력 등)를 다각도에서 교차 검증하여, 개인에게 가장 확률이 높은 생존 전략을 도출합니다.
                    </p>
                    <p className="indent-8 text-justify">
                        본 진단 보고서는 지원자의 잠재력을 극대화할 수 있는 32개 세분화된 페르소나 중 하나를 매칭하고, 이를 바탕으로 E-7 비자 취득에 가장 유리한 직무군을 추천합니다. 이 보고서에 담긴 분석과 추천 로드맵은 귀하가 한국이라는 한정된 자원과 치열한 경쟁 속에서 어떻게 자신만의 고유한 무기를 활용할 수 있을지에 대한 가장 현실적인 해답이 될 것입니다.
                    </p>
                </section>

                {/* ==========================================
                    Section 2: Deep Dive User Analysis
                ========================================== */}
                <section className="space-y-12 leading-loose text-lg text-slate-800 page-break-before">
                    <h2 className="text-2xl font-black text-slate-900 border-l-4 border-indigo-600 pl-4 mb-12 font-sans">
                        II. 지원자(Applicant) 심층 성향 분석
                    </h2>

                    <div className="bg-slate-50 border border-slate-200 p-8 md:p-12 mb-12">
                        <h3 className="text-xl font-bold text-indigo-800 mb-6 font-sans flex items-center gap-3">
                            <Bookmark className="w-6 h-6 shrink-0" /> 심층 성향 종합 소견
                        </h3>
                        {/* Dynamically generated summary prose from backend-prep logic */}
                        <p className="text-slate-800 font-medium leading-loose text-justify">
                            {reportData.summaryText}
                        </p>
                    </div>

                    <h3 className="text-xl font-bold text-slate-900 mb-6 font-sans">
                        세부 지표(Factor) 분해능 해석
                    </h3>

                    <div className="space-y-10">
                        {reportData.factorDetails.map((factor, idx) => (
                            <div key={idx} className="border-b border-slate-200 pb-8 last:border-0">
                                <h4 className="flex items-baseline gap-3 text-lg font-bold text-slate-900 mb-4 font-sans">
                                    <span className="text-3xl font-black text-indigo-600">{factor.letter}</span>
                                    <span>{factor.axisName}: <span className="text-indigo-700">[{factor.title}]</span>형</span>
                                </h4>
                                <p className="indent-4 text-justify leading-relaxed">
                                    {factor.description}
                                </p>
                            </div>
                        ))}
                    </div>
                </section>

                {/* ==========================================
                    Section 3: Job & Visa Details
                ========================================== */}
                <section className="space-y-16 leading-loose text-lg text-slate-800 page-break-before">
                    <h2 className="text-2xl font-black text-slate-900 border-l-4 border-indigo-600 pl-4 mb-16 font-sans">
                        III. 매칭 완료: 타겟 E-7 직무 및 비자 취득 가이드
                    </h2>

                    <p className="text-justify mb-16">
                        앞서 진행된 성향 분석과 현행 출입국 심사 규정을 알고리즘으로 매칭하여, 비자 승인 확률(% Readiness)이 가장 높은 상위 3개의 전략적 접근 직군을 도출하였습니다. 아래 각 항목은 해당 직군을 획득하기 위해 요구되는 <strong>법무부의 공식 사증 심사 기준</strong>과 현업 실무진이 요구하는 <strong>실전 코어 역량</strong>을 문서화한 것입니다.
                    </p>

                    <div className="space-y-24">
                        {reportData.topJobs.map((job, idx) => (
                            <div key={idx} className="relative">

                                {/* Subheader Title */}
                                <div className="mb-10 font-sans">
                                    <div className="flex items-center gap-4 mb-4">
                                        {idx === 0 && (
                                            <span className="bg-indigo-600 text-white font-bold px-4 py-1 text-sm tracking-wider uppercase">
                                                1순위 최우선 타겟 직무
                                            </span>
                                        )}
                                        <span className="text-indigo-700 font-bold border border-indigo-300 px-3 py-1 text-sm bg-indigo-50">
                                            {job.visaType} (Code {job.code})
                                        </span>
                                        <span className="text-slate-500 font-bold px-3 py-1 text-sm bg-slate-100 hidden sm:inline-block">
                                            KVTI 적합도 {job.readiness}%
                                        </span>
                                    </div>
                                    <h3 className="text-3xl font-black text-slate-900 leading-tight">
                                        {idx + 1}. {job.title_ko}
                                        {job.title_en && (
                                            <span className="block text-xl font-normal text-slate-500 mt-2 font-serif">{job.title_en}</span>
                                        )}
                                    </h3>
                                </div>

                                {/* Text Body */}
                                <div className="space-y-8">
                                    <div>
                                        <h4 className="text-lg font-bold text-slate-900 mb-3 flex items-center gap-2 font-sans">
                                            <Briefcase className="w-5 h-5 text-indigo-600" /> [1] 특정활동({job.visaType.split(' ')[0]}) 분야 직무 정의
                                        </h4>
                                        <p className="indent-4 text-justify bg-slate-50 p-6 border-l-2 border-slate-300 font-medium">
                                            {job.lawDefinition}
                                        </p>
                                    </div>

                                    <div>
                                        <h4 className="text-lg font-bold text-slate-900 mb-3 flex items-center gap-2 font-sans mt-10">
                                            <FileCheck className="w-5 h-5 text-indigo-600" /> [2] 출입국관리법 심사 및 발급 요건 제한
                                        </h4>
                                        <ul className="list-disc pl-8 space-y-4 text-justify marker:text-indigo-600">
                                            <li>
                                                <strong>학위 및 전공 특례 요구사항:</strong> {job.visaRequirements.education}
                                            </li>
                                            <li>
                                                <strong>안심 임금 수준 제약(GNI 연동):</strong> {job.visaRequirements.salary}
                                            </li>
                                            <li>
                                                <strong>고용 기업의 국민고용보호 심사 장벽:</strong> {job.visaRequirements.employer}
                                            </li>
                                        </ul>
                                    </div>

                                    <div>
                                        <h4 className="text-lg font-bold text-slate-900 mb-3 flex items-center gap-2 font-sans mt-10">
                                            <Target className="w-5 h-5 text-indigo-600" /> [3] 실무 투입을 위한 전략적 핵심 역량 (Core Competency)
                                        </h4>
                                        <ul className="mb-4 space-y-6">
                                            {job.requiredCompetencies.map((reqTxt, i) => (
                                                <li key={i} className="flex items-start gap-4">
                                                    <CheckCircle2 className="w-6 h-6 text-emerald-600 shrink-0 mt-1" />
                                                    <div className="text-justify font-sans">
                                                        {reqTxt}
                                                    </div>
                                                </li>
                                            ))}
                                        </ul>
                                    </div>
                                </div>

                                {idx !== reportData.topJobs.length - 1 && (
                                    <div className="w-full text-center my-16 opacity-30">
                                        * * * * *
                                    </div>
                                )}
                            </div>
                        ))}
                    </div>
                </section>

                {/* ==========================================
                    Section 4: Growth Roadmap (Extensive Text)
                ========================================== */}
                <section className="space-y-8 leading-loose text-lg text-slate-800 page-break-before pb-24">
                    <h2 className="text-2xl font-black text-slate-900 border-l-4 border-indigo-600 pl-4 mb-12 font-sans">
                        IV. 결론 및 향후 과제: 주도적 커리어 로드맵 수립
                    </h2>

                    <p className="indent-8 text-justify">
                        본 진단 보고서에서 제시한 전략과 직무 추천은 성공을 위한 첫 번째 청사진(Blueprint)에 불과합니다. 취업과 비자 취득이라는 최종 목표를 달성하기 위해서는 규정된 법적 요건과 자신의 개인적 성향을 완벽하게 융합시키는 집중화된 커리어 스펙 구축이 최우선되어야 합니다.
                    </p>

                    <p className="indent-8 text-justify mt-6">
                        당사는 귀하의 성공적인 정착을 지원하기 위하여, 본 진단 결과를 토대로 한 <strong>'개인 맞춤형 시계열 로드맵 구축 시스템(Comprehensive Timeline Builder)'</strong>을 향후 정비하여 제공할 예정입니다. 1학년 1학기부터 상시 퀘스트 기반으로 제공될 이 시스템을 통해 체계적인 한국 생활 설계를 완성하시기 바랍니다.
                    </p>

                    <div className="mt-24 pt-12 border-t border-slate-300 text-center font-sans">
                        <p className="text-xl font-bold text-slate-900 mb-2">KVTI AI Analysis Engine</p>
                        <p className="text-slate-500 uppercase tracking-widest text-sm mb-8">End of Assessment Report</p>

                        <div className="inline-block p-4 border-4 border-double border-slate-300">
                            <span className="font-serif italic text-2xl font-bold text-slate-400">Verified Confidential</span>
                        </div>
                    </div>
                </section>

                {/* ==========================================
                    Section 5: Appendix: Questionnaire Responses
                ========================================== */}
                <section className="space-y-8 leading-loose text-lg text-slate-800 page-break-before pb-32">
                    <h2 className="text-2xl font-black text-slate-900 border-l-4 border-indigo-600 pl-4 mb-8 font-sans flex items-center gap-3">
                        <ClipboardList className="w-8 h-8 text-indigo-600" />
                        부록: 심층 진단 원본 응답 데이터 (Appendix)
                    </h2>
                    <p className="text-justify mb-8 text-base">
                        본 종합 진단 결과는 지원자가 입력한 아래의 설문 데이터를 기초로 도출되었습니다. 각 문항에 대한 응답은 E-7 비자 적합도 및 최적 직무 매칭 알고리즘의 핵심 변수로 활용되었습니다.
                    </p>

                    <div className="space-y-12">
                        {Object.entries(kvtiQuestions).map(([sectionKey, questions]) => {
                            const sectionTitles = {
                                part1_riasec: "1. 직무 성향 및 흥미 (RIASEC)",
                                part2_competency: "2. 핵심 역량 및 준비도 (Competency)",
                                part3_job_pref: "3. 선호 직무 분류 (Job Preference)",
                                part4_industry_pref: "4. 선호 산업 분야 (Industry Preference)",
                                part5_org_culture: "5. 조직 문화 적합성 (Organizational Culture)",
                                part6_residency: "6. 한국 정주 의지 및 정착 계획 (Residency)"
                            };

                            const validQuestions = questions.filter(q => q && q.id && q.id !== "ID" && q.type !== "코드" && !q.question?.includes("개발자 가이드") && !(q.question === null && q.type === 'select'));

                            if (validQuestions.length === 0) return null;

                            return (
                                <div key={sectionKey} className="bg-slate-50 border border-slate-200 rounded-2xl p-6 md:p-8 shrink-inside-avoid">
                                    <h3 className="text-[1.1rem] font-bold text-indigo-900 mb-6 font-sans border-b border-indigo-100 pb-3">
                                        {sectionTitles[sectionKey] || sectionKey}
                                    </h3>
                                    <div className="space-y-2">
                                        {validQuestions.map((q, qIdx) => {
                                            const ansValue = rawAnswers[q.id];
                                            let displayAnswer = "미응답";
                                            let answerClass = "text-slate-400 font-normal";

                                            if (ansValue !== undefined) {
                                                if (q.options && q.options.length > 0) {
                                                    const selectedOpt = q.options.find(opt => String(opt.value) === String(ansValue));
                                                    displayAnswer = selectedOpt ? selectedOpt.label : ansValue;
                                                    answerClass = "text-indigo-700 font-bold bg-indigo-100/50 px-3 py-1 rounded-md text-sm";
                                                } else {
                                                    // Likert scale 1-5
                                                    displayAnswer = `${ansValue}점`;
                                                    answerClass = ansValue >= 4 ? "text-emerald-700 font-bold bg-emerald-100 px-3 py-1 rounded-md text-sm"
                                                        : ansValue <= 2 ? "text-rose-700 font-bold bg-rose-100 px-3 py-1 rounded-md text-sm"
                                                            : "text-amber-700 font-bold bg-amber-100 px-3 py-1 rounded-md text-sm";
                                                }
                                            }

                                            return (
                                                <div key={q.id} className="flex flex-col lg:flex-row lg:items-start justify-between gap-4 py-3 border-b border-slate-200/50 last:border-0 hover:bg-white transition-colors px-2 rounded-lg">
                                                    <div className="flex-1 text-[15px] text-slate-700 leading-snug">
                                                        <span className="text-slate-400 text-sm font-mono mr-3 font-bold">Q{qIdx + 1}.</span>
                                                        {q.question ? q.question.replace(/^\[.*?\]\s*/, '') : '-'}
                                                    </div>
                                                    <div className="shrink-0 lg:max-w-xs text-right self-end lg:self-center">
                                                        <span className={`inline-block ${answerClass}`}>{displayAnswer}</span>
                                                    </div>
                                                </div>
                                            );
                                        })}
                                    </div>
                                </div>
                            );
                        })}
                    </div>
                </section>

            </main>
        </div >
    );
}
