import fs from 'fs';
const FILE_PATH = 'src/data/kvti_questions.json';

const data = JSON.parse(fs.readFileSync(FILE_PATH, 'utf8'));

// Helper to fix split options and convert to Likert
const fixJobPart = (partKey) => {
    if (!data[partKey]) return;

    data[partKey] = data[partKey].map(q => {
        // Skip valid headers or guide rows (we'll keeping them as headers or filtering them)
        if (q.id === 'ID' || q.type === '코드') return q;

        // Check for the broken "Question = Number/ID, Options = Split text" pattern
        // Or "Question = null, ID = Guide"
        if (!q.question && typeof q.id === 'string' && (q.id.includes('가이드') || q.id.includes('척도'))) {
            // Keep as is, Diagnosis.jsx filters these now.
            return q;
        }

        // If options exist, we assume it's meant to be a Likert question description
        if (q.options && q.options.length > 0) {
            // Join options labels to form the full question text
            const textFromOptions = q.options.map(o => o.label).join('');

            // If original question was a number (Visa Code?), prepend it
            const prefix = (q.question && typeof q.question !== 'object') ? `[${q.question}] ` : '';

            return {
                id: q.id,
                question: prefix + textFromOptions,
                type: 'Likert' // Force Likert 1-5
            };
        }

        return q;
    });
};

// Apply to Part 3 and Part 4
fixJobPart('part3_job_pref');
fixJobPart('part4_industry_pref');

// Re-apply Part 2 and 5 fix just in case (idempotent-ish)
const fixCompetencePart = (partKey) => {
    if (!data[partKey]) return;
    data[partKey] = data[partKey].map(q => {
        if (q.id === 'ID' || q.type === '코드') return q;
        // If type is already Likert, skip
        if (q.type === 'Likert') return q;

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
};
fixCompetencePart('part2_competency');
fixCompetencePart('part5_org_culture');

fs.writeFileSync(FILE_PATH, JSON.stringify(data, null, 2));
console.log("Fixed KVTI Data Part 3/4");
