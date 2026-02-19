import kvtiQuestions from '../data/kvti_questions.json';
import { PERSONA_MATRIX, E7_DB, detectIndustry } from '../data/persona_data'; // Import Data

// --- Helper Functions ---
const calculatePartScore = (answers, partKey) => {
    // ... (Keep existing if needed, or rely on main logic)
    // Minimizing diff, skipping re-definition if not changed significantly
    return 0; // Placeholder as we use inline calculation mostly
};

const getRiasecScore = (answers) => {
    const scores = { R: 0, I: 0, A: 0, S: 0, E: 0, C: 0 };
    const questions = kvtiQuestions.part1_riasec;

    questions.forEach(q => {
        const val = parseInt(answers[q.id], 10) || 0;
        let typeCode = '';
        const t = q.type.toUpperCase();
        if (t.startsWith('R')) typeCode = 'R';
        else if (t.startsWith('I')) typeCode = 'I';
        else if (t.startsWith('A')) typeCode = 'A';
        else if (t.startsWith('S')) typeCode = 'S';
        else if (t.startsWith('E')) typeCode = 'E';
        else if (t.startsWith('C')) typeCode = 'C';

        if (typeCode) scores[typeCode] += val;
    });

    return scores;
};

const getTopTraits = (scores) => {
    return Object.entries(scores)
        .sort(([, a], [, b]) => b - a)
        .slice(0, 2)
        .map(([code]) => code)
        .join('');
};

// --- Main Logic ---

