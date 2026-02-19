export const E7_DB = {
    // IT & Tech
    "2223": {
        code: "2223",
        name_ko: "웹 개발자 (Web Developer)",
        desc: "웹사이트, 모바일 앱의 프론트엔드/백엔드 시스템을 설계하고 구축하는 전문가입니다.",
        req: {
            degree: "Bachelor (Relevant Major)",
            wage: "GNI x 0.8 (approx. 32M KRW)",
            major: ["Computer Science", "Software Engineering"],
            korean: 2 // Preferred but not strict if wage is high
        },
        hot_skills: ["React", "Node.js", "AWS", "TypeScript"]
    },
    "2224": {
        code: "2224",
        name_ko: "응용 소프트웨어 개발자 (App Developer)",
        desc: "PC 및 모바일 디바이스용 애플리케이션을 개발하는 전문가입니다.",
        req: { degree: "Bachelor", wage: "GNI x 0.8", major: ["CS", "IT"], korean: 2 },
        hot_skills: ["Flutter", "Kotlin", "Swift", "Unity"]
    },
    "2211": {
        code: "2211",
        name_ko: "시스템 소프트웨어 개발자 (System SW)",
        desc: "OS, 펌웨어, 임베디드 시스템 등을 다루는 고난도 기술 직군입니다.",
        req: { degree: "Bachelor", wage: "GNI x 0.8", major: ["EE", "CS"], korean: 2 },
        hot_skills: ["C/C++", "Linux", "Embedded", "RTOS"]
    },

    // Business & Trade
    "2742": {
        code: "2742",
        name_ko: "해외 영업원 (Overseas Sales)",
        desc: "한국 기업의 제품을 해외 바이어에게 판매하고 수출 계약을 성사시킵니다.",
        req: {
            degree: "Bachelor",
            wage: "GNI x 0.8",
            major: ["Business", "Language", "Economics"],
            korean: 4 // High proficiency required
        },
        hot_skills: ["Business English", "Trading Laws", "Communication"]
    },
    "2731": {
        code: "2731",
        name_ko: "상품 기획 전문가 (Merchandiser)",
        desc: "시장 트렌드를 분석하여 경쟁력 있는 신상품을 기획하고 런칭합니다.",
        req: { degree: "Bachelor", wage: "GNI x 0.8", major: ["Marketing", "Business"], korean: 4 },
        hot_skills: ["Market Research", "Trend Analysis", "Planning"]
    },
    "2629": {
        code: "2629",
        name_ko: "마케팅 전문가 (Marketing Specialist)",
        desc: "브랜드 인지도를 높이고 고객을 유입시키는 전략을 수립합니다.",
        req: { degree: "Bachelor", wage: "GNI x 0.8", major: ["Advertising", "Business"], korean: 4 },
        hot_skills: ["Digital Marketing", "SEO/SEM", "Content Strategy"]
    },

    // Design & Creative
    "2855": {
        code: "2855",
        name_ko: "웹/멀티미디어 디자이너 (UI/UX)",
        desc: "사용자 경험(UX)을 고려하여 웹과 앱의 인터페이스를 디자인합니다.",
        req: { degree: "Bachelor", wage: "GNI x 0.8", major: ["Design", "Art"], korean: 3 },
        hot_skills: ["Figma", "Adobe Suite", "Prototyping"]
    },
    "2841": {
        code: "2841",
        name_ko: "제품 디자이너 (Product Designer)",
        desc: "제품의 기능과 심미성을 고려하여 외관을 디자인합니다.",
        req: { degree: "Bachelor", wage: "GNI x 0.8", major: ["Industrial Design"], korean: 3 },
        hot_skills: ["3D Rendering", "CAD", "Material Sense"]
    },

    // Manufacturing & Engineering
    "2351": {
        code: "2351",
        name_ko: "기계 공학 기술자 (Mechanical Engineer)",
        desc: "기계 장치나 설비를 설계, 개발하고 생산 공정을 관리합니다.",
        req: { degree: "Bachelor", wage: "GNI x 0.8", major: ["Mechanical Eng."], korean: 3 },
        hot_skills: ["AutoCAD", "SolidWorks", "CATIA"]
    },
    "2352": {
        code: "2352",
        name_ko: "로봇 공학 기술자 (Robotics Engineer)",
        desc: "산업용 로봇이나 자동화 시스템을 연구하고 개발합니다.",
        req: { degree: "Bachelor", wage: "GNI x 0.8", major: ["Robotics", "Mechatronics"], korean: 3 },
        hot_skills: ["ROS", "PLC", "Motion Control"]
    }
    // Add more as needed...
};

