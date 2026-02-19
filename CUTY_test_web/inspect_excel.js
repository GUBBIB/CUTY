import readXlsxFile from 'read-excel-file/node';
import fs from 'fs';
import path from 'path';

const schema = {
    'Part1_RIASEC': {
        prop: 'part1_riasec',
        type: {
            'ID': { prop: 'id', type: String },
            'Type': { prop: 'type', type: String },
            'Question': { prop: 'question', type: String }
        }
    },
    'Part2_Competency': {
        prop: 'part2_competency',
        type: {
            'ID': { prop: 'id', type: String },
            'Question': { prop: 'question', type: String },
            'Type': { prop: 'type', type: String }, // select
            // Options are complex, maybe just read raw rows for P2-6?
        }
    }
    // ... simpler strategy: read raw rows and map manually
};

async function convert() {
    const inputPath = 'src/data/KVTI_data.xlsx';
    const outputPath = 'src/data/kvti_questions.json';

    try {
        // Read sheets. Assuming sheet names match parts or just reading sheet 1?
        // Let's inspect sheets first. 
        // Actually, without knowing exact sheet names, let's assume standard 'Part1', 'Part2' etc.
        // OR, robust strategy: read all sheets and map based on content.

        // Since I cannot interactively inspect, I will try to read 'Sheet1' or default.
        // Better yet, I'll use a script that just dumps the content of the first sheet to see structure first.

        const rows = await readXlsxFile(inputPath);
        console.log("First 5 rows:", rows.slice(0, 5));

    } catch (error) {
        console.error("Error reading file:", error);
    }
}

convert();
