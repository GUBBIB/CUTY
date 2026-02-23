const fs = require('fs');
const path = require('path');

const srcFile = path.join(__dirname, 'e7_requirements.js');
const jsonFile = path.join(__dirname, 'e7_data_gemini.json');

// Read the original file
let srcContent = fs.readFileSync(srcFile, 'utf8');

// The original file exports E7_REQUIREMENTS which is an object where keys are job codes.
// e.g. "1120": { code: "1120", name: "...", roadmap: { ...} }

// Let's read the gemini json file. It seems malformed at the start.
let jsonRaw = fs.readFileSync(jsonFile, 'utf8');

// The output from Gemini has empty arrays missing brackets: "certifications": , -> "certifications": [],
jsonRaw = jsonRaw.replace(/:\s*,/g, ': [],');
jsonRaw = jsonRaw.replace(/:\s*}/g, ': []}');
// Also the first item is malformed like `,\n"tools": ,`, let's just extract all valid objects inside {} with "code"
// Actually, it's safer to just wrap it in an array and parse it after stripping malformed prefix
// But what if it's too broken?
// Let's use regex to grab just the "code" and "roadmap" from each segment.
const roadmapData = {};
let count = 0;

// Split by "code": 
const chunks = jsonRaw.split('"code"');
for (let i = 1; i < chunks.length; i++) {
    const chunk = chunks[i];
    // extract code
    const codeMatch = chunk.match(/^\s*:\s*"([^"]+)"/);
    if (!codeMatch) continue;
    const code = codeMatch[1];

    // extract roadmap part
    const rmMatch = chunk.match(/"roadmap"\s*:\s*({[\s\S]*?})/);
    if (rmMatch) {
        let rmStr = rmMatch[1];
        try {
            const parsedRM = JSON.parse(rmStr);
            roadmapData[code] = parsedRM;
            count++;
        } catch (e) {
            console.error("Failed parsing roadmap for " + code);
        }
    }
}

console.log(`Found ${count} valid job roadmap entries in the Gemini output.`);

// Now we need to merge this back into e7_requirements.js
// We can use regex or eval. Since e7_requirements.js is JS, let's just evaluate it, modify it, and write it back as a JS file.

// Hacky require using eval to get the object
const tempSrc = srcContent.replace(/export const E7_REQUIREMENTS =/, 'module.exports =');
const E7_REQUIREMENTS = eval(`
    const E7_REQUIREMENTS_wrapper = () => {
        let module = {};
        ${tempSrc}
        return module.exports;
    };
    E7_REQUIREMENTS_wrapper();
`);

let updatedCount = 0;
for (const code in roadmapData) {
    if (E7_REQUIREMENTS[code]) {
        // Only overwrite if the new data actually has stuff, or just overwrite it all.
        const newRM = roadmapData[code];
        const oldRM = E7_REQUIREMENTS[code].roadmap || { certifications: [], tools: [], portfolio: [] };

        E7_REQUIREMENTS[code].roadmap = {
            certifications: newRM.certifications && newRM.certifications.length > 0 ? newRM.certifications : oldRM.certifications,
            tools: newRM.tools && newRM.tools.length > 0 ? newRM.tools : oldRM.tools,
            portfolio: newRM.portfolio && newRM.portfolio.length > 0 ? newRM.portfolio : oldRM.portfolio
        };
        updatedCount++;
    } else {
        console.warn(`Code ${code} found in Gemini output but not in E7_REQUIREMENTS.`);
    }
}

console.log(`Successfully updated ${updatedCount} entries in E7_REQUIREMENTS.`);

// Now reconstruct the e7_requirements.js file
let newContent = `export const E7_REQUIREMENTS = {\n`;
for (const code in E7_REQUIREMENTS) {
    const job = E7_REQUIREMENTS[code];
    newContent += `    "${code}": {\n`;
    newContent += `        code: "${code}",\n`; // Fix undefined code bug
    // name could also be messed up if we depended on Gemini output. Let's rely on E7_REQUIREMENTS original data.
    newContent += `        name: "${job.name}",\n`;
    newContent += `        education: "${job.education}",\n`;
    newContent += `        salary: "${job.salary}",\n`;
    newContent += `        employer: "${job.employer}",\n`;
    newContent += `        special: "${job.special}"`;
    if (job.roadmap) {
        newContent += `,\n        roadmap: ${JSON.stringify(job.roadmap, null, 8).trim().replace(/}$/, '        }')}\n`;
    } else {
        newContent += `\n`;
    }
    newContent += `    },\n`;
}
// Remove last comma
newContent = newContent.replace(/,\n$/, '\n');
newContent += `};\n`;

fs.writeFileSync(srcFile, newContent);
console.log("Write success!");

