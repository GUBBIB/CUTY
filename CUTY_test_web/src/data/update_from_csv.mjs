import fs from 'fs';

function parseCSV(text) {
    const result = [];
    let row = [];
    let cell = '';
    let inQuotes = false;
    for (let c of text) {
        if (c === '"') {
            inQuotes = !inQuotes;
        } else if (c === ',' && !inQuotes) {
            row.push(cell.trim());
            cell = '';
        } else if (c === '\n' && !inQuotes) {
            row.push(cell.trim());
            result.push(row);
            row = [];
            cell = '';
        } else {
            cell += c;
        }
    }
    if (cell || row.length) {
        row.push(cell.trim());
        result.push(row);
    }
    return result;
}

const csvText = fs.readFileSync('c:/Users/qorgu/Desktop/CUTY/frontend/CUTY_test_web/src/data/e-7 code.csv', 'utf8');
const parsed = parseCSV(csvText);

const codeToExample = {};
parsed.forEach((row, i) => {
    if (i === 0 || row.length < 3) return;
    let code = row[0].replace('S', '');
    codeToExample[code] = row[2].replace(/\n/g, ' ').replace(/\r/g, '').trim();
});

let reqText = fs.readFileSync('c:/Users/qorgu/Desktop/CUTY/frontend/CUTY_test_web/src/data/e7_requirements.js', 'utf8');

for (const [code, example] of Object.entries(codeToExample)) {
    const regex = new RegExp(`("${code}"(?:\\s*:\\s*)(?:{[\\s\\S]*?employer\\s*:\\s*"))([^"]+)(")`, 'g');
    reqText = reqText.replace(regex, `$1${example}$3`);
}

fs.writeFileSync('c:/Users/qorgu/Desktop/CUTY/frontend/CUTY_test_web/src/data/e7_requirements.js', reqText, 'utf8');
console.log("Updated employer fields using e-7 code.csv.");
