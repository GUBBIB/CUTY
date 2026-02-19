import fs from 'fs';

const FILE_PATH = 'src/data/kvti_questions.json';
const data = JSON.parse(fs.readFileSync(FILE_PATH, 'utf8'));

let errorCount = 0;
const sections = [
    'part1_riasec',
    'part2_competency',
    'part3_job_pref',
    'part4_industry_pref',
    'part5_org_culture',
    'part6_residency'
];

const logStream = fs.createWriteStream('verification_log_v2.txt', { flags: 'w' });
const log = (msg) => {
    console.log(msg);
    logStream.write(msg + '\n');
};

log("=== KVTI Data Verification Log ===");

sections.forEach(section => {
    if (!data[section]) {
        log(`[CRITS] Missing section: ${section}`);
        errorCount++;
        return;
    }

    log(`\nChecking Section: ${section} (${data[section].length} items)`);

    data[section].forEach((q, idx) => {
        // Skip obvious IDs
        if (q.id === 'ID' || q.type === '코드' || (q.id && q.id.includes('가이드'))) {
            // These are metadata, mostly ignored by UI, but worth noting if they look broken
            if (!q.question && !q.id) {
                log(`  [WARN] Row ${idx}: Completely empty metadata row?`);
            }
            return;
        }

        // Check ID
        if (!q.id || typeof q.id !== 'string') {
            log(`  [ERR] Row ${idx}: Invalid ID (${q.id})`);
            errorCount++;
        }

        // Check Question Text
        if (!q.question || typeof q.question !== 'string' || q.question.trim() === "") {
            // UI fallback exists, but data should be clean
            log(`  [ERR] Row ${idx} (${q.id}): Empty or invalid Question text`);
            errorCount++;
        }

        // Check Type Specifics
        if (section === 'part2_competency' || section === 'part3_job_pref' || section === 'part4_industry_pref') {
            if (q.type !== 'Likert') {
                log(`  [WARN] Row ${idx} (${q.id}): Type is '${q.type}', expected 'Likert' for this section.`);
                // If it's Likert but has options, that's weird
                if (q.options && q.options.length > 0) {
                    log(`    -> Has options but should be Likert?`);
                }
            }
        }
    });
});

log(`\n=== Verification Complete: ${errorCount} Errors Found ===`);
logStream.end();
