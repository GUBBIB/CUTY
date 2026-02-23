import fs from 'fs';

let content = fs.readFileSync('c:/Users/qorgu/Desktop/CUTY/frontend/CUTY_test_web/src/data/e7_requirements.js', 'utf8');

const regex = /employer:\n?\s*"([^"]+)"/g;
content = content.replace(regex, (match, p1) => {
    if (p1.includes('(예:')) return match; // Already has it

    // Add generic but realistic examples based on keywords in p1 or the code before it
    let examples = "관련 유망 중소/중견기업 및 대기업";
    if (p1.includes("교육") || p1.includes("학교") || p1.includes("학원")) examples = "연세대, 고려대, 에듀테크 기업 등 주요 교육기관";
    else if (p1.includes("병원") || p1.includes("의료")) examples = "서울대학교병원, 아산병원 등 주요 대형 및 전문 의료기관";
    else if (p1.includes("호텔") || p1.includes("관광") || p1.includes("면세")) examples = "신라호텔, 롯데면세점, 하나투어 등 4성급 이상 관광호텔 및 여행사";
    else if (p1.includes("제조") || p1.includes("생산") || p1.includes("기계")) examples = "반월/시화, 창원 등 주요 국가산업단지 내 우수 제조 기업";
    else if (p1.includes("엔지니어링") || p1.includes("건설")) examples = "국내 주택/토목 및 플랜트 시공/설계 전문 엔지니어링 기업";
    else if (p1.includes("연구") || p1.includes("과학")) examples = "KIST, ETRI 등 정부출연연구기관 및 주요 대기업 R&D 센터";
    else if (p1.includes("무역") || p1.includes("상사")) examples = "글로벌 종합상사 및 K-뷰티/푸드 수출입 강소기업";
    else if (p1.includes("IT") || p1.includes("소프트웨어") || p1.includes("시스템")) examples = "판교 테크노밸리 내 유망 IT 기술 기반 스타트업 및 중견기업";
    else if (p1.includes("디자인") || p1.includes("예술") || p1.includes("방송")) examples = "성수/마포 기반의 트렌디한 디자인 에이전시 및 방송/미디어 스튜디오";
    else if (p1.includes("법률") || p1.includes("회계")) examples = "주요 법무법인, 회계법인 및 다국적 기업 한국 지사 법무팀";
    else examples = "해당 직무와 연관된 성장성 높은 국내 우수 강소/중견기업";

    return `employer: "${p1} (예: ${examples})"`;
});

fs.writeFileSync('c:/Users/qorgu/Desktop/CUTY/frontend/CUTY_test_web/src/data/e7_requirements.js', content, 'utf8');
console.log("Updated remaining employers in e7_requirements.js!");
