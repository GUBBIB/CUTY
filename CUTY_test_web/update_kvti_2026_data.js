import fs from 'fs';

const FILE_PATH = 'src/data/kvti_questions.json';
const data = JSON.parse(fs.readFileSync(FILE_PATH, 'utf8'));

// 1. Add Wage & KIIP to Part 2 (Competency)
const newPart2Items = [
    {
        "id": "CMP_WAGE_01",
        "question": "나는 취업 시 2026년 정부 기준인 최소 연봉 약 3,112만 원(또는 중소기업 특례 2,700만 원) 이상을 협상해 낼 실무/언어 역량이 있다.",
        "type": "Likert"
    },
    {
        "id": "CMP_KIIP_01",
        "question": "법무부 주관 사회통합프로그램(KIIP)을 이수할 의향이 있거나, 이미 이수하고 있는가? (F-2-7 가점 및 거주 비자 필수)",
        "type": "Likert"
    }
];

// Check if already exists to prevent duplicate
newPart2Items.forEach(item => {
    if (!data.part2_competency.find(q => q.id === item.id)) {
        data.part2_competency.push(item);
        console.log(`Added Part 2 Item: ${item.id}`);
    }
});

// 2. Add E-7-3 / E-7-Y Questions to Part 3 (Job Preference)
// Targeting "K-Tech Maestro" (Manufacturing, Shipbuilding, Root Industry)
const newPart3Items = [
    {
        "id": "JOB_M_01",
        "question": "[E-7-3/Y] 첨단 사무실보다는 제조업, 조선소, 뿌리산업 현장에서 직접 기술을 익히고 일하는 것을 선호한다.",
        "type": "Likert"
    },
    {
        "id": "JOB_M_02",
        "question": "[E-7-3] 용접, 도장, 정밀가공 등 전문 기능직(Skilled Worker)으로서의 커리어를 쌓고 싶다.",
        "type": "Likert"
    }
];

newPart3Items.forEach(item => {
    if (!data.part3_job_pref.find(q => q.id === item.id)) {
        data.part3_job_pref.push(item);
        console.log(`Added Part 3 Item: ${item.id}`);
    }
});

fs.writeFileSync(FILE_PATH, JSON.stringify(data, null, 2));
console.log("KVTI Data Update Complete for 2026 Guidelines.");
