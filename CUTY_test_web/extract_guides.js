import readXlsxFile from 'read-excel-file/node';

async function extractGuides() {
    const inputPath = 'src/data/KVTI_data.xlsx';
    try {
        const sheets = await readXlsxFile(inputPath, { getSheets: true });

        // Find relevant sheets
        const reportSheet = sheets.find(s => s.name.includes('Report') || s.name.includes('리포트'));
        const structureSheet = sheets.find(s => s.name.includes('구조') || s.name.includes('Structure'));
        const guideSheet = sheets.find(s => s.name.includes('가이드') || s.name.includes('Guide'));

        if (reportSheet) {
            console.log(`\n--- Content of ${reportSheet.name} ---`);
            const rows = await readXlsxFile(inputPath, { sheet: reportSheet.name });
            // Print top 20 rows to get the gist of logic
            rows.slice(0, 20).forEach(r => console.log(r));
        }

        if (structureSheet) {
            console.log(`\n--- Content of ${structureSheet.name} ---`);
            const rows = await readXlsxFile(inputPath, { sheet: structureSheet.name });
            rows.slice(0, 20).forEach(r => console.log(r));
        }

    } catch (error) {
        console.error("Error:", error);
    }
}

extractGuides();
