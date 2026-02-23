const fs = require('fs');

// 1. Load Data
const questions = JSON.parse(fs.readFileSync('./src/data/kvti_questions.json', 'utf8'));

const SECTIONS = [
    { key: 'part1_riasec', title: 'Part 1. 직업 흥미 (RIASEC)', type: 'Job Interest' },
    { key: 'part3_job_pref', title: 'Part 2. 직무 선호 (Job Preference)', type: 'Preference' },
    { key: 'part4_industry_pref', title: 'Part 3. 산업 선호 (Industry Preference)', type: 'Preference' },
    { key: 'part5_org_culture', title: 'Part 4. 조직 문화 (Organizational Culture)', type: 'Personality' },
    { key: 'part2_competency', title: 'Part 5. 직무 역량 (Competency)', type: 'Self Assessment' },
    { key: 'part6_residency', title: 'Part 6. 거주/비자 의지 (Residency)', type: 'Legality' }
];

// 2. Persona Data (Hardcoded from src/data/persona_data.js to avoid ESM issues)
const PERSONA_MATRIX = {
    "R": {
        "IT": { title: "K-System Architect", type: "R-IT", jobs: ["2211", "2223"], quote: "안정적인 시스템을 구축하는 기술 전문가" },
        "BIZ": { title: "Technical Sales Specialist", type: "R-BIZ", jobs: ["2742"], quote: "기술적 이해를 바탕으로 신뢰를 주는 영업가" },
        "DES": { title: "Product Design Engineer", type: "R-DES", jobs: ["2841"], quote: "기능과 미학을 겸비한 실용적 디자이너" },
        "MFG": { title: "K-Tech Maestro", type: "R-MFG", jobs: ["2351", "2352"], quote: "한국 제조업을 이끌어갈 엔지니어링 마스터" }
    },
    "I": {
        "IT": { title: "AI/Data Scientist", type: "I-IT", jobs: ["2224", "2211"], quote: "데이터로 세상을 읽는 핵심 인재" },
        "BIZ": { title: "Market Research Analyst", type: "I-BIZ", jobs: ["2731"], quote: "데이터에 기반한 예리한 전략가" },
        "DES": { title: "UX Researcher", type: "I-DES", jobs: ["2855"], quote: "사용자의 행동을 분석하고 설계하는 연구자" },
        "MFG": { title: "R&D Researcher", type: "I-MFG", jobs: ["2352", "2351"], quote: "첨단 기술을 연구하고 개발하는 혁신가" }
    },
    "A": {
        "IT": { title: "Creative Technologist", type: "A-IT", jobs: ["2223"], quote: "기술과 예술을 결합하는 멀티플레이어" },
        "BIZ": { title: "Brand Marketer", type: "A-BIZ", jobs: ["2629"], quote: "스토리가 있는 브랜드를 만드는 기획자" },
        "DES": { title: "K-Design Innovator", type: "A-DES", jobs: ["2855", "2841"], quote: "시선을 사로잡는 독창적인 크리에이터" },
        "MFG": { title: "Industrial Artist", type: "A-MFG", jobs: ["2841"], quote: "제품에 감성을 불어넣는 아티스트" }
    },
    "S": {
        "IT": { title: "IT Consultant / PM", type: "S-IT", jobs: ["2223"], quote: "팀을 조율하고 프로젝트를 이끄는 리더" },
        "BIZ": { title: "Global CS Manager", type: "S-BIZ", jobs: ["2742"], quote: "사람의 마음을 움직이는 소통 전문가" },
        "DES": { title: "Service Designer", type: "S-DES", jobs: ["2855"], quote: "고객의 경험을 최우선으로 생각하는 디자이너" },
        "MFG": { title: "Safety Manager", type: "S-MFG", jobs: ["2351"], quote: "현장의 안전과 동료를 지키는 리더" }
    },
    "E": {
        "IT": { title: "IT Startup Founder", type: "E-IT", jobs: ["2224"], quote: "기술로 새로운 비즈니스를 만드는 창업가" },
        "BIZ": { title: "K-Business Leader", type: "E-BIZ", jobs: ["2742", "2629", "2731"], quote: "글로벌 시장을 개척하는 도전적인 리더" },
        "DES": { title: "Creative Director", type: "E-DES", jobs: ["2629"], quote: "트렌드를 리드하고 비전을 제시하는 디렉터" },
        "MFG": { title: "Factory Manager", type: "E-MFG", jobs: ["2351"], quote: "생산 효율을 극대화하는 현장 관리자" }
    },
    "C": {
        "IT": { title: "QA Engineer / DBA", type: "C-IT", jobs: ["2211"], quote: "시스템의 결함을 찾고 완벽을 추구하는 전문가" },
        "BIZ": { title: "Trade Administrator", type: "C-BIZ", jobs: ["2742"], quote: "복잡한 절차를 완벽하게 수행하는 행정 전문가" },
        "DES": { title: "Design Pub/Editor", type: "C-DES", jobs: ["2855"], quote: "디테일을 놓치지 않는 꼼꼼한 편집자" },
        "MFG": { title: "Quality Control (QC)", type: "C-MFG", jobs: ["2351"], quote: "최고의 품질을 보증하는 깐깐한 검수자" }
    }
};

// 3. Build Output Content
let doc = "";
const hr = "================================================================================\n";
const subHr = "--------------------------------------------------------------------------------\n";

// HEADER
doc += hr;
doc += "                          KVTI 진단 시스템 상세 정의서\n";
doc += hr;
doc += `생성 일시: ${new Date().toISOString()}\n`;
doc += "문서 개요: 본 문서는 KVTI(Korea Visa & Talent Indicator) 진단 시스템의\n";
doc += "           1) 문항 구성, 2) 결과 도출 로직, 3) 페르소나 시스템, 4) 전체 문항 상세를 포함함.\n\n";

