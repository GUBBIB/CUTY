import React, { useState } from 'react';
import { KVTI_DICTIONARY } from '../data/kvti_dictionary';

// ----------------------------------------
// KVTI Explanation Modal Component 
// ----------------------------------------
export default function TypeDictionaryModal({ onClose }) {
    const tableData = [
        {
            title: "1번째 자리: 관심 산업 (Industry)",
            theme: "text-pink-400",
            items: [
                { code: "I", label: "IT & Tech (정보기술)" },
                { code: "B", label: "Business (비즈니스/무역)" },
                { code: "D", label: "Design (디자인/콘텐츠)" },
                { code: "M", label: "Manufacturing (제조/엔지니어링)" }
            ]
        },
        {
            title: "2번째 자리: 핵심 성향 (Trait)",
            theme: "text-cyan-400",
            items: [
                { code: "A", label: "Analytical (분석/탐구형)" },
                { code: "C", label: "Creative (창조/예술형)" },
                { code: "E", label: "Enterprising (진취/리더형)" },
                { code: "P", label: "Practical (실용/현장형)" }
            ]
        },
        {
            title: "3번째 자리: 조직 문화 (Culture Fit)",
            theme: "text-yellow-400",
            items: [
                { code: "H", label: "Hierarchy (체계·안정형)" },
                { code: "F", label: "Flat (자율·수평형)" }
            ]
        }
    ];

    const [selectedType, setSelectedType] = useState(null);

    const getBadgeColor = (text) => {
        const t = text.toUpperCase();
        if (t.includes('E-7-1')) return 'bg-blue-500/20 text-blue-300 border-blue-500/50';
        if (t.includes('E-7-2') || t.includes('E-7-3')) return 'bg-green-500/20 text-green-300 border-green-500/50';
        if (t.includes('E-7-4')) return 'bg-teal-500/20 text-teal-300 border-teal-500/50';
        if (t.includes('D-8-4')) return 'bg-purple-500/20 text-purple-300 border-purple-500/50';
        if (t.includes('F-1-D') || t.includes('F-2-7')) return 'bg-orange-500/20 text-orange-300 border-orange-500/50';

        // 정규식: E-7, D-8, F-1, F-2 등 비자 종류를 뜻하는 단어가 아예 없는 경우 (ex: "개발자(DBA)") 기본값인 E-7-1(파랑) 적용
        if (!/(E-7|D-8|F-1|F-2)/.test(t)) return 'bg-blue-500/20 text-blue-300 border-blue-500/50';

        return 'bg-gray-500/20 text-gray-300 border-gray-500/50';
    };

    return (
        <div className="fixed inset-0 z-[100] flex items-center justify-center p-4 bg-black/80 backdrop-blur-md" onClick={onClose}>
            <div className="bg-[#1a1c29] rounded-3xl w-full max-w-5xl max-h-[90vh] flex flex-col overflow-hidden shadow-2xl border border-white/10 animate-in fade-in zoom-in duration-300" onClick={e => e.stopPropagation()}>
                {/* Header */}
                <div className="bg-gradient-to-r from-slate-800 to-slate-900 border-b border-white/10 p-6 md:p-8 text-center relative shrink-0">
                    <button onClick={onClose} className="absolute top-6 right-6 text-white/50 hover:text-white transition-colors bg-white/5 rounded-full p-2">
                        <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>
                    <h2 className="text-2xl md:text-3xl font-extrabold text-white">
                        KVTI 코어 성향 안내 <span className="text-kvti-info text-xl">(총 32개 유형)</span>
                    </h2>
                    <p className="text-slate-400 text-sm md:text-base mt-2">
                        KVTI 알파벳 코드는 사용자님의 진단 데이터를 바탕으로 3가지 핵심 성향 축과 1가지 트랙을 분석하여 최적의 커리어 길을 제시합니다.
                    </p>
                </div>

                {/* Content - 4 Grid Layout & 64 Dictionary */}
                <div className="flex-1 overflow-y-auto custom-scrollbar">
                    <div className="p-6 md:p-8 grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                        {tableData.map((section, idx) => (
                            <div key={idx} className="bg-white/5 rounded-2xl border border-white/5 p-5 hover:bg-white/10 transition-colors">
                                <h3 className={`text-lg font-bold mb-4 ${section.theme} flex items-center gap-2 border-b border-white/5 pb-2`}>
                                    {section.title}
                                </h3>
                                <ul className="space-y-3">
                                    {section.items.map((item, itemIdx) => (
                                        <li key={itemIdx} className="flex items-center gap-4 text-slate-300">
                                            <div className={`w-10 h-10 rounded-xl bg-white/10 flex items-center justify-center font-black text-lg ${section.theme} shadow-inner`}>
                                                {item.code}
                                            </div>
                                            <span className="flex-1 font-medium text-sm md:text-base">{item.label}</span>
                                        </li>
                                    ))}
                                </ul>
                            </div>
                        ))}
                    </div>

                    {/* Divider & 32 Dictionary Section */}
                    <div className="px-6 md:px-8">
                        <div className="border-t border-white/10 pt-8 pb-4">

                            {/* Separate Track Explanation Card */}
                            <div className="w-full rounded-2xl bg-gradient-to-r from-indigo-500/20 to-emerald-500/20 border border-white/10 p-5 mb-8 flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
                                <div className="flex flex-col">
                                    <h4 className="text-white font-bold text-lg flex items-center gap-2">
                                        🚀 거주 계획 트랙 (Residency Track)
                                    </h4>
                                    <p className="text-slate-300 text-sm mt-1">
                                        ※ 뒤에 붙는 K(한국 정주) / G(글로벌 진출) 뱃지는 회원님의 향후 거주 계획 트랙을 의미합니다.
                                    </p>
                                </div>
                                <div className="flex items-center gap-2 shrink-0">
                                    <span className="bg-indigo-500/30 text-white font-medium px-3 py-1.5 rounded-lg text-sm border border-indigo-400/30">🇰🇷 K-Track (정주)</span>
                                    <span className="bg-emerald-500/30 text-white font-medium px-3 py-1.5 rounded-lg text-sm border border-emerald-400/30">🌎 G-Track (출국)</span>
                                </div>
                            </div>

                            <h3 className="text-xl md:text-2xl font-extrabold text-white text-center mb-6">
                                📚 전체 32개 코어 KVTI 유형 도감
                            </h3>

                            {/* Matrix Style Dictionary Table */}
                            <div className="overflow-x-auto custom-scrollbar bg-white/5 rounded-2xl border border-white/10 p-4 mb-4">
                                <table className="w-full min-w-[900px] text-left border-collapse">
                                    <thead>
                                        <tr className="border-b border-white/10 text-slate-300 text-sm">
                                            <th className="p-3 font-semibold w-1/5 whitespace-nowrap">성향(Trait) + 문화(Culture)</th>
                                            <th className="p-3 font-semibold text-pink-400 w-1/5">💻 I (IT / 기술)</th>
                                            <th className="p-3 font-semibold text-cyan-400 w-1/5">📈 B (비즈니스 / 무역)</th>
                                            <th className="p-3 font-semibold text-yellow-400 w-1/5">🎨 D (디자인 / 기획)</th>
                                            <th className="p-3 font-semibold text-purple-400 w-1/5">⚙️ M (제조 / 현장)</th>
                                        </tr>
                                    </thead>
                                    <tbody className="divide-y divide-white/5 text-sm">
                                        {[
                                            { rowKey: "A", rowLabel: "A (분석/탐구)", cultKey: "H", cultLabel: "H (체계·안정형)" },
                                            { rowKey: "A", rowLabel: "A (분석/탐구)", cultKey: "F", cultLabel: "F (자율·수평형)" },
                                            { rowKey: "C", rowLabel: "C (창조/예술)", cultKey: "H", cultLabel: "H (체계·안정형)" },
                                            { rowKey: "C", rowLabel: "C (창조/예술)", cultKey: "F", cultLabel: "F (자율·수평형)" },
                                            { rowKey: "E", rowLabel: "E (진취/리더)", cultKey: "H", cultLabel: "H (체계·안정형)" },
                                            { rowKey: "E", rowLabel: "E (진취/리더)", cultKey: "F", cultLabel: "F (자율·수평형)" },
                                            { rowKey: "P", rowLabel: "P (실용/현장)", cultKey: "H", cultLabel: "H (체계·안정형)" },
                                            { rowKey: "P", rowLabel: "P (실용/현장)", cultKey: "F", cultLabel: "F (자율·수평형)" }
                                        ].map((row, rIdx) => (
                                            <tr key={rIdx} className="hover:bg-white/5 transition-colors">
                                                <td className="p-3 font-medium text-slate-200 whitespace-nowrap">
                                                    {row.rowLabel} + <br />
                                                    <span className="text-kvti-info">{row.cultLabel}</span>
                                                </td>
                                                {['I', 'B', 'D', 'M'].map((ind) => {
                                                    const code = `${ind}${row.rowKey}${row.cultKey}`;
                                                    const personaData = KVTI_DICTIONARY[code];
                                                    return (
                                                        <td key={ind} className="p-3 align-top">
                                                            {personaData ? (
                                                                <div
                                                                    className="cursor-pointer hover:scale-105 hover:bg-white/5 transition-all p-2 -m-2 rounded-xl group relative z-10"
                                                                    onClick={() => setSelectedType({ code, ...personaData })}
                                                                >
                                                                    <div className="font-black text-white tracking-wider mb-1 text-sm bg-black/30 inline-block px-2 py-0.5 rounded border border-white/10 group-hover:border-kvti-info">
                                                                        [{code}]
                                                                    </div>
                                                                    <div className="mt-1">
                                                                        <div className="text-white font-bold text-sm bg-clip-text text-transparent bg-gradient-to-r from-pink-300 to-indigo-300 drop-shadow-sm">
                                                                            "{personaData.nickname}"
                                                                        </div>
                                                                    </div>
                                                                    <div className="absolute inset-0 border border-white/0 group-hover:border-white/10 rounded-xl pointer-events-none transition-colors"></div>
                                                                </div>
                                                            ) : (
                                                                <div className="text-slate-500 text-xs mt-2">-</div>
                                                            )}
                                                        </td>
                                                    );
                                                })}
                                            </tr>
                                        ))}
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    {/* Footer */}
                    <div className="p-6 bg-slate-900/50 text-center border-t border-white/5 mt-auto shrink-0">
                        <button
                            onClick={onClose}
                            className="bg-kvti-primary/20 hover:bg-kvti-primary border border-kvti-primary text-white px-10 py-3 rounded-full font-bold transition-all shadow-lg hover:shadow-kvti-primary/50"
                        >
                            확인 완료
                        </button>
                    </div>
                </div>
            </div>

            {/* Inner Detail Modal */}
            {selectedType && (
                <div
                    className="fixed inset-0 z-[150] flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm animate-in fade-in duration-200"
                    onClick={() => setSelectedType(null)}
                >
                    <div
                        className="bg-slate-900 border border-white/20 rounded-3xl w-full max-w-2xl overflow-hidden shadow-[0_0_50px_rgba(0,0,0,0.8)] relative animate-in zoom-in-95 duration-200"
                        onClick={e => e.stopPropagation()}
                    >
                        {/* Inner Header */}
                        <div className="bg-gradient-to-r from-slate-800 to-slate-900 p-8 border-b border-white/10 relative">
                            <button
                                onClick={() => setSelectedType(null)}
                                className="absolute top-6 right-6 text-white/40 hover:text-white bg-black/20 hover:bg-black/40 rounded-full p-2 transition-all"
                            >
                                <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                                </svg>
                            </button>

                            <div className="flex items-center gap-4 mb-3">
                                <span className="px-4 py-1 bg-white/10 rounded-lg border border-white/20 font-black text-xl text-white tracking-widest shadow-inner">
                                    {selectedType.code}
                                </span>
                            </div>
                            <h2 className="text-3xl md:text-4xl font-black text-transparent bg-clip-text bg-gradient-to-r from-pink-400 via-purple-400 to-indigo-400 pb-2">
                                "{selectedType.nickname}"
                            </h2>
                        </div>

                        {/* Inner Content */}
                        <div className="p-8">
                            <div className="mb-8">
                                <h3 className="text-lg font-bold text-white mb-3 flex items-center gap-2">
                                    <span className="text-xl">📖</span> 페르소나 상세 분석
                                </h3>
                                <div className="bg-white/5 border border-white/10 rounded-2xl p-5 text-slate-300 leading-relaxed min-h-[100px] text-sm md:text-base">
                                    {selectedType.description}
                                </div>
                            </div>

                            <div>
                                <h3 className="text-lg font-bold text-white mb-4 flex items-center gap-2">
                                    <span className="text-xl">🎯</span> 추천 체류 자격 및 커리어 패스
                                </h3>
                                <div className="flex flex-col gap-3">
                                    {selectedType.career_paths?.map((path, pIdx) => (
                                        <div
                                            key={pIdx}
                                            className={`px-4 py-3 rounded-xl border font-bold text-sm shadow-sm ${getBadgeColor(path)}`}
                                        >
                                            {path}
                                        </div>
                                    ))}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
}
