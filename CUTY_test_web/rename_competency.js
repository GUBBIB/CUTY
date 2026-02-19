import fs from 'fs';
const FILE_PATH = 'src/data/kvti_questions.json';

const data = JSON.parse(fs.readFileSync(FILE_PATH, 'utf8'));

const RENAMES = {
    // Korean Language (CMP_K)
    "CMP_K_01": "한국어 듣기 (Listening)",
    "CMP_K_02": "비즈니스 이메일 작성",
    "CMP_K_03": "한국어 전화 응대",
    "CMP_K_04": "한국어 말하기 (Speaking/Presentation)",
    "CMP_K_05": "한국어 문서 이해 (Reading)",
    "CMP_K_06": "한국 문화 및 어휘 이해",
    "CMP_K_07": "한국어 문법 활용",
    "CMP_K_08": "한국어 문서 작성 속도",
    "CMP_K_09": "업무 관련 전문 용어 이해",
    "CMP_K_10": "장시간 한국어 소통 능력",

    // Org Culture (CMP_C) - Removing "조직문화 - " prefix
    "CMP_C_01": "위계질서 적응력",
    "CMP_C_02": "보고 체계 준수",
    "CMP_C_03": "회식 및 식사 예절",
    "CMP_C_04": "근태 및 시간 약속",
    "CMP_C_05": "업무 지시 수용",
    "CMP_C_06": "조직 분위기 파악 (눈치)",
    "CMP_C_07": "사내 보안 준수",
    "CMP_C_08": "업무 처리 속도",
    "CMP_C_09": "조직을 위한 헌신",
    "CMP_C_10": "피드백 수용 태도",

    // OA (CMP_G) - Removing "OA - " prefix
    "CMP_G_01": "Excel 활용 능력",
    "CMP_G_02": "PPT 문서 디자인",
    "CMP_G_03": "한글(HWP) 문서 작성",
    "CMP_G_04": "협업 툴(Slack, Teams 등) 사용",
    "CMP_G_05": "정보 검색 및 수집 능력",
    "CMP_G_06": "PC/파일 관리 능력",
    "CMP_G_07": "비즈니스 매너 (이메일 등)",

    // Trade/Sales (CMP_T) - Removing "무역/영업 - " prefix
    "CMP_T_01": "이중언어 활용 능력",
    "CMP_T_02": "비즈니스 영어 회화",
    "CMP_T_03": "무역 실무 지식",
    "CMP_T_04": "신규 바이어/고객 발굴",
    "CMP_T_05": "무역/영업 서류 작성",
    "CMP_T_06": "적극적 영업 마인드",
    "CMP_T_07": "비즈니스 협상 기술",
    "CMP_T_08": "기초 마케팅 이해",

    // IT (CMP_I) - Removing "IT/기술 - " prefix
    "CMP_I_01": "프로그래밍/코딩 능력",
    "CMP_I_02": "웹(Web) 개발 역량",
    "CMP_I_03": "데이터베이스(DB) 관리",
    "CMP_I_04": "버전 관리(Git 등) 활용",
    "CMP_I_05": "기술적 문제 해결 능력",
    "CMP_I_06": "서버 및 인프라 이해",
    "CMP_I_07": "데이터 분석 능력",
    "CMP_I_08": "신기술 습득 속도"
};

if (data.part2_competency) {
    data.part2_competency = data.part2_competency.map(q => {
        if (RENAMES[q.id]) {
            return {
                ...q,
                question: RENAMES[q.id]
            };
        }
        return q;
    });
}

// Special check: Part 5 Org Culture might be duplicate in Part 2 or exist in Part 5
// Based on file, CMP_C items were inside part2_competency?
// Let's also check part5_org_culture just in case
if (data.part5_org_culture) {
    data.part5_org_culture = data.part5_org_culture.map(q => {
        if (RENAMES[q.id]) {
            return {
                ...q,
                question: RENAMES[q.id]
            };
        }
        return q;
    });
}

fs.writeFileSync(FILE_PATH, JSON.stringify(data, null, 2));
console.log("Renamed Competency Questions");
