
import { calculateKvtiResult } from './src/utils/kvtiLogic.js';
import fs from 'fs';

const kvtiQuestions = JSON.parse(fs.readFileSync('./src/data/kvti_questions.json', 'utf8'));

function test() {
    console.log("Starting test...");
    const answers = {};

    // 1. Fill answers for all sections
    const sections = ['part1_riasec', 'part2_competency', 'part3_job_pref', 'part4_industry_pref', 'part5_org_culture', 'part6_residency'];

    sections.forEach(sec => {
        const questions = kvtiQuestions[sec];
        if (!questions) {
            console.error(`Missing section: ${sec}`);
            return; // Skip if missing
        }
        questions.forEach(q => {
            if (q.type === 'Likert') {
                answers[q.id] = 4; // Agree
            } else if (q.options && q.options.length > 0) {
                answers[q.id] = q.options[0].value;
            } else {
                answers[q.id] = 4; // Default
            }
        });
    });

    try {
        console.log("Calculating result...");
        const result = calculateKvtiResult(answers);

        // Assertions for new structure
        if (!result.dashboard || !result.diagnosis || !result.roadmap) {
            throw new Error("Missing top-level keys: dashboard, diagnosis, or roadmap");
        }

        if (!result.dashboard.persona_title) throw new Error("Missing dashboard.persona_title");
        if (!Array.isArray(result.diagnosis.riasec.radarData)) throw new Error("Missing diagnosis.riasec.radarData array");
        if (!result.roadmap[0].action_items[0].task) throw new Error("Missing roadmap action_items structure");

        console.log("PASS: Result structure is valid.");
        console.log("Persona:", result.dashboard.persona_title);
        console.log("Strategy:", result.dashboard.strategy);
        console.log("Risk:", result.dashboard.risk_alert);
        console.log("Roadmap Step 1 Item 1 Priority:", result.roadmap[0].action_items[0].priority);

    } catch (error) {
        console.error("FAIL: Error calculating result:", error);
        console.error(error.stack);
    }
}

test();
