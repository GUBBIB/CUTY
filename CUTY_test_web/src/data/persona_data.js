export const CACHE_BUSTER = 1;
export const E7_DB = {
    // IT & Tech
    "2223": {
        code: "2223",
        name_ko: "웹 개발자 (Web Developer)",
        desc: "웹사이트, 모바일 앱의 프론트엔드/백엔드 시스템을 설계하고 구축하는 전문가입니다.",
        req: {
            degree: "Bachelor (Relevant Major)",
            wage: "GNI x 80% (approx. 32M KRW)",
            major: ["Computer Science", "Software Engineering"],
            korean: 2 // Preferred but not strict if wage is high
        },
        hot_skills: ["React", "Node.js", "AWS", "TypeScript"],
        ideal_traits: { R: 0.1, I: 1.0, A: 0.2, S: 0.1, E: 0.4, C: 0.8, IT: 1.0, BIZ: 0.2, DES: 0.4, MFG: 0.1 }
    },
    "2224": {
        code: "2224",
        name_ko: "응용 소프트웨어 개발자 (App Developer)",
        desc: "PC 및 모바일 디바이스용 애플리케이션을 개발하는 전문가입니다.",
        req: { degree: "Bachelor", wage: "GNI x 80%", major: ["CS", "IT"], korean: 2 },
        hot_skills: ["Flutter", "Kotlin", "Swift", "Unity"],
        ideal_traits: { R: 0.2, I: 1.0, A: 0.3, S: 0.2, E: 0.5, C: 0.7, IT: 1.0, BIZ: 0.3, DES: 0.5, MFG: 0.1 }
    },
    "2211": {
        code: "2211",
        name_ko: "시스템 소프트웨어 개발자 (System SW)",
        desc: "OS, 펌웨어, 임베디드 시스템 등을 다루는 고난도 기술 직군입니다.",
        req: { degree: "Bachelor", wage: "GNI x 80%", major: ["EE", "CS"], korean: 2 },
        hot_skills: ["C/C++", "Linux", "Embedded", "RTOS"],
        ideal_traits: { R: 0.6, I: 1.0, A: 0.1, S: 0.1, E: 0.2, C: 0.9, IT: 1.0, BIZ: 0.1, DES: 0.0, MFG: 0.8 }
    },

    // Business & Trade
    "2742": {
        code: "2742",
        name_ko: "해외 영업원 (Overseas Sales)",
        desc: "한국 기업의 제품을 해외 바이어에게 판매하고 수출 계약을 성사시킵니다.",
        req: {
            degree: "Bachelor",
            wage: "GNI x 80%",
            major: ["Business", "Language", "Economics"],
            korean: 4 // High proficiency required
        },
        hot_skills: ["Business English", "Trading Laws", "Communication"],
        ideal_traits: { R: 0.1, I: 0.3, A: 0.2, S: 0.8, E: 1.0, C: 0.6, IT: 0.2, BIZ: 1.0, DES: 0.1, MFG: 0.2 }
    },
    "2731": {
        code: "2731",
        name_ko: "상품 기획 전문가 (Merchandiser)",
        desc: "시장 트렌드를 분석하여 경쟁력 있는 신상품을 기획하고 런칭합니다.",
        req: { degree: "Bachelor", wage: "GNI x 80%", major: ["Marketing", "Business"], korean: 4 },
        hot_skills: ["Market Research", "Trend Analysis", "Planning"],
        ideal_traits: { R: 0.1, I: 0.6, A: 0.5, S: 0.6, E: 0.9, C: 0.7, IT: 0.4, BIZ: 1.0, DES: 0.4, MFG: 0.1 }
    },
    "2733": {
        code: "2733",
        name_ko: "광고 및 홍보 전문가 (Marketing Specialist)",
        desc: "브랜드 인지도를 높이고 고객을 유입시키는 전략을 수립합니다.",
        req: { degree: "Bachelor", wage: "GNI x 80%", major: ["Advertising", "Business"], korean: 4 },
        hot_skills: ["Digital Marketing", "SEO/SEM", "Content Strategy"],
        ideal_traits: { R: 0.1, I: 0.5, A: 0.8, S: 0.7, E: 0.8, C: 0.4, IT: 0.5, BIZ: 1.0, DES: 0.6, MFG: 0.1 }
    },

    // Design & Creative
    "2855": {
        code: "2855",
        name_ko: "웹/멀티미디어 디자이너 (UI/UX)",
        desc: "사용자 경험(UX)을 고려하여 웹과 앱의 인터페이스를 디자인합니다.",
        req: { degree: "Bachelor", wage: "GNI x 80%", major: ["Design", "Art"], korean: 3 },
        hot_skills: ["Figma", "Adobe Suite", "Prototyping"],
        ideal_traits: { R: 0.2, I: 0.5, A: 1.0, S: 0.4, E: 0.4, C: 0.3, IT: 0.8, BIZ: 0.3, DES: 1.0, MFG: 0.1 }
    },
    "2841": {
        code: "2841",
        name_ko: "제품 디자이너 (Product Designer)",
        desc: "제품의 기능과 심미성을 고려하여 외관을 디자인합니다.",
        req: { degree: "Bachelor", wage: "GNI x 80%", major: ["Industrial Design"], korean: 3 },
        hot_skills: ["3D Rendering", "CAD", "Material Sense"],
        ideal_traits: { R: 0.6, I: 0.4, A: 1.0, S: 0.2, E: 0.3, C: 0.5, IT: 0.2, BIZ: 0.2, DES: 1.0, MFG: 0.8 }
    },

    // Manufacturing & Engineering
    "2351": {
        code: "2351",
        name_ko: "기계 공학 기술자 (Mechanical Engineer)",
        desc: "기계 장치나 설비를 설계, 개발하고 생산 공정을 관리합니다.",
        req: { degree: "Bachelor", wage: "GNI x 80%", major: ["Mechanical Eng."], korean: 3 },
        hot_skills: ["AutoCAD", "SolidWorks", "CATIA"],
        ideal_traits: { R: 1.0, I: 0.8, A: 0.2, S: 0.1, E: 0.3, C: 0.8, IT: 0.3, BIZ: 0.1, DES: 0.3, MFG: 1.0 }
    },
    "2352": {
        code: "2352",
        name_ko: "로봇 공학 기술자 (Robotics Engineer)",
        desc: "산업용 로봇이나 자동화 시스템을 연구하고 개발합니다.",
        req: { degree: "Bachelor", wage: "GNI x 80%", major: ["Robotics", "Mechatronics"], korean: 3 },
        hot_skills: ["ROS", "PLC", "Motion Control"],
        ideal_traits: { R: 0.9, I: 1.0, A: 0.1, S: 0.1, E: 0.2, C: 0.8, IT: 0.7, BIZ: 0.1, DES: 0.1, MFG: 1.0 }
    },
    // 🚀 Non-E-7 Special Paths (Startup & Freelance & Fast Track & Regional)
    "D84_STARTUP": {
        code: "D-8-4",
        name_ko: "기술 창업가 (Tech Startup Founder)",
        desc: "나의 독창적인 아이디어와 기술로 한국에서 직접 법인을 설립하고 비즈니스를 주도하는 혁신가입니다.",
        req: {
            degree: "학력 무관 (학사이하 OASIS 필수)",
            wage: "연봉 무관 (초기 투자금 및 아이템 심사)",
            major: ["All Majors"],
            korean: 3
        },
        hot_skills: ["OASIS Startup Visa Program", "Business Model", "Investment Pitch"],
        ideal_traits: { R: 0.3, I: 0.8, A: 0.7, S: 0.5, E: 1.0, C: 0.1, IT: 0.8, BIZ: 0.9, DES: 0.6, MFG: 0.4 }
    },
    "F27S_KSTAR": {
        code: "F-2-7S",
        name_ko: "K-STAR 우수인재 (Fast-Track Resident)",
        desc: "정부 지정 우수 대학 졸업생으로서 E-7의 복잡한 연봉 요건을 뛰어넘어 곧바로 5년 거주 비자를 취득할 잠재력이 있습니다.",
        req: {
            degree: "국내 지정 우수대학 정규 학사 이상",
            wage: "소득 증명 조건 완화 (총장 추천서 대체)",
            major: ["전공 무관 (STEM 우대)"],
            korean: 0 // 면제 또는 점수제 합산
        },
        hot_skills: ["총장 추천서(K-STAR)", "학업 성적 우수", "국내 체류 3년 이상"],
        ideal_traits: { R: 0.5, I: 1.0, A: 0.5, S: 0.5, E: 0.8, C: 0.8, IT: 0.8, BIZ: 0.6, DES: 0.5, MFG: 0.7 }
    },
    "F2R_REGION": {
        code: "F-2-R",
        name_ko: "지역특화형 우수인재 (Regional Resident)",
        desc: "인구 감소 지역의 산업 및 경제 발전에 직접 기여하며, 가장 빠르고 안정적으로 5년 단위 거주 비자를 확보하는 현실적 전략가입니다.",
        req: {
            degree: "추천 지역 내 대학 졸업 또는 국내 전문학사 이상",
            wage: "GNI 70% 또는 최저임금 이상",
            major: ["지역 내 주력 산업군 전공 유리"],
            korean: 3 // TOPIK 3급 또는 KIIP 3단계 필수
        },
        hot_skills: ["지자체장 추천서", "한국어(TOPIK 3+)", "지역 내 실거주"],
        ideal_traits: { R: 0.8, I: 0.4, A: 0.2, S: 0.8, E: 0.5, C: 0.9, IT: 0.3, BIZ: 0.5, DES: 0.2, MFG: 0.9 }
    },
    "F1D_NOMAD": {
        code: "F-1-D / F-2-7",
        name_ko: "프리랜서 / 디지털 노마드 (Independent Pro)",
        desc: "특정 기업에 얽매이지 않고 원격으로 일하거나, 본인의 기술로 여러 클라이언트와 계약을 맺는 전문가입니다.",
        req: {
            degree: "Bachelor",
            wage: "GNI x 2 이상 (F-1-D) 또는 점수제 합격점 (F-2-7)",
            major: ["IT", "Design", "Translation"],
            korean: 4
        },
        hot_skills: ["Remote Work", "Self-Branding", "Taxation", "Networking"],
        ideal_traits: { R: 0.2, I: 0.7, A: 0.9, S: 0.3, E: 0.8, C: 0.2, IT: 0.9, BIZ: 0.5, DES: 0.8, MFG: 0.1 }
    }
};
export const KVTI_32_PERSONAS = {
    "IAH": "AI/Data 연구원",
    "BAH": "마켓 리서처",
    "DAH": "UX 리서처",
    "MAH": "R&D 연구원",
    "IAF": "데이터 분석가",
    "BAF": "그로스 해커",
    "DAF": "UX 분석가",
    "MAF": "R&D 혁신가",

    "ICH": "크리에이티브 디렉터",
    "BCH": "브랜드 마케터",
    "DCH": "산업 디자이너",
    "MCH": "제품 디자이너",
    "ICF": "UI/UX 퍼블리셔",
    "BCF": "콘텐츠 마케터",
    "DCF": "K-Design 이노베이터",
    "MCF": "인더스트리얼 아티스트",

    "IEH": "IT 프로젝트 매니저",
    "BEH": "글로벌 영업/CS",
    "DEH": "서비스 기획자",
    "MEH": "공장/안전 관리자",
    "IEF": "IT 스타트업 창업가",
    "BEF": "K-Business 리더",
    "DEF": "크리에이티브 리더",
    "MEF": "스타트업 공정 관리자",

    "IPH": "시스템 유지보수(QA)",
    "BPH": "무역 사무 관리자",
    "DPH": "실용/제품 디자이너",
    "MPH": "생산 관리자 (QC)",
    "IPF": "풀스택/웹 개발자",
    "BPF": "기술 영업 전문가",
    "DPF": "제품 엔지니어",
    "MPF": "K-Tech 마에스트로"
};

