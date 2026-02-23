const fs = require('fs');
const data = JSON.parse(fs.readFileSync('./src/data/kvti_questions.json', 'utf8'));
const sections = ['part1_riasec', 'part3_job_pref', 'part4_industry_pref', 'part5_org_culture', 'part2_competency', 'part6_residency'];
let total = 0;
for (const key of sections) {
    const raw = data[key] || [];
    const valid = raw.filter(q => {
        if (!q) return false;
        const qt = q.question ? String(q.question) : "";
        const id = q.id ? String(q.id) : "";
        const isHeader = id === 'ID'
            || q.type === '코드'
            || qt.includes('문항')
            || /^[A-F]\.\s/.test(qt)
            || id.includes('가이드')
            || id.includes('척도')
            || id.includes('로직')
            || id.includes('UI')
            || qt.includes('개발자 가이드')
            || (q.question === null && q.type === 'select' && (!q.options || q.options.length === 0));
        return !isHeader;
    });
    console.log(key + ': ' + valid.length);
    total += valid.length;
}
console.log('Total: ' + total);
