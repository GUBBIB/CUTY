import readXlsxFile from 'read-excel-file/node';
import fs from 'fs';

const FILE_PATH = 'src/data/KVTI_data.xlsx';
const OUTPUT_PATH = 'src/data/kvti_questions.json';

async function extractData() {
    const finalData = {};

    try {
        const sheets = await readXlsxFile(FILE_PATH, { getSheets: true });
        const sheetMap = {};

        // Dynamic matching
        sheets.forEach(s => {
            if (s.name.includes('Part 1')) sheetMap.PART1 = s.name;
            if (s.name.includes('Part 2')) sheetMap.PART2 = s.name;
            if (s.name.includes('Part 3')) sheetMap.PART3 = s.name;
            if (s.name.includes('Part 4')) sheetMap.PART4 = s.name;
            if (s.name.includes('Part 5')) sheetMap.PART5 = s.name;
            if (s.name.includes('Part 6')) sheetMap.PART6 = s.name;
        });

        console.log("Matched Sheets:", sheetMap);

        if (sheetMap.PART1) {
            const rows = await readXlsxFile(FILE_PATH, { sheet: sheetMap.PART1 });
            // Header is row 0. Data starts row 1.
            finalData.part1_riasec = rows.slice(1).map(row => ({
                id: row[0], type: row[1], question: row[2]
            })).filter(q => q.id && q.question);
        }

        if (sheetMap.PART2) {
            const rows = await readXlsxFile(FILE_PATH, { sheet: sheetMap.PART2 });
            finalData.part2_competency = rows.slice(1).map(row => {
                const optionsRaw = row[3];
                let options = [];
                if (optionsRaw) {
                    options = optionsRaw.split(/[\n,]/).map(o => {
                        // Handle "val:label" or just "label"
                        const parts = o.split(':');
                        if (parts.length > 1) return { value: parts[0].trim(), label: parts[1].trim() };
                        return { value: o.trim(), label: o.trim() };
                    });
                }
                return {
                    id: row[0], question: row[1], type: 'select',
                    options: options.length ? options : undefined
                };
            }).filter(q => q.id);
        }

        if (sheetMap.PART3) {
            const rows = await readXlsxFile(FILE_PATH, { sheet: sheetMap.PART3 });
            finalData.part3_job_pref = rows.slice(1).map(row => ({
                id: row[0], question: row[1], type: 'select',
                options: parseOptions(row[3])
            })).filter(q => q.id);
        }

        if (sheetMap.PART4) {
            const rows = await readXlsxFile(FILE_PATH, { sheet: sheetMap.PART4 });
            finalData.part4_industry_pref = rows.slice(1).map(row => ({
                id: row[0], question: row[1], type: 'select',
                options: parseOptions(row[3])
            })).filter(q => q.id);
        }

        // Part 5: Org Culture (Check structure)
        if (sheetMap.PART5) {
            const rows = await readXlsxFile(FILE_PATH, { sheet: sheetMap.PART5 });
            // Structure might be ID | Type | Question. Or ID | Question | Agility | Hierarchy?
            // Let's assume standard: ID | Type | Question based on previous json
            finalData.part5_org_culture = rows.slice(1).map(row => ({
                id: row[0], type: row[1], question: row[2]
            })).filter(q => q.id);
        }

        if (sheetMap.PART6) {
            const rows = await readXlsxFile(FILE_PATH, { sheet: sheetMap.PART6 });
            finalData.part6_residency = rows.slice(1).map(row => ({
                id: row[0], question: row[1], type: 'select',
                options: parseOptions(row[3]) // assuming options in col 3
            })).filter(q => q.id);
        }

        fs.writeFileSync(OUTPUT_PATH, JSON.stringify(finalData, null, 2));
        console.log("Success! Data written to", OUTPUT_PATH);

    } catch (e) {
        console.error("Extraction error:", e);
    }
}

function parseOptions(raw) {
    if (!raw) return [];
    return raw.toString().split(/[\n,]/).filter(s => s.trim()).map(o => {
        const parts = o.split(':');
        if (parts.length === 2) return { value: parts[0].trim(), label: parts[1].trim() };
        return { value: o.trim(), label: o.trim() };
    });
}

extractData();
