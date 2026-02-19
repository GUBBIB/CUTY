import readXlsxFile from 'read-excel-file/node';
import fs from 'fs';

const FILE_PATH = 'src/data/KVTI_data.xlsx';
const OUTPUT_PATH = 'src/data/kvti_logic_rules.json';

async function extractLogic() {
    try {
        const sheets = await readXlsxFile(FILE_PATH, { getSheets: true });

        // Find logic sheets
        const reportSheet = sheets.find(s => s.name.includes('리포트') || s.name.includes('Report'));
        // const guideSheet = sheets.find(s => s.name.includes('Guide') || ...); 

        const logicData = {};

        if (reportSheet) {
            console.log(`Extracting logic from ${reportSheet.name}...`);
            const rows = await readXlsxFile(FILE_PATH, { sheet: reportSheet.name });

            // Assume format: Key | Value | Description or Rule | Formula
            // We'll try to structure it. 
            // If it's unstructured text, we'll save it as raw lines to manual inspection or simple key-value if possible.
            logicData.reportConfig = rows.map(r => r.filter(c => c !== null));
        }

        // Check for other potential logic sheets
        // '데이터 구조' might contain field mappings
        const structureSheet = sheets.find(s => s.name.includes('구조'));
        if (structureSheet) {
            const rows = await readXlsxFile(FILE_PATH, { sheet: structureSheet.name });
            logicData.dataStructure = rows.map(r => r.filter(c => c !== null));
        }

        fs.writeFileSync(OUTPUT_PATH, JSON.stringify(logicData, null, 2));
        console.log("Logic rules extracted to", OUTPUT_PATH);

    } catch (e) {
        console.error("Logic extraction failed:", e);
    }
}

extractLogic();
