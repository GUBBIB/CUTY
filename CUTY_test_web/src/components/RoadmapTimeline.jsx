import React, { useState } from 'react';

/**
 * [기획 반영: Actionable Roadmap & Red Flag 경고]
 * 1학년부터 졸업, 정주까지 이어지는 긴 호흡의 비자 퀘스트를 가로형 타임라인으로 배치합니다.
 * 부정 요소는 빨간색(Red Flag)으로, 달성 목표는 게임의 리워드처럼 강조합니다.
 */
export default function RoadmapTimeline({ roadmapData, d10Simulation, userProfile }) {
    const [activeTab, setActiveTab] = useState(0);

    // If roadmapData isn't an array of objects (old data fallback), handle it gracefully
    const roadmaps = Array.isArray(roadmapData) && roadmapData.length > 0 && roadmapData[0].steps ? roadmapData : [{ title: '추천 직무', steps: roadmapData }];
    const currentRoadmap = roadmaps[activeTab];

    return (
        <section className="roadmap-container card bg-white/5 border border-white/10 p-6 rounded-3xl mt-8">
            <h3 className="roadmap-title text-2xl font-bold text-white mb-6 flex items-center gap-3">
                <span className="w-1.5 h-8 bg-kvti-secondary rounded-full block"></span>
                당신만의 KVTI 성장 로드맵
            </h3>

            {/* Tab Selector */}
            {roadmaps.length > 1 && (
                <div className="flex flex-wrap gap-2 mb-8 bg-black/20 p-2 rounded-2xl border border-white/5">
                    {roadmaps.map((rm, idx) => (
                        <button
                            key={idx}
                            onClick={() => setActiveTab(idx)}
                            className={`flex-1 min-w-[120px] py-3 px-4 rounded-xl text-sm font-bold transition-all ${activeTab === idx
                                ? 'bg-kvti-primary text-slate-900 shadow-[0_0_15px_rgba(56,189,248,0.3)]'
                                : 'text-slate-400 hover:bg-white/10 hover:text-white'
                                }`}
                        >
                            Route {idx + 1}. {rm.title}
                        </button>
                    ))}
                </div>
            )}

            {/* Target Specs Dashboard (Advanced 4-Tier) */}
            {currentRoadmap.targetSpecs && (
                <div className="target-specs-dashboard bg-slate-900/40 border border-kvti-secondary/20 p-5 md:p-6 rounded-2xl mb-10 shadow-lg relative overflow-hidden group">
                    <div className="absolute top-0 right-0 w-32 h-32 bg-kvti-secondary/5 rounded-full blur-2xl -mr-10 -mt-10 pointer-events-none origin-center group-hover:scale-110 transition-transform"></div>
                    <h4 className="text-lg font-bold text-white mb-5 flex items-center gap-2 border-b border-white/10 pb-3">
                        <span className="text-xl">🏆</span> 종합 목표 스펙 가이드
                    </h4>

                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                        {/* 1. Basic Requirements (Degree, Language) */}
                        {currentRoadmap.targetSpecs.basicReq && currentRoadmap.targetSpecs.basicReq.length > 0 && (
                            <div className="spec-group">
                                <span className="text-xs font-bold text-rose-400 uppercase tracking-widest block mb-2 pb-1 border-b border-rose-500/20">필수 기본 자격</span>
                                <div className="flex flex-col gap-2">
                                    {currentRoadmap.targetSpecs.basicReq.map((item, i) => (
                                        <div key={`basic-${i}`} className="flex items-center gap-2 bg-rose-500/10 border border-rose-500/20 px-3 py-1.5 rounded-lg text-rose-300 text-sm font-medium">
                                            <span className="text-rose-500">📌</span>
                                            <span className="leading-snug">{item}</span>
                                        </div>
                                    ))}
                                </div>
                            </div>
                        )}

                        {/* 2. Certifications */}
                        {currentRoadmap.targetSpecs.certifications && currentRoadmap.targetSpecs.certifications.length > 0 && (
                            <div className="spec-group">
                                <span className="text-xs font-bold text-kvti-secondary uppercase tracking-widest block mb-2 pb-1 border-b border-kvti-secondary/20">필수/권장 자격증</span>
                                <div className="flex flex-col gap-2">
                                    {currentRoadmap.targetSpecs.certifications.map((item, i) => (
                                        <div key={`cert-${i}`} className={`flex flex-col sm:flex-row sm:items-center gap-1 sm:gap-2 px-3 py-2 rounded-lg border text-sm font-medium shadow-sm leading-snug transition-colors ${item.priority === 'High'
                                            ? 'bg-orange-500/10 border-orange-500/30 text-orange-200'
                                            : 'bg-kvti-secondary/10 border-kvti-secondary/30 text-kvti-secondary'
                                            }`}>
                                            <span className={`shrink-0 inline-flex items-center justify-center px-1.5 py-0.5 rounded text-[10px] font-black tracking-wider ${item.priority === 'High' ? 'bg-orange-500/20 text-orange-400' : 'bg-kvti-secondary/30 text-white'
                                                }`}>
                                                {item.label}
                                            </span>
                                            <span>{item.text}</span>
                                        </div>
                                    ))}
                                </div>
                            </div>
                        )}

                        {/* 3. Tools / Skills */}
                        {currentRoadmap.targetSpecs.tools && currentRoadmap.targetSpecs.tools.length > 0 && (
                            <div className="spec-group">
                                <span className="text-xs font-bold text-blue-400 uppercase tracking-widest block mb-2 pb-1 border-b border-blue-500/20">핵심 기술 스택</span>
                                <div className="flex flex-wrap gap-2">
                                    {currentRoadmap.targetSpecs.tools.map((item, i) => (
                                        <span key={`tool-${i}`} className="inline-block bg-blue-500/10 text-blue-300 border border-blue-500/30 px-2.5 py-1 rounded-lg text-sm font-medium shadow-sm leading-snug">
                                            {item}
                                        </span>
                                    ))}
                                </div>
                            </div>
                        )}

                        {/* 4. Portfolio / Activities */}
                        {currentRoadmap.targetSpecs.portfolio && currentRoadmap.targetSpecs.portfolio.length > 0 && (
                            <div className="spec-group">
                                <span className="text-xs font-bold text-purple-400 uppercase tracking-widest block mb-2 pb-1 border-b border-purple-500/20">권장 활동 및 포트폴리오</span>
                                <div className="flex flex-col gap-2 text-left">
                                    {currentRoadmap.targetSpecs.portfolio.map((item, i) => (
                                        <div key={`port-${i}`} className={`flex flex-col sm:flex-row sm:items-center gap-1 sm:gap-2 px-3 py-2 rounded-lg border text-sm font-medium shadow-sm leading-snug transition-colors ${item.type === 'Activity'
                                            ? 'bg-teal-500/10 border-teal-500/30 text-teal-200'
                                            : 'bg-purple-500/10 border-purple-500/30 text-purple-200'
                                            }`}>
                                            <span className={`shrink-0 inline-flex items-center justify-center px-1.5 py-0.5 rounded text-[10px] font-black tracking-wider ${item.type === 'Activity' ? 'bg-teal-500/20 text-teal-400' : 'bg-purple-500/30 text-white'
                                                }`}>
                                                {item.label}
                                            </span>
                                            <span>{item.text}</span>
                                        </div>
                                    ))}
                                </div>
                            </div>
                        )}
                    </div>
                </div>
            )}

            <div className="timeline-vertical flex flex-col relative gap-8 mb-12 pl-4 md:pl-8">
                {/* Vertical Connecting Line */}
                <div className="absolute left-[2.25rem] md:left-[3.25rem] top-8 bottom-8 w-1 bg-white/10 rounded-full z-0 hidden sm:block"></div>

                {currentRoadmap.steps.map((step, idx) => {
                    const themeColors = [
                        { border: 'border-blue-500', text: 'text-blue-400', glow: 'shadow-[0_0_15px_rgba(59,130,246,0.3)]', bg: 'bg-blue-500/10' },
                        { border: 'border-indigo-500', text: 'text-indigo-400', glow: 'shadow-[0_0_15px_rgba(99,102,241,0.3)]', bg: 'bg-indigo-500/10' },
                        { border: 'border-purple-500', text: 'text-purple-400', glow: 'shadow-[0_0_15px_rgba(168,85,247,0.3)]', bg: 'bg-purple-500/10' },
                        { border: 'border-rose-500', text: 'text-rose-400', glow: 'shadow-[0_0_15px_rgba(244,63,94,0.3)]', bg: 'bg-rose-500/10' }
                    ];
                    const theme = themeColors[idx % themeColors.length];

                    let title = step.stage.replace(/Step \d+\.\s*/, '').trim();
                    let subtitle = '';
                    if (title.includes('(')) {
                        const parts = title.split('(');
                        title = parts[0].trim();
                        subtitle = '(' + parts[1].trim();
                    }

                    return (
                        <div key={idx} className="timeline-step relative z-10 flex flex-col sm:flex-row gap-4 sm:gap-6 items-start group">
                            {/* Icon / Avatar Box */}
                            <div className={`shrink-0 w-12 h-12 md:w-16 md:h-16 rounded-full flex items-center justify-center text-xl md:text-3xl border-2 ${theme.border} ${theme.bg} ${theme.glow} transition-transform group-hover:scale-110 group-hover:bg-white/10`}>
                                {step.icon}
                            </div>

                            {/* Content Card */}
                            <div className={`flex-1 bg-slate-900/60 backdrop-blur-sm border border-white/10 p-5 md:p-6 rounded-2xl w-full transition-all group-hover:border-${theme.border.split('-')[1]}-500/50 group-hover:shadow-lg`}>
                                <div className="step-header mb-4 border-b border-white/5 pb-3">
                                    <div className={`inline-block px-3 py-1 rounded-full ${theme.bg} ${theme.text} text-xs font-black tracking-wider uppercase mb-2`}>
                                        Phase {idx + 1}
                                    </div>
                                    <h4 className="text-white font-bold text-xl md:text-2xl leading-tight flex items-center justify-between">
                                        <span>{title}</span>
                                        {subtitle && <span className={`${theme.text} text-sm font-semibold opacity-70`}>{subtitle}</span>}
                                    </h4>
                                </div>

                                <div className="step-content text-slate-300 text-sm md:text-base leading-relaxed space-y-4">
                                    {/* Conditional Info Blocks */}
                                    {idx === 0 && !userProfile?.isMajorAligned && (
                                        <div className="action-box bg-blue-500/10 p-4 rounded-xl border border-blue-500/30 flex items-start gap-3">
                                            <span className="text-xl">💡</span>
                                            <div>
                                                <span className="text-blue-400 font-bold block mb-1">전공 무관 취업 특례</span>
                                                <span className="text-sm">전공과 희망 직무가 달라도 공인 자격증 및 포트폴리오로 고용 필요성 입증이 가능합니다. 포기하지 마세요!</span>
                                            </div>
                                        </div>
                                    )}

                                    {idx === 3 && d10Simulation && (
                                        <div className="d10-simulation-box bg-indigo-500/10 p-4 rounded-xl border border-indigo-500/30 flex flex-col sm:flex-row items-center justify-between gap-4">
                                            <div>
                                                <span className="text-indigo-400 font-bold block mb-1">D-10 (구직) 합격 예측치</span>
                                                <span className="text-sm text-indigo-200/80">{d10Simulation.message}</span>
                                            </div>
                                            <div className="shrink-0 bg-indigo-500/20 px-4 py-2 rounded-lg border border-indigo-500/40 text-center text-white font-black text-2xl">
                                                {d10Simulation.score}<span className="text-sm font-bold text-indigo-300 ml-1">점</span>
                                            </div>
                                        </div>
                                    )}

                                    {/* Action Items List */}
                                    <div className="space-y-4 mt-6">
                                        <div className="flex items-center gap-2 mb-3">
                                            <span className="text-white/40 text-xs font-bold uppercase tracking-widest block">Key Quests</span>
                                            <div className="h-[1px] flex-1 bg-gradient-to-r from-white/10 to-transparent"></div>
                                        </div>

                                        <div className="grid grid-cols-1 gap-3">
                                            {step.action_items.map((item, itemIdx) => {
                                                // Randomly assign a thematic emoji based on the item tag or content if possible, else generic
                                                const questIcons = ['🎯', '✍️', '🛠️', '🚀', '🔥', '📚', '🤝', '💼', '💡', '🏆', '🔍', '📈'];
                                                const iconHash = item.task.length + item.tag.length + itemIdx;
                                                const icon = questIcons[iconHash % questIcons.length];

                                                return (
                                                    <div key={itemIdx} className="bg-gradient-to-r from-black/40 to-black/20 hover:from-white/10 hover:to-transparent transition-all p-4 rounded-xl border border-white/5 relative overflow-hidden flex items-start sm:items-center gap-4 group/quest shadow-sm">
                                                        {/* Large Emoji Badge */}
                                                        <div className={`shrink-0 w-10 h-10 sm:w-12 sm:h-12 flex items-center justify-center rounded-xl text-2xl bg-white/5 border border-white/10 group-hover/quest:scale-110 transition-transform ${item.priority === 'High' ? 'shadow-[0_0_10px_rgba(244,63,94,0.15)]' : ''}`}>
                                                            {icon}
                                                        </div>

                                                        {/* Text Content */}
                                                        <div className="flex-1 w-full flex flex-col sm:flex-row sm:items-center justify-between gap-3">
                                                            <div className="flex-1">
                                                                <span className="leading-relaxed text-sm md:text-base font-medium text-white/90" dangerouslySetInnerHTML={{ __html: item.task.replace(/\*\*(.*?)\*\*/g, '<strong class="text-white font-black bg-white/10 px-1 rounded">$1</strong>') }}></span>
                                                            </div>

                                                            {/* Tags */}
                                                            <div className="shrink-0 flex items-center gap-2">
                                                                <span className={`inline-flex items-center justify-center px-2.5 py-1 rounded text-[11px] font-black tracking-wide ${item.priority === 'High' ? 'bg-red-500/20 text-red-400 border border-red-500/30' : 'bg-green-500/20 text-green-400 border border-green-500/30'}`}>
                                                                    {item.tag}
                                                                </span>
                                                                {item.priority === 'High' && (
                                                                    <span className="inline-flex items-center justify-center px-1.5 py-1 rounded text-[10px] font-bold tracking-wider bg-orange-500/20 text-orange-400 border border-orange-500/30 uppercase">
                                                                        Must
                                                                    </span>
                                                                )}
                                                            </div>
                                                        </div>
                                                    </div>
                                                );
                                            })}
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    );
                })}
            </div>

            {/* --- 최하단 F-2-7 점수제 정주 경고 (Red Flag) --- */}
            {/* [기획 반영: 치명적 위반 사항 경고] */}
            <div className="red-flag-box bg-red-500/10 border border-red-500/20 border-l-4 border-l-red-500 p-5 rounded-xl mt-6 relative overflow-hidden group">
                <div className="absolute top-0 right-0 p-10 bg-red-500/10 rounded-full blur-2xl -mr-5 -mt-5 pointer-events-none origin-center group-hover:scale-110 transition-transform"></div>
                <h4 className="text-red-400 font-bold text-lg mb-2 flex items-center gap-2">
                    <span className="text-xl">🚨</span> 법무부 체류 자격 박탈 (Red Flag) 경고
                </h4>
                <p className="text-red-200/80 text-sm leading-relaxed">
                    단 <strong className="text-red-300">100만 원 미만의 가벼운 범칙금(무단횡단, 전동킥보드 법규 위반, 불법 아르바이트 등)</strong> 납부 기록도 향후 F-2-7 거주 비자 전환 시 치명적인 감점(-80점) 요소로 작용하여 한국 정주가 영구적으로 불가능해질 수 있습니다. 법규 준수는 최고의 스펙입니다.
                </p>
            </div>

        </section>
    );
}
