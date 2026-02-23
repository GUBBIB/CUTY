import React from 'react';
import { useNavigate } from 'react-router-dom';
import { FileText } from 'lucide-react';
import { E7_DB } from '../data/persona_data';

export default function AnalysisSummary({ reportData }) {
    const navigate = useNavigate();

    if (!reportData) return null;
    const { dashboard, diagnosis } = reportData;

    return (
        <div className="card bg-slate-800/80 border border-white/10 p-8 rounded-3xl mt-12 shadow-xl backdrop-blur-md">
            <div className="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 gap-4">
                <h2 className="text-2xl font-bold text-white flex items-center gap-3">
                    <span className="text-3xl">📋</span> KVTI 종합 분석 리포트 요약본
                </h2>
                <button
                    onClick={() => navigate('/report', { state: { result: reportData } })}
                    className="bg-white/10 hover:bg-white/20 text-slate-300 hover:text-white text-sm px-5 py-2.5 rounded-xl transition-colors border border-white/10 flex items-center gap-2 shadow-sm whitespace-nowrap"
                >
                    <FileText className="w-4 h-4" /> 종합 분석 리포트 보기
                </button>
            </div>

            <div className="space-y-6 text-slate-300 leading-relaxed text-sm md:text-base">
                <div className="p-6 bg-white/5 rounded-2xl border border-white/5 hover:bg-white/10 transition-colors">
                    <h3 className="text-kvti-primary font-bold text-lg mb-3 flex items-center gap-2">
                        <span className="w-6 h-6 rounded-full bg-kvti-primary/20 flex items-center justify-center text-xs">1</span>
                        직무 및 산업 적합성 종합
                    </h3>
                    <p>귀하는 <strong>{dashboard.persona_title}</strong> 페르소나에 부합하며, 특유의 성향을 바탕으로 {dashboard.characteristics || "글로벌 비즈니스"} 영역에서 두각을 나타낼 수 있습니다. 법무부 지정 E-7 직종 중 <strong>{dashboard.recommended_jobs ? dashboard.recommended_jobs.map(j => E7_DB[j.code]?.name_ko || j.code).join(', ') : (E7_DB[dashboard.job_code]?.name_ko || dashboard.job_code)}</strong> 분야에서 매우 높은 비자 취득 잠재력을 보유하고 있습니다. 특히 수료하신 활동들이 기업의 고용 필요성을 강력히 대변합니다.</p>
                </div>

                <div className="p-6 bg-white/5 rounded-2xl border border-white/5 hover:bg-white/10 transition-colors">
                    <h3 className="text-blue-400 font-bold text-lg mb-3 flex items-center gap-2">
                        <span className="w-6 h-6 rounded-full bg-blue-500/20 flex items-center justify-center text-xs">2</span>
                        실무 역량 검증 및 보완점
                    </h3>
                    <p>현재 단계에서 한국어 소통 능력(TOPIK 레벨 변환점수: {diagnosis.competence?.korean || 0})은 {diagnosis.competence?.korean >= 4 ? "실무에 즉시 투입 가능한 매우 훌륭한 수준입니다." : "실무 소통을 위해 지속적인 성장이 필요한 단계입니다."} 추가적으로 실무 필수 요건인 OA 스킬 및 자격증(기술 역량 레벨: {diagnosis.competence?.tech_skill || 0})을 최우선으로 보강하시면 E-7 비자 심사 시 큰 가산점을 확보할 수 있습니다.</p>
                </div>

                <div className="p-6 bg-white/5 rounded-2xl border border-white/5 hover:bg-white/10 transition-colors">
                    <h3 className="text-pink-400 font-bold text-lg mb-3 flex items-center gap-2">
                        <span className="w-6 h-6 rounded-full bg-pink-500/20 flex items-center justify-center text-xs">3</span>
                        한국 기업 특화 조직 문화 시너지
                    </h3>
                    {diagnosis.culture_fit?.risk_factors && diagnosis.culture_fit.risk_factors.length > 0 ? (
                        <p>수평적 소통과 자율성을 중요하게 여기는 혁신적 성향입니다.
                            수직적인 위계가 강한 전통적인 대기업보다는, <strong>능력 중심의 글로벌 벤처 스타트업이나 자율성이 보장된 우수 중소기업</strong>에서 눈부신 성과와 가장 강력한 조직 시너지를 발휘할 수 있습니다.</p>
                    ) : (
                        <p>다양한 조직 규칙과 눈치, 위계 질서에 유연하게 적응할 수 있는 높은 수용성을 지녔습니다.
                            전통적인 한국 대기업 및 중견기업 문화에도 빠르게 스며들어 원만한 사내 관계망을 구축하고 안정적인 장기 근속이 가능할 것으로 평가됩니다.</p>
                    )}
                </div>
            </div>
        </div>
    );
}
