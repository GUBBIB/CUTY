import { KVTI_DICTIONARY } from '../data/kvti_dictionary';
import { E7_DESCRIPTIONS } from '../data/e7_official_descriptions';
import { E7_REQUIREMENTS } from '../data/e7_requirements';
import { E7_DB } from '../data/persona_data';

/**
 * TRAIT_DICTIONARY
 * Hardcoded text modules for each of the 10 KVTI letters.
 * This object is used to dynamically construct the comprehensive report text.
 */
const TRAIT_DICTIONARY = {
    // 1st Letter: Work Style
    "A": "데이터와 팩트를 기반으로 합리적이고 객관적인 결정을 내리는 '분석적 사고'가 뛰어나며, 리스크를 미리 예측하고 통제하는 환경에서 높은 성과를 냅니다. 불확실성 속에서도 명확한 인과관계를 찾아내어 조직의 비용을 절감하고 효율성을 극대화하는 든든한 닻(Anchor) 역할을 수행할 잠재력이 높습니다.",
    "C": "정해진 틀을 깨고 직관과 창의성을 바탕으로 새로운 가치를 창출하는 데 능합니다. 모호한 상황 속에서도 기회를 포착하고, 기존의 방식을 혁신하여 타겟 고객이나 시장에 매력적인 인사이트를 던지는 훌륭한 크리에이터 기질을 가지고 있습니다. 빠른 트렌드 변화에 적응해야 하는 산업군에서 두각을 나타냅니다.",
    "P": "추상적인 이론이나 책상물림 논의보다는 실제 현장(Field)과 실무에서 직접 부딪히며 몸으로 문제를 해결하는 전형적인 '실용주의자'입니다. 현장 상황을 민첩하게 장악하고, 손과 발을 움직여 즉각적인 결과물을 만들어내는 강력한 실행력이 가장 큰 무기입니다.",
    "E": "도전적이고 진취적인 자세로 타인을 이끌며 목표를 향해 나아가는 타고난 리더십을 갖추었습니다. 프로젝트의 전면에 나서서 사람들을 설득하고, 결단력 있게 사업을 추진하는 과정에서 뿜어져 나오는 강한 에너지는 조직의 성장 동력(Engine)으로 작용합니다.",

    // 2nd Letter: Organizational Culture Fit
    "H": "체계적인 매뉴얼과 명확한 위계질서, 그리고 안정적인 시스템이 갖춰진 거대 조직 형태(수직적/대기업형)의 근무 환경을 선호합니다. 정해진 역할 분담 속에서 규칙을 준수하고 책임감을 가지고 임무를 완수하며, 조직의 안정적인 유지와 성장에 필수적인 코어 톱니바퀴 역할을 수행하는 데 익숙합니다.",
    "F": "얽매이는 룰과 보수적인 위계질서보다는, 개인의 자율성이 보장되고 언제든 의견을 자유롭게 펼칠 수 있는 수평적(Flat)이고 유연한 환경, 또는 창업 조직(스타트업)에서 최고의 효율을 도출합니다. 변화에 유연하게 대응하며 스스로 과제를 설정하고 주도해 나가는 자기주도적 성향이 강합니다.",

    // 3rd Letter: Industry Preference
    "I": "IT, 소프트웨어, 테크놀로지, 인공지능 등 빠르게 기술이 진보하고 파괴적 혁신이 일어나는 지식 집약적 IT 산업군에 깊은 관심과 뛰어난 적합도를 보입니다. 디지털 환경에 대한 높은 이해력을 무기로 미래 산업의 변화를 주도할 수 있습니다.",
    "B": "무역, 마케팅, 경영지원, 세일즈, 컨설팅 등 수익을 창출하고 시장 내 점유율을 싸우는 전통적인 비즈니스 및 상경 계열 직군에 특화된 성향입니다. 사람과 돈의 흐름을 읽고 기업의 이윤을 극대화하는 데 흥미를 느낍니다.",
    "D": "시각 디자인, 패션, 콘텐츠 제작, 미디어 아트, 엔터테인먼트 등 미학적 감각과 대중의 트렌드를 선도하는 크리에이티브/미디어 산업군에 최적화된 재능을 지녔습니다. 문화적 영감과 예술적 민감성을 바탕으로 감성적인 부가가치를 창출해 냅니다.",
    "M": "제조업, 생산관리, 반도체 현장, 기계 설계, 설비 유지보수 등 눈에 보이는 물리적 제품을 다루고 공정을 고도화하는 실물 기반 제조/엔지니어링 산업군에 강점을 보입니다. 한국 경제의 든든한 허리인 기반 산업에서 없어서는 안 될 실무자로 성장할 수 있습니다."
};

const TRAIT_TITLES = {
    "A": "분석/관리 (Analyze)",
    "C": "창조/직관 (Create)",
    "P": "현장/실행 (Practical)",
    "E": "엔터프라이즈/리더 (Enterprise)",
    "H": "수직/안정 (Hierarchy)",
    "F": "수평/자율 (Flat)",
    "I": "IT/테크 (IT/Tech)",
    "B": "비즈니스 (Business)",
    "D": "디자인/미디어 (Design)",
    "M": "제조/엔지니어링 (Manufacturing)"
};

/**
 * generateReportData (Pure Function)
 * Combines hardcoded text modules, user's KVTI code, and master databases
 * to output a single, complete JSON state object for the Comprehensive Report.
 * Ready to be ported to a Node.js backend.
 * 
 * @param {string} resultCode - The 3-letter KVTI code (e.g., "BAF", "CHI")
 * @returns {Object} Structured report data containing summaryText, factorDetails, and topJobs.
 */
