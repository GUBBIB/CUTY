import { useLocation, useNavigate } from 'react-router-dom';
import { Radar, RadarChart, PolarGrid, PolarAngleAxis, PolarRadiusAxis, ResponsiveContainer } from 'recharts';
import { motion } from 'framer-motion';
import PersonaCard from '../components/PersonaCard';

function Result() {
    const location = useLocation();
    const navigate = useNavigate();
    const { result } = location.state || {};

    if (!result) {
        return (
            <div className="min-h-screen bg-kvti-bg text-white flex items-center justify-center">
                <div className="text-center">
                    <h2 className="text-xl mb-4 text-slate-300">결과 데이터가 없습니다.</h2>
                    <button onClick={() => navigate('/')} className="text-kvti-primary underline">홈으로 돌아가기</button>
                </div>
            </div>
        );
    }

    try {
        const { dashboard, diagnosis, roadmap } = result;

        return (
            <div className="min-h-screen bg-kvti-bg text-white p-4 md:p-8 overflow-y-auto font-sans">
                <div className="max-w-5xl mx-auto space-y-16 pt-12 pb-24">

                    {/* Navigation Header */}
                    <div className="fixed top-6 right-6 z-50">
                        <button
                            onClick={() => navigate('/')}
                            className="bg-black/20 hover:bg-black/40 backdrop-blur-md px-4 py-2 rounded-full transition-all text-white border border-white/10 shadow-lg text-sm font-medium"
                        >
                            처음으로
                        </button>
                    </div>

                    {/* SECTION 1: IDENTITY (Hero) */}
                    <div className="flex flex-col items-center">
                        <div className="mb-8 transform hover:scale-105 transition-transform duration-500">
                            <PersonaCard
                                personaTitle={dashboard.persona_title}
                                typeCode={dashboard.type_code}
                                tags={dashboard.tags}
                                quote={dashboard.characteristics}
                            />
                        </div>

                        {/* Quick Stats */}
                        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 w-full max-w-3xl">
                            <div className="bg-white/5 p-4 rounded-2xl border border-white/10 text-center backdrop-blur-sm">
                                <span className="block text-slate-400 text-xs mb-1">목표 비자 (Target Visa)</span>
                                <span className="font-bold text-kvti-primary text-sm md:text-base">{dashboard.target_visa.split(' ')[0]}</span>
                            </div>
                            <div className="bg-white/5 p-4 rounded-2xl border border-white/10 text-center backdrop-blur-sm">
                                <span className="block text-slate-400 text-xs mb-1">추천 직무 (Job)</span>
                                <span className="font-bold text-white text-sm md:text-base">{dashboard.job_code.split(' ')[0]}</span>
                            </div>
                            <div className="bg-white/5 p-4 rounded-2xl border border-white/10 text-center backdrop-blur-sm">
                                <span className="block text-slate-400 text-xs mb-1">F-2-7 가능성</span>
                                <span className={`font-bold text-sm md:text-base ${dashboard.grade === 'PASS' ? 'text-green-400' : 'text-red-400'}`}>
                                    {dashboard.grade === 'PASS' ? '안전 (Safe)' : '주의 (Check)'}
                                </span>
                            </div>
                            <div className="bg-white/5 p-4 rounded-2xl border border-white/10 text-center backdrop-blur-sm">
                                <span className="block text-slate-400 text-xs mb-1">핵심 리스크</span>
                                <span className={`font-bold text-sm md:text-base ${dashboard.risk_alert === '안정적 (Stable)' ? 'text-blue-400' : 'text-red-400'}`}>
                                    {dashboard.risk_alert.split('(')[0]}
                                </span>
                            </div>
                        </div>
                    </div>

                    {/* SECTION 2: LEGAL REALITY CHECK (Visa & Risk) */}
                    <section>
                        <h2 className="text-2xl font-bold mb-6 flex items-center gap-3 text-white/90">
                            <span className="w-1.5 h-8 bg-kvti-gold rounded-full block"></span>
                            비자 적합성 진단 (Visa Reality Check)
                        </h2>

                        <div className="grid md:grid-cols-12 gap-6">
                            {/* F-2-7 Detailed Score */}
                            <motion.div
                                initial={{ opacity: 0, y: 20 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }}
                                className="md:col-span-5 glass-card p-6 rounded-3xl border border-white/10 bg-gradient-to-b from-white/5 to-transparent"
                            >
                                <div className="flex justify-between items-center mb-6">
                                    <h3 className="text-kvti-gold font-bold text-sm tracking-wider">F-2-7 점수제 시뮬레이션</h3>
                                    <span className="text-xs text-slate-500">합격 기준: 80점</span>
                                </div>

                                <div className="flex items-end gap-2 mb-6">
                                    <span className="text-6xl font-black text-white">{diagnosis.f27_sim.score}</span>
                                    <span className="text-xl text-slate-400 mb-2">/ 80점</span>
                                </div>

                                <div className="space-y-3">
                                    {diagnosis.f27_sim.breakdown?.map((item, idx) => (
                                        <div key={idx} className="flex justify-between items-center p-3 bg-white/5 rounded-xl">
                                            <span className="text-slate-300 text-sm">{item.label}</span>
                                            <span className="font-bold text-white">+{item.score}</span>
                                        </div>
                                    ))}
                                </div>
                                <div className={`mt-6 text-center text-sm font-bold p-3 rounded-xl border ${diagnosis.f27_sim.score >= 80 ? 'bg-green-500/10 border-green-500/30 text-green-400' : 'bg-red-500/10 border-red-500/30 text-red-400'}`}>
                                    판정: {diagnosis.f27_sim.status}
                                </div>
                            </motion.div>

                            {/* Risk Guide */}
                            <motion.div
                                initial={{ opacity: 0, y: 20 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} transition={{ delay: 0.1 }}
                                className="md:col-span-7 glass-card p-8 rounded-3xl border-l-4 border-l-red-500 bg-white/5 relative overflow-hidden"
                            >
                                <div className="absolute top-0 right-0 p-24 bg-red-500/5 rounded-full blur-3xl -mr-10 -mt-20 pointer-events-none"></div>
                                <h3 className="text-red-400 font-bold text-sm tracking-wider mb-4 flex items-center gap-2">
                                    <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" /></svg>
                                    핵심 리스크 분석
                                </h3>

                                <div className="mb-6">
                                    <h4 className="text-xl font-bold text-white mb-2">{dashboard.risk_alert}</h4>
                                    <p className="text-slate-300 text-sm leading-relaxed">
                                        현재 프로필에서 가장 주의해야 할 법적 리스크입니다.
                                        비자 발급 거절 사유가 될 수 있으므로 반드시 사전에 대비해야 합니다.
                                    </p>
                                </div>

                                <div className="space-y-3">
                                    {dashboard.risk_items?.map((item, i) => (
                                        <div key={i} className="flex gap-3 items-start p-3 bg-red-500/5 rounded-lg border border-red-500/10">
                                            <span className="text-red-400 mt-0.5">•</span>
                                            <span className="text-sm text-slate-200">{item}</span>
                                        </div>
                                    ))}
                                </div>
                            </motion.div>
                        </div>
                    </section>

                    {/* SECTION 3: CAREER CAPABILITY (Job & Roadmap) */}
                    <section>
                        <h2 className="text-2xl font-bold mb-6 flex items-center gap-3 text-white/90">
                            <span className="w-1.5 h-8 bg-blue-500 rounded-full block"></span>
                            커리어 & 로드맵 (Career Path)
                        </h2>

                        <div className="grid md:grid-cols-2 gap-6 mb-8">
                            {/* Strategy Text */}
                            <div className="glass-card p-6 rounded-3xl bg-white/5 border border-white/10">
                                <h3 className="text-blue-400 font-bold text-sm tracking-wider mb-4">맞춤형 전략 가이드</h3>
                                <p className="text-slate-200 leading-7 text-sm whitespace-pre-wrap">
                                    {dashboard.strategy.replace(/\*\*/g, '')}
                                </p>
                            </div>

                            {/* Chart */}
                            <div className="glass-card p-4 rounded-3xl bg-white/5 border border-white/10 flex items-center justify-center">
                                <div className="w-full h-[250px]">
                                    <ResponsiveContainer width="100%" height="100%">
                                        <RadarChart cx="50%" cy="50%" outerRadius="70%" data={diagnosis.riasec.radarData}>
                                            <PolarGrid stroke="rgba(255,255,255,0.1)" />
                                            <PolarAngleAxis dataKey="subject" tick={{ fill: '#94a3b8', fontSize: 10, fontWeight: 600 }} />
                                            <PolarRadiusAxis angle={30} domain={[0, 50]} tick={false} axisLine={false} />
                                            <Radar name="Score" dataKey="A" stroke="#3b82f6" strokeWidth={3} fill="#3b82f6" fillOpacity={0.3} />
                                        </RadarChart>
                                    </ResponsiveContainer>
                                </div>
                            </div>
                        </div>

                        {/* Roadmap Timeline */}
                        <div className="space-y-4">
                            {roadmap.map((step, idx) => (
                                <div key={idx} className="glass-card p-6 rounded-2xl border border-white/5 bg-white/[0.02] hover:bg-white/[0.05] transition-colors relative overflow-hidden">
                                    {/* Timeline Connector */}
                                    {idx !== roadmap.length - 1 && (
                                        <div className="absolute left-8 bottom-0 top-16 w-0.5 bg-gradient-to-b from-white/10 to-transparent"></div>
                                    )}

                                    <div className="flex gap-6 relative z-10">
                                        <div className="flex-shrink-0 w-12 h-12 rounded-full bg-white/5 border border-white/10 flex items-center justify-center font-bold text-lg text-slate-300">
                                            {idx + 1}
                                        </div>
                                        <div className="flex-1">
                                            <h3 className="font-bold text-lg text-white mb-4">{step.stage}</h3>
                                            <div className="space-y-3">
                                                {step.action_items.map((item, i) => (
                                                    <div key={i} className="bg-black/20 p-4 rounded-xl border border-white/5">
                                                        <div className="flex justify-between items-start mb-1">
                                                            <span className={`text-[10px] font-bold px-2 py-0.5 rounded ${item.priority === 'High' ? 'bg-red-500/20 text-red-400' : 'bg-green-500/20 text-green-400'}`}>
                                                                {item.priority === 'High' ? '필수 (High)' : '권장 (Low)'}
                                                            </span>
                                                        </div>
                                                        <p className="text-slate-300 text-sm leading-relaxed mt-2">
                                                            {item.task.split('**').map((part, index) =>
                                                                index % 2 === 1 ? <strong key={index} className="text-white bg-white/10 px-1 rounded mx-0.5">{part}</strong> : part
                                                            )}
                                                        </p>
                                                    </div>
                                                ))}
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            ))}
                        </div>
                    </section>

                    {/* Footer */}
                    <div className="text-center pt-10 border-t border-white/5">
                        <button onClick={() => navigate('/')} className="bg-white text-black font-bold px-10 py-4 rounded-full hover:scale-105 transition-transform">
                            다시 진단하기
                        </button>
                        <p className="mt-6 text-xs text-slate-600">
                            KVTI System v2.0 • Data based on 2026 Visa Guidelines • Legal Reference: Ministry of Justice
                        </p>
                    </div>

                </div>
            </div>
        );
    } catch (error) {
        console.error("Result Rendering Error:", error);
        return (
            <div className="min-h-screen bg-kvti-bg text-white flex items-center justify-center p-10">
                <div className="max-w-xl text-center">
                    <h1 className="text-2xl text-red-500 font-bold mb-4">오류 발생 (Error)</h1>
                    <pre className="text-left bg-black/50 p-4 rounded text-xs text-red-300 overflow-auto max-h-60 mb-6 font-mono">
                        {error.toString()}
                    </pre>
                    <button onClick={() => navigate('/')} className="bg-white/10 px-6 py-2 rounded-full">홈으로 이동</button>
                </div>
            </div>
        );
    }
}

export default Result;