export const PERSONA_MATRIX = {
    // 1. Realistic (R) - The Doers
    R: {
        IT: { title: "K-System Architect", type: "R-IT", jobs: ["2211", "2223"], quote: "안정적인 시스템을 구축하는 기술 전문가" },
        BIZ: { title: "Technical Sales Specialist", type: "R-BIZ", jobs: ["2742"], quote: "기술적 이해를 바탕으로 신뢰를 주는 영업가" },
        DES: { title: "Product Design Engineer", type: "R-DES", jobs: ["2841"], quote: "기능과 미학을 겸비한 실용적 디자이너" },
        MFG: { title: "K-Tech Maestro", type: "R-MFG", jobs: ["2351", "2352"], quote: "한국 제조업을 이끌어갈 엔지니어링 마스터" } // ** Signature Type **
    },
    // 2. Investigative (I) - The Thinkers
    I: {
        IT: { title: "AI/Data Scientist", type: "I-IT", jobs: ["2224", "2211"], quote: "데이터로 세상을 읽는 핵심 인재" }, // ** Signature Type **
        BIZ: { title: "Market Research Analyst", type: "I-BIZ", jobs: ["2731"], quote: "데이터에 기반한 예리한 전략가" },
        DES: { title: "UX Researcher", type: "I-DES", jobs: ["2855"], quote: "사용자의 행동을 분석하고 설계하는 연구자" },
        MFG: { title: "R&D Researcher", type: "I-MFG", jobs: ["2352", "2351"], quote: "첨단 기술을 연구하고 개발하는 혁신가" }
    },
    // 3. Artistic (A) - The Creators
    A: {
        IT: { title: "Creative Technologist", type: "A-IT", jobs: ["2223"], quote: "기술과 예술을 결합하는 멀티플레이어" },
        BIZ: { title: "Brand Marketer", type: "A-BIZ", jobs: ["2629"], quote: "스토리가 있는 브랜드를 만드는 기획자" },
        DES: { title: "K-Design Innovator", type: "A-DES", jobs: ["2855", "2841"], quote: "시선을 사로잡는 독창적인 크리에이터" }, // ** Signature Type **
        MFG: { title: "Industrial Artist", type: "A-MFG", jobs: ["2841"], quote: "제품에 감성을 불어넣는 아티스트" }
    },
    // 4. Social (S) - The Helpers
    S: {
        IT: { title: "IT Consultant / PM", type: "S-IT", jobs: ["2223"], quote: "팀을 조율하고 프로젝트를 이끄는 리더" },
        BIZ: { title: "Global CS Manager", type: "S-BIZ", jobs: ["2742"], quote: "사람의 마음을 움직이는 소통 전문가" }, // ** Signature Type **
        DES: { title: "Service Designer", type: "S-DES", jobs: ["2855"], quote: "고객의 경험을 최우선으로 생각하는 디자이너" },
        MFG: { title: "Safety Manager", type: "S-MFG", jobs: ["2351"], quote: "현장의 안전과 동료를 지키는 리더" }
    },
    // 5. Enterprising (E) - The Persuaders
    E: {
        IT: { title: "IT Startup Founder", type: "E-IT", jobs: ["2224"], quote: "기술로 새로운 비즈니스를 만드는 창업가" },
        BIZ: { title: "K-Business Leader", type: "E-BIZ", jobs: ["2742", "2629", "2731"], quote: "글로벌 시장을 개척하는 도전적인 리더" }, // ** Signature Type **
        DES: { title: "Creative Director", type: "E-DES", jobs: ["2629"], quote: "트렌드를 리드하고 비전을 제시하는 디렉터" },
        MFG: { title: "Factory Manager", type: "E-MFG", jobs: ["2351"], quote: "생산 효율을 극대화하는 현장 관리자" }
    },
    // 6. Conventional (C) - The Organizers
    C: {
        IT: { title: "QA Engineer / DBA", type: "C-IT", jobs: ["2211"], quote: "시스템의 결함을 찾고 완벽을 추구하는 전문가" },
        BIZ: { title: "Trade Administrator", type: "C-BIZ", jobs: ["2742"], quote: "복잡한 절차를 완벽하게 수행하는 행정 전문가" },
        DES: { title: "Design Pub/Editor", type: "C-DES", jobs: ["2855"], quote: "디테일을 놓치지 않는 꼼꼼한 편집자" },
        MFG: { title: "Quality Control (QC)", type: "C-MFG", jobs: ["2351"], quote: "최고의 품질을 보증하는 깐깐한 검수자" } // ** Signature Type **
    }
};

export const detectIndustry = (targetIndustry, targetJob) => {
    // Defines logic to map Part 3/4 answers to 4 Categories
    const s = (targetIndustry || "") + (targetJob || "");

    if (s.includes('개발') || s.includes('IT') || s.includes('데이터') || s.includes('인공지능') || s.includes('정보통신')) return 'IT';
    if (s.includes('영업') || s.includes('마케팅') || s.includes('경영') || s.includes('무역') || s.includes('사무')) return 'BIZ';
    if (s.includes('디자인') || s.includes('예술') || s.includes('콘텐츠') || s.includes('미디어') || s.includes('방송')) return 'DES';
    if (s.includes('제조') || s.includes('기계') || s.includes('건설') || s.includes('전기') || s.includes('생산')) return 'MFG';

    // Default fallback based on commonality
    return 'BIZ';
};
