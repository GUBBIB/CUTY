import readXlsxFile from 'read-excel-file/node';

async function listSheets() {
    const inputPath = 'src/data/KVTI_data.xlsx';
    try {
        const sheets = await readXlsxFile(inputPath, { getSheets: true });
        console.log("FULL SHEET LIST:");
        sheets.forEach((s, i) => console.log(`${i + 1}. ${s.name}`));
    } catch (error) {
        console.error("Error:", error);
    }
}

listSheets();
