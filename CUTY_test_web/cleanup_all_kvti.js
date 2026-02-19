import fs from 'fs';

const FILE_PATH = 'src/data/kvti_questions.json';
const data = JSON.parse(fs.readFileSync(FILE_PATH, 'utf8'));

const sections = [
    'part1_riasec',
    'part2_competency',
    'part3_job_pref',
    'part4_industry_pref',
    'part5_org_culture',
    'part6_residency'
];

let removedCount = 0;
let fixedCount = 0;

sections.forEach(section => {
    if (!data[section]) return;

    // Filter out garbage rows (Guide, Logic, Empty)
    data[section] = data[section].filter(q => {
        // Safe access
        const qText = q.question ? String(q.question) : "";
        const qId = q.id ? String(q.id) : "";

        // Identify Garbage
        const isGarbage =
            qId === 'ID' ||
            q.type === '코드' ||
            qId.includes('가이드') ||
            qId.includes('척도') ||
            qId.includes('로직') ||
            qId.includes('UI') ||
            qText.includes('개발자 가이드') ||
            qText.includes('점수 집계') ||
            (q.question === null && (!q.type || q.type === 'select')); // Empty rows without valid type

        // Special handling: Keep questions even if they have "Guide" word (e.g. Tour Guide)
        // But remove if ID specifically says "Developer Guide".

        if (isGarbage) {
            removedCount++;
            return false;
        }
        return true;
    });

    // Fix Types and Structures
    data[section] = data[section].map(q => {
        let newQ = { ...q };

        // Ensure ID is string
        if (typeof newQ.id !== 'string') newQ.id = String(newQ.id);

        // Part 2, 3, 4, 5, 6: Enforce Likert
        if (['part2_competency', 'part3_job_pref', 'part4_industry_pref', 'part5_org_culture', 'part6_residency'].includes(section)) {

            // Fix: If it has Options but should be Likert (e.g. leftover from select conversion)
            if (newQ.options && newQ.options.length > 0) {
                // Merge option label into question if it looks like part of the question
                // But check if we already did this (don't doubleid)
                const optLabel = newQ.options.map(o => o.label).join(' ');
                if (!newQ.question.includes(optLabel)) {
                    newQ.question = `${newQ.question} ${optLabel}`;
                }
                delete newQ.options;
            }

            newQ.type = 'Likert';
        }

        fixedCount++;
        return newQ;
    });
});

fs.writeFileSync(FILE_PATH, JSON.stringify(data, null, 2));
console.log(`Cleanup Complete. Removed ${removedCount} garbage rows. Processed ${fixedCount} valid items.`);