export function generateReportData(resultCode) {
    if (!resultCode || resultCode.length !== 3) {
        throw new Error("Invalid KVTI resultCode provided. Must be a 3-letter string.");
    }

    const kvtiUpper = resultCode.toUpperCase();
    const char1 = kvtiUpper.charAt(0); // P, C, A, E
    const char2 = kvtiUpper.charAt(1); // M, D, B, I
    const char3 = kvtiUpper.charAt(2); // H, F

    // 1. Generate Continuous Summary Text (Prose)
    // Combine the three parsed traits into a cohesive, highly verbose paragraph.
    const textPart1 = TRAIT_DICTIONARY[char1] || "";
    const textPart2 = TRAIT_DICTIONARY[char3] || "";
    const textPart3 = TRAIT_DICTIONARY[char2] || "";

    // We intertwine them to sound like a continuous consulting evaluation.
    const summaryText = `귀하에 대한 종합 성향 진단 결과, ${textPart1} 또한, 귀하는 조직 문화에 있어 ${textPart2} 마지막으로 귀하의 잠재력이 가장 폭발적으로 발현될 수 있는 핵심 산업 영역은 ${textPart3} 이러한 복합적인 특성들을 고려할 때, 귀하는 고유한 전문성을 띠면서도 조직에 빠르게 녹아들어 대체 불가능한 핵심 외국인 인재로 성장할 수 있는 매우 희귀한 자질을 갖추었습니다. 한국에서의 생존과 취업 성공률을 비약적으로 끌어올리기 위해서는 이 세 가지의 융합된 성향을 기업의 니즈에 정확히 맞추어 어필하는 전략이 필요합니다.`;

    // 2. Generate Factor Details (Deconstructed text for the Deep Dive section)
    const factorDetails = [
        {
            axisName: "1. 업무 수행 스타일",
            letter: char1,
            title: TRAIT_TITLES[char1] || char1,
            description: textPart1
        },
        {
            axisName: "2. 조직 문화 융화력",
            letter: char3,
            title: TRAIT_TITLES[char3] || char3,
            description: textPart2
        },
        {
            axisName: "3. 최적합 산업 군",
            letter: char2,
            title: TRAIT_TITLES[char2] || char2,
            description: textPart3
        }
    ];

    // 3. Assemble Job & Visa Requirement Master Data
    const coreCode = kvtiUpper.substring(0, 3);
    const dictionaryEntry = KVTI_DICTIONARY[coreCode] || KVTI_DICTIONARY[kvtiUpper];
    let topJobs = [];

    // Fallback if the code isn't explicitly in the dictionary
    const recommendedJobCodes = dictionaryEntry && dictionaryEntry.career_paths
        ? dictionaryEntry.career_paths.slice(0, 3)
        : ["2742", "2731", "2629"];

    topJobs = recommendedJobCodes.map(codeString => {
        // Find basic job info from E7_DB (persona_data.js)
        let name_ko = "추천 직무";
        let name_en = "";

        // E7_DB stores keys as numbers in some cases, so convert if necessary, or just check string
        const jobInfo = E7_DB[codeString] || E7_DB[parseInt(codeString)];
        if (jobInfo) {
            name_ko = jobInfo.name_ko.split('(')[0].trim(); // Remove parenthetical explanations
            name_en = jobInfo.name_en || "";
        }

        // Get Law definition
        let extractedCode = codeString;
        if (name_ko.includes("숙련기능")) extractedCode = "E-7-4";

        // Use defaults if master data is missing that specific code
        const lawDefinition = E7_DESCRIPTIONS[extractedCode] || "국가 경쟁력 제고를 위하여 전문적인 지식, 기술, 기능을 가진 외국인 인력 도입이 필요한 분야로서 법무부 장관이 지정하는 특정활동 직무입니다.";

        const visaRequirements = E7_REQUIREMENTS[extractedCode] || {
            education: "관련 분야 석사 학위 이상 소지자, 혹은 관련 학사 취득 후 1년 이상의 전문 경력을 공식적으로 증빙할 수 있는 자.",
            salary: "계약 연봉이 전년도 한국은행 발표 1인당 국민총소득(GNI)의 80% 이상 요건을 의무적으로 충족해야 함.",
            employer: "국민고용보호원칙이 적용되어, 고용 업체에 가입된 내국인 고용보험 가입자 수의 20% 이내 범위에서만 사증 발급이 허용됨."
        };

        // Synthesize dynamic readiness score between 80 and 99 for realism
        const pseudoScore = 99 - (codeString.charCodeAt(0) % 20);

        return {
            code: codeString,
            visaType: extractedCode === "E-7-4" ? "E-7-4 숙련기능" : "E-7-1 전문인력",
            title_ko: name_ko,
            title_en: name_en,
            readiness: pseudoScore,
            lawDefinition: lawDefinition,
            visaRequirements: visaRequirements,
            requiredCompetencies: [
                "심사관 및 사내 내국인 팀원과의 원활한 소통을 위한 고도화된 비즈니스 한국어 구사 능력 (TOPIK 4급 이상 권장)",
                "재학 중 특정활동(E-7) 분야와 일치하는 인턴십(D-2-4) 또는 현장실습 경험을 증빙하는 이력 및 포트폴리오 구축"
            ] // Always universally applicable for E-7
        };
    });

    // 4. Return Final Data Structure
    return {
        kvtiCode: kvtiUpper,
        personaTitle: dictionaryEntry ? dictionaryEntry.title : "융합형 잠재 인재",
        summaryText: summaryText,
        factorDetails: factorDetails,
        topJobs: topJobs
    };
}