// SECTION 1: SYSTEM STRUCTURE
doc += "1. 진단 문항 및 구조 개요 (System Structure)\n";
doc += subHr;
doc += "총 문항 수: 272문항 (사용자에게 노출되는 유효 문항 기준)\n\n";
doc += "   [섹션 구성]\n";

let totalCount = 0;
SECTIONS.forEach(sec => {
    const raw = questions[sec.key] || [];
    const valid = raw.filter(q => {
        if (!q) return false;
        const qt = q.question ? String(q.question) : "";
        const id = q.id ? String(q.id) : "";
        const isHeader = id === 'ID' || q.type === '코드' || qt.includes('문항') || /^[A-F]\.\s/.test(qt) || id.includes('가이드') || id.includes('척도') || id.includes('로직') || id.includes('UI') || qt.includes('개발자 가이드') || (q.question === null && q.type === 'select' && (!q.options || q.options.length === 0));
        return !isHeader;
    });
    doc += `   - ${sec.title}: ${valid.length}문항\n`;
    totalCount += valid.length;
});
doc += `   ---------------------------------\n`;
doc += `   합계: ${totalCount}문항\n\n`;

// SECTION 2: CALCULATION LOGIC
doc += "\n2. 결과 도출 및 계산 로직 (Calculation Logic)\n";
doc += subHr;
doc += "A. 핵심 유형 도출 (RIASEC)\n";
doc += "   - Part 1(62문항)의 응답 값을 R, I, A, S, E, C 유형별로 합산.\n";
doc += "   - 가장 높은 점수를 받은 유형을 'Primary Type'으로 선정 (예: E형 - Enterprising).\n";
doc += "   - 상위 2개 유형을 조합하여 RIASEC 코드 생성 (예: ES).\n\n";

doc += "B. 산업 적합도 판별 (Industry Fit)\n";
doc += "   - Part 3(직무 선호) & Part 4(산업 선호)에서 선택한 문항의 키워드를 분석.\n";
doc += "   - 4가지 메인 카테고리로 매핑:\n";
doc += "     1) IT (Information Technology): 개발, 데이터, AI, 웹 등\n";
doc += "     2) BIZ (Business): 경영, 마케팅, 영업, 무역 등\n";
doc += "     3) DES (Design & Art): 디자인, 예술, 미디어, 콘텐츠 등\n";
doc += "     4) MFG (Manufacturing): 제조, 기계, 건설, 엔지니어링 등\n\n";

doc += "C. 24가지 페르소나 매칭 (Persona Mapping)\n";
doc += "   - 공식: [Primary Type (6종)] x [Industry Category (4종)] = 24가지 유형\n";
doc += "   - 예: Primary가 'E(진취형)'이고 산업이 'IT'라면 -> 'E-IT: IT Startup Founder' 페르소나 도출.\n\n";

doc += "D. F-2-7 비자 점수 시뮬레이션\n";
doc += "   - Part 2(역량) & Part 6(거주 의지) 응답을 기반으로 점수 계산.\n";
doc += "   - 평가 항목: 연령(25세 가정), 학력(대졸 가정), 예상 소득(연봉 협상력), 한국어 능력, 사회통합프로그램(KIIP) 이수 의지.\n";
doc += "   - 총점 80점 이상 시 'PASS(안전)', 미만 시 'CHECK(부족)' 등급 판정.\n\n";

// SECTION 3: PERSONA MATRIX
doc += "\n3. 24가지 페르소나 상세 정의 (24 Personas)\n";
doc += subHr;
doc += "Primary Type | Industry | Type Code | Title (Job Role) | Representative Quote\n";
doc += subHr;

Object.keys(PERSONA_MATRIX).forEach(pType => {
    Object.keys(PERSONA_MATRIX[pType]).forEach(ind => {
        const p = PERSONA_MATRIX[pType][ind];
        // Formatting for alignment
        const typeStr = `[${pType}]`.padEnd(5);
        const indStr = ind.padEnd(5);
        const codeStr = p.type.padEnd(7);
        const titleStr = p.title.padEnd(30);

        doc += `${typeStr} | ${indStr}    | ${codeStr} | ${titleStr} | "${p.quote}"\n`;
    });
});
doc += "\n";

// SECTION 4: QUESTION ITEMS
doc += "\n4. 전체 진단 문항 리스트 (Full Question List)\n";
doc += subHr;

SECTIONS.forEach(sec => {
    doc += `\n### ${sec.title}\n`;
    doc += `(응답 방식: ${sec.type})\n`;
    doc += subHr;

    const raw = questions[sec.key] || [];
    const valid = raw.filter(q => {
        if (!q) return false;
        const qt = q.question ? String(q.question) : "";
        const id = q.id ? String(q.id) : "";
        const isHeader = id === 'ID' || q.type === '코드' || qt.includes('문항') || /^[A-F]\.\s/.test(qt) || id.includes('가이드') || id.includes('척도') || id.includes('로직') || id.includes('UI') || qt.includes('개발자 가이드') || (q.question === null && q.type === 'select' && (!q.options || q.options.length === 0));
        return !isHeader;
    });

    valid.forEach((q, idx) => {
        doc += `${idx + 1}. [${q.id}] ${q.question}\n`;
        if (q.options) {
            doc += `   - 옵션: ${q.options.map(o => o.label).join(' / ')}\n`;
        }
    });
});

fs.writeFileSync('KVTI_System_Architecture.txt', doc);
console.log('Done.');
