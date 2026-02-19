import readXlsxFile from 'read-excel-file/node';

async function inspectSheets() {
    const inputPath = 'src/data/KVTI_data.xlsx';

    // Get list of sheets
    try {
        const sheets = await readXlsxFile(inputPath, { getSheets: true });
        console.log("Sheets found:", sheets.map(s => s.name));

        // Read first 3 rows of each sheet to identify content
        for (const sheet of sheets) {
            console.log(`--- Sheet: ${sheet.name} ---`);
            const rows = await readXlsxFile(inputPath, { sheet: sheet.name });
            console.log(rows.slice(0, 3));
        }

    } catch (error) {
        console.error("Error inspecting sheets:", error);
    }
}

inspectSheets();