export const detectIndustry = (industryId, jobId, indText, jobText) => {
    // Map IDs to Industry Types
    // IND_I = IT, IND_M = MFG, IND_C = DES, IND_B = BIZ, IND_T = BIZ, IND_S = SER, IND_L = LOC
    // JP_I = IT, JP_R = MFG, JP_A = DES, JP_E = BIZ, JP_S = BIZ, JP_C = BIZ, JP_X = SER, JP_Y = LOC

    const idStr = (industryId || "") + "_" + (jobId || "");

    if (idStr.includes('IND_I') || idStr.includes('JP_I')) return 'IT';
    if (idStr.includes('IND_C') || idStr.includes('JP_A')) return 'DES';
    if (idStr.includes('IND_M') || idStr.includes('JP_R')) return 'MFG';
    if (idStr.includes('IND_S') || idStr.includes('JP_X')) return 'SER'; // Phase 2: Service/Tourism
    if (idStr.includes('IND_L') || idStr.includes('JP_Y')) return 'LOC'; // Phase 2: Local Specialization
    if (idStr.includes('IND_T') || idStr.includes('IND_B') || idStr.includes('JP_E') || idStr.includes('JP_S') || idStr.includes('JP_C')) return 'BIZ';

    // Fallback: search text just in case (e.g. legacy compatibility)
    const s = (indText || "") + (jobText || "");
    if (s.includes('개발') || s.includes('IT') || s.includes('데이터')) return 'IT';
    if (s.includes('디자인') || s.includes('예술') || s.includes('콘텐츠')) return 'DES';
    if (s.includes('제조') || s.includes('기계') || s.includes('생산')) return 'MFG';

    // Default fallback based on commonality
    return 'BIZ';
};
