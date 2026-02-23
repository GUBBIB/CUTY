const fs = require('fs');
const path = require('path');

const tempPath = path.join(__dirname, 'src/data/temp_e7_input.json');
const outputPath = path.join(__dirname, 'src/data/e7_requirements.js');

try {
    const rawData = fs.readFileSync(tempPath, 'utf8');
    const inputJson = JSON.parse(rawData);

    const outputObj = {};

    for (const [key, value] of Object.entries(inputJson)) {
        // Strip E71_, E72_, E73_, E74_ prefixes for the JobDetailModal extraction logic
        let newKey = key.replace(/^E7[1-4]_/, '');

        // Ensure requirements keys match JobDetailModal's expected structure if needed
        // The modal expects: { education, salary, employer, special }
        // The input has: { name, education, salary, employer, special }
        outputObj[newKey] = {
            name: value.name,
            education: value.education,
            salary: value.salary,
            employer: value.employer,
            special: value.special
        };
    }

    // Convert to target format
    const fileContent = `// Auto-generated combined E-7 requirements from the provided JSON payload\n` +
        `export const E7_REQUIREMENTS = ${JSON.stringify(outputObj, null, 4)};\n`;

    fs.writeFileSync(outputPath, fileContent, 'utf8');
    console.log("Successfully transformed and saved E7_REQUIREMENTS to e7_requirements.js");
} catch (e) {
    console.error("Error processing JSON:", e);
}
