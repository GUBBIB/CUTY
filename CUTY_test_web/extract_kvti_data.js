import readXlsxFile from 'read-excel-file/node';
import fs from 'fs';

const FILE_PATH = 'src/data/KVTI_data.xlsx';
const OUTPUT_PATH = 'src/data/kvti_questions.json';

const SHEET_NAMES = {
    PART1: 'Part 1. 직업 흥미(RIASEC)',
    PART2: 'Part 2. 역량(Competency)',
    PART3: 'Part 3. 직무(Job Preference)',
    PART4: 'Part 4. 산업(Industry Preference)',
    PART5: 'Part 5. 조직문화(Culture Fit)',
    PART6: 'Part 6. 정주(Residency Strategy)'
};

async function extractData() {
    const finalData = {};

    try {
        // --- Part 1: RIASEC ---
        // Expected Columns: ID, Type, Question (or similar)
        // Let's assume Row 1 is header.
        const riasecRows = await readXlsxFile(FILE_PATH, { sheet: SHEET_NAMES.PART1 });
        // Clean rows: Remove header, filter empty
        // Structure based on observation (ID, Type, Question)
        finalData.part1_riasec = riasecRows.slice(1).map(row => ({
            id: row[0],
            type: row[1],
            question: row[2]
        })).filter(q => q.id && q.question);


        // --- Part 2: Competency ---
        // This is complex (Select options). 
        // Let's look at the structure. Usually: ID, Question, Options...
        // For simplicity in this script, I might hardcode the options if the excel just lists questions.
        // Or if excel has options in columns.
        // Let's try to grab ID and Question first.
        const compRows = await readXlsxFile(FILE_PATH, { sheet: SHEET_NAMES.PART2 });
        // Assuming: ID | Question | Type | Options (if any)
        finalData.part2_competency = compRows.slice(1).map(row => {
            // Logic to parse options if they exist in a cell separated by comma or new lines
            // For now, let's map basic fields transparently
            const optionsRaw = row[3];
            let options = [];
            if (optionsRaw) {
                // Try split by newline or comma
                options = optionsRaw.split(/[\n,]/).map(o => {
                    const [val, label] = o.split(':').map(s => s.trim());
                    return { value: val || o.trim(), label: label || o.trim() };
                });
            }

            return {
                id: row[0],
                question: row[1],
                type: row[2] || 'select', // default to select
                options: options.length ? options : undefined
            };
        }).filter(q => q.id);


        // --- Part 3, 4, 6: Simple Selects ---
        // Same logic as Part 2 usually
        const part3Rows = await readXlsxFile(FILE_PATH, { sheet: SHEET_NAMES.PART3 });
        finalData.part3_job_pref = part3Rows.slice(1).map(row => ({
            id: row[0], question: row[1], type: 'select',
            options: parseOptions(row[3])
        })).filter(q => q.id);

        const part4Rows = await readXlsxFile(FILE_PATH, { sheet: SHEET_NAMES.PART4 });
        finalData.part4_industry_pref = part4Rows.slice(1).map(row => ({
            id: row[0], question: row[1], type: 'select',
            options: parseOptions(row[3])
        })).filter(q => q.id);

        const part6Rows = await readXlsxFile(FILE_PATH, { sheet: SHEET_NAMES.PART6 });
        finalData.part6_residency = part6Rows.slice(1).map(row => ({
            id: row[0], question: row[1], type: 'select',
            options: parseOptions(row[3])
        })).filter(q => q.id);


        // --- Part 5: Org Culture (Likert 2-choice usually, or 5-point?) ---
        // Let's check schema. If it's "A vs B", it needs specific handling.
        // Assuming standard format for now.
        const part5Rows = await readXlsxFile(FILE_PATH, { sheet: SHEET_NAMES.PART5 });
        finalData.part5_org_culture = part5Rows.slice(1).map(row => ({
            id: row[0],
            type: row[1], // Agility/Hierarchy etc
            question: row[2]
        })).filter(q => q.id);


        // WRITE FILE
        fs.writeFileSync(OUTPUT_PATH, JSON.stringify(finalData, null, 2));
        console.log("Successfully created kvti_questions.json");

    } catch (e) {
        console.error("Extraction failed:", e);
    }
}

function parseOptions(raw) {
    if (!raw) return [];
    // heuristic: "value:Label" or just "Label"
    return raw.split(/[\n,]/).filter(s => s.trim()).map(o => {
        const parts = o.split(':');
        if (parts.length === 2) return { value: parts[0].trim(), label: parts[1].trim() };
        return { value: o.trim(), label: o.trim() };
    });
}

extractData();
