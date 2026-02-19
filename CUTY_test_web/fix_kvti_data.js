import fs from 'fs';
const FILE_PATH = 'src/data/kvti_questions.json';

const data = JSON.parse(fs.readFileSync(FILE_PATH, 'utf8'));

// Fix Part 2: Competency
// Issue: Extracted as Select with 1 option (Skill Name) instead of Likert.
// Target: Question = "Category - SkillName", remove options.
if (data.part2_competency) {
    data.part2_competency = data.part2_competency.map(q => {
        // Skip headers
        if (q.id === 'ID' || q.type === '코드') return q;

        if (q.options && q.options.length === 1) {
            const skillName = q.options[0].label;
            // Append skill name to question if not already there
            const newQuestion = q.question === '문항' || q.question === 'OA' || q.question === '조직문화' || q.question === 'IT/기술' || q.question === '무역/영업'
                ? `${q.question} - ${skillName}`
                : skillName; // Just use skill name if question was generic

            return {
                id: q.id,
                question: newQuestion,
                type: 'Likert' // Force Likert for these
            };
        }
        return q;
    });
}

// Fix Part 5: Org Culture
// Issue: Might be same? The file snippet showed "CMP_C_05" Question "조직문화" Option "지시 이행".
// Let's check Part 5 too. In JSON it was `cmp_c`... wait.
// The snippet I saw had IDs like `CMP_C` in the 500-800 range.
// But in `Diagnosis.jsx` SECTIONS, Part 5 key is `part5_org_culture`.
// In `kvtiLogic.js`, I loop over `part5_org_culture`.
// I need to ensure `part5_org_culture` is the key in JSON where these CMP_C items exist.
// Actually, in the file snippet, lines 500+ were inside `part2_competency` array?
// No, I need to check where `part2_competency` ends and `part5` begins.
// But assuming the same "Select with 1 option" pattern exists elsewhere, I should fix it globally or for specific parts.
// Let's fix for `part2_competency` and `part5_org_culture`.

if (data.part5_org_culture) {
    data.part5_org_culture = data.part5_org_culture.map(q => {
        if (q.id === 'ID' || q.type === '코드') return q;
        if (q.options && q.options.length === 1) {
            const skillName = q.options[0].label;
            return {
                id: q.id,
                question: `${q.question} - ${skillName}`,
                type: 'Likert'
            };
        }
        return q;
    });
}

// Also check Part 3 and 4?
// Part 3 Job Pref usually IS select. "Which job do you want?".
// Leave Part 3/4 alone unless they look weird.

fs.writeFileSync(FILE_PATH, JSON.stringify(data, null, 2));
console.log("Fixed kvti_questions.json");