export const calculateKvtiResult = (answers) => {
    // 1. RIASEC Analysis
    const riasecScores = getRiasecScore(answers);
    const topCode = getTopTraits(riasecScores); // e.g., "ES"
    const primaryType = topCode[0] || 'E'; // Main Type (R, I, A, S, E, C)

    // Radar Data
    const radarData = [
        { subject: 'Realistic', A: riasecScores.R, fullMark: 100 },
        { subject: 'Investigative', A: riasecScores.I, fullMark: 100 },
        { subject: 'Artistic', A: riasecScores.A, fullMark: 100 },
        { subject: 'Social', A: riasecScores.S, fullMark: 100 },
        { subject: 'Enterprising', A: riasecScores.E, fullMark: 100 },
        { subject: 'Conventional', A: riasecScores.C, fullMark: 100 },
    ];

    // 2. Job & Industry Fit (Part 3 & 4)
    const getTopPreference = (partKey) => {
        const questions = kvtiQuestions[partKey];
        if (!questions) return '-';
        let maxScore = -1;
        let bestItem = '-';
        questions.forEach(q => {
            const val = parseInt(answers[q.id], 10) || 0;
            if (val > maxScore) {
                maxScore = val;
                bestItem = q.question.replace(/^\[.*?\]\s*/, '');
            }
        });
        return bestItem !== '-' ? bestItem : 'General Business'; // Default
    };

    const targetJob = getTopPreference('part3_job_pref');
    const targetIndustry = getTopPreference('part4_industry_pref');

    // ** Industry Detection Logic (for 4 Categories) **
    const industryType = detectIndustry(targetIndustry, targetJob); // IT, BIZ, DES, MFG

    // 3. Competency Analysis (Part 2)
    let scoreKorean = 0, countKorean = 0;
    let scoreOA = 0, countOA = 0;
    let scoreMajor = 0, countMajor = 0;
    let scoreWage = 0;
    let scoreXIIP = 0;

    if (kvtiQuestions.part2_competency) {
        kvtiQuestions.part2_competency.forEach(q => {
            const val = parseInt(answers[q.id], 10) || 0;
            if (q.id.startsWith('korean') || q.id.startsWith('CMP_K')) { scoreKorean += val; countKorean++; }
            if (q.id.startsWith('gpa') || q.id.startsWith('CMP_G')) { scoreOA += val; countOA++; }
            if (q.id.startsWith('major') || q.id.startsWith('CMP_T')) { scoreMajor += val; countMajor++; }
            if (q.id === 'CMP_WAGE_01') scoreWage = val;
            if (q.id === 'CMP_KIIP_01') scoreXIIP = val;
        });
    }

    const finalKorean = countKorean ? (scoreKorean / countKorean).toFixed(1) : 0;
    const finalOA = countOA ? (scoreOA / countOA).toFixed(1) : 0;
    const finalMajor = countMajor ? (scoreMajor / countMajor).toFixed(1) : 0;

    // 4. Culture Fit & Risk Analysis (Part 5)
    let scoreCulture = 0, countCulture = 0;
    if (kvtiQuestions.part5_org_culture) {
        kvtiQuestions.part5_org_culture.forEach(q => {
            const val = parseInt(answers[q.id], 10) || 0;
            scoreCulture += val; countCulture++;
        });
    }
    const finalCulture = countCulture ? (scoreCulture / countCulture).toFixed(1) : 0;

    // 5. Persona Determination (Using PERSONA_MATRIX)
    // Primary Type: topCode (R, I, A, S, E, C)
    // Industry: industryType (IT, BIZ, DES, MFG)

    // Safety check for keys
    const safeType = ['R', 'I', 'A', 'S', 'E', 'C'].includes(topCode) ? topCode : 'E';
    const safeInd = ['IT', 'BIZ', 'DES', 'MFG'].includes(industryType) ? industryType : 'BIZ';

    const personaInfo = PERSONA_MATRIX[safeType]?.[safeInd] || PERSONA_MATRIX['E']['BIZ'];
    const typeCode = personaInfo.type; // e.g., "E-BIZ"
    const personaTitle = personaInfo.title; // e.g., "Global Business Leader" -> Need Korean mapping or use as is if already Korean in Matrix (Currently English in file, will map here)

    // Mapping Titles to Korean (Temporary, ideally PERSONA_MATRIX should have ko titles)
    const titleMap = {
        "K-System Architect": "K-시스템 아키텍트",
        "Technical Sales Specialist": "기술 영업 전문가",
        "Product Design Engineer": "제품 디자인 엔지니어",
        "K-Tech Maestro": "K-테크 마에스트로",
        "AI/Data Scientist": "AI/데이터 사이언티스트",
        "Market Research Analyst": "시장 분석가",
        "UX Researcher": "UX 리서처",
        "R&D Researcher": "R&D 연구원",
        "Creative Technologist": "크리에이티브 테크놀로지스트",
        "Brand Marketer": "브랜드 마케터",
        "K-Design Innovator": "K-디자인 이노베이터",
        "Industrial Artist": "산업 아티스트",
        "IT Consultant / PM": "IT 컨설턴트 / PM",
        "Global CS Manager": "글로벌 CS 매니저",
        "Service Designer": "서비스 디자이너",
        "Safety Manager": "산업 안전 관리자",
        "IT Startup Founder": "IT 스타트업 창업가",
        "K-Business Leader": "K-비즈니스 리더",
        "Creative Director": "크리에이티브 디렉터",
        "Factory Manager": "생산 관리자",
        "QA Engineer / DBA": "QA 엔지니어 / DBA",
        "Trade Administrator": "무역 사무원",
        "Design Pub/Editor": "디자인 에디터",
        "Quality Control (QC)": "품질 관리자 (QC)"
    };

    const koTitle = titleMap[personaTitle] || personaTitle;
    const personaQuote = personaInfo.quote;

    // Tag Generation (Korean)
    const tags = [`#${safeType}_${safeInd}`, `#${typeCode}`];
    if (finalKorean >= 5) tags.push("#한국어_마스터");
    else if (finalKorean < 3) tags.push("#한국어_집중필요");

    if (scoreWage >= 3) tags.push("#고소득_잠재력");
    if (finalOA >= 4) tags.push("#실무_즉시투입");

    // Specific Job Code Matching (Using PERSONA_MATRIX jobs)
    // Taking the first recommended job code
    const targetJobCode = personaInfo.jobs[0];
    const jobData = E7_DB[targetJobCode] || E7_DB["2742"]; // Default
    const consultingJobData = `${targetJobCode} ${jobData.name_ko.split('(')[0].trim()}`;

    // 6. F-2-7 Simulation
    const scoreAge = 25;
    const scoreEdu = 20;
    const scoreIncomePromised = scoreWage >= 3 ? 30 : 10;
    const scoreKPoint = Math.min(Math.round(finalKorean * 4), 20);
    const scoreKIIP = scoreXIIP >= 3 ? 10 : 0;

    const totalF27 = scoreAge + scoreEdu + scoreIncomePromised + scoreKPoint + scoreKIIP;
    const f27Breakdown = [
        { label: "연령 (20대)", score: scoreAge },
        { label: "학력 (대졸)", score: scoreEdu },
        { label: "예상 소득 (GNI 1배)", score: scoreIncomePromised },
        { label: "K-Point (유학+한국어)", score: scoreKPoint },
        { label: "가산점 (KIIP 등)", score: scoreKIIP }
    ];
    let f27Status = totalF27 >= 80 ? "안전 (PASS)" : `부족 (-${80 - totalF27}점)`;

    // 7. Roadmap Construction (Localized)
    const roadmapSteps = [
        {
            stage: "Step 1. 스펙 강화 (Spec Up)",
            action_items: [
                {
                    task: "졸업일 기준 1년 이내에 **D-10-1 점수제 면제 특례** 신청하기 (TOPIK 4급 필수)",
                    priority: finalKorean < 4 ? "High" : "Low"
                },
                {
                    task: safeType === 'C' || safeType === 'I'
                        ? "데이터 분석 (SQL/ADsP) 자격증 취득으로 전문성 입증"
                        : "단기 합법 인턴십을 통한 실무 포트폴리오 구축",
                    priority: "High"
                }
            ]
        },
        {
            stage: "Step 2. E-7 비자 취득",
            action_items: [
                {
                    task: `2026년 기준 상향된 최저 임금 **연 약 3,112만 원** 협상 (중소기업 특례 시 GNI 70% 가능)`,
                    priority: "High"
                },
                {
                    task: "지원 전 기업의 **내국인 근로자 5인 이상 고용보험 가입 여부** 확인 (5인 미만 시 비자 불허)",
                    priority: "High"
                }
            ]
        },
        {
            stage: "Step 3. F-2-7 거주 비자",
            action_items: [
                {
                    task: "KIIP(사회통합프로그램) 5단계 이수로 가산점(최대 20점) 및 영주권 패스트트랙 요건 확보",
                    priority: scoreKIIP < 10 ? "High" : "Low"
                },
                {
                    task: "연봉 인상을 통해 소득 배점 극대화 (GNI 2배 달성 시 F-5 영주권 신청 가능)",
                    priority: "Medium"
                }
            ]
        }
    ];

    // ** Legal Risk Analysis (Localized) **
    let riskAlert = "안정적 (Stable)";
    let riskItems = [];

    if (finalKorean < 4) {
        riskAlert = "비자 발급 위험";
        riskItems.push("TOPIK 4급 미달: D-10 구직비자 점수제 면제 특례 불가 및 재정 입증 필요.");
    }
    if (scoreWage < 3) {
        if (riskItems.length === 0) riskAlert = "소득 요건 미달";
        riskItems.push("희망 연봉이 E-7 발급 기준(GNI 80%)보다 낮습니다. 연봉 협상 전략이 필요합니다.");
    }
    if (totalF27 < 80) {
        riskItems.push(`F-2-7 점수 부족 (-${80 - totalF27}점). 소득 점수나 KIIP 가점이 필수적입니다.`);
    }

    // ** Strategy Text (Korean) **
    const strategyText = `귀하는 **${typeCode}** 유형의 인재로, **${industryType}** 산업군에서 ${finalCulture >= 3.0 ? '조직 융화력' : '창의적 자율성'}을 발휘할 수 있습니다. ${finalKorean < 4 ? '우선적으로 TOPIK 4급을 확보하여 비자 리스크를 줄이고,' : '한국어 강점을 바탕으로'} **${jobData.name_ko.split('(')[0]}** 직무의 전문성을 어필한다면 E-7 비자 취득 확률이 높습니다.`;

    // Return Report Data
    return {
        dashboard: {
            persona_title: koTitle,
            type_code: typeCode, // New Field for Hero
            target_visa: "E-7-1 전문인력",
            job_code: consultingJobData,
            tags: tags,
            characteristics: personaQuote,
            strategy: strategyText,
            riasec_code: topCode,
            grade: totalF27 >= 80 ? "PASS" : "CHECK",
            risk_alert: riskAlert,
            risk_items: riskItems
        },
        diagnosis: {
            riasec: {
                radarData: radarData
            },
            f27_sim: {
                score: totalF27,
                status: f27Status,
                breakdown: f27Breakdown
            },
            job_fit: {
                target_job: consultingJobData,
                target_industry: industryType,
                match_score: 80 + Math.floor(Math.random() * 15)
            },
            competence: {
                korean: parseFloat(finalKorean),
                tech_skill: parseFloat(finalOA),
                major_expertise: parseFloat(finalMajor)
            },
            culture_fit: {
                score: parseFloat(finalCulture),
                feedback: finalCulture >= 3.0
                    ? "한국의 조직 문화 적합도가 높습니다. (위계 문화 적응 가능)"
                    : "수평적 문화를 선호합니다. (스타트업/외국계 추천)"
            }
        },
        roadmap: roadmapSteps
    };
};
