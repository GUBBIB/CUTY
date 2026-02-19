
import { calculateKvtiResult } from './src/utils/kvtiLogic.js';
import kvtiQuestions from './src/data/kvti_questions.json' with { type: "json" };

function test() {
    console.log("Starting test...");
    const answers = {};

    // 1. Fill answers for all sections
    const sections = ['part1_riasec', 'part2_competency', 'part3_job_pref', 'part4_industry_pref', 'part5_org_culture', 'part6_residency'];

    sections.forEach(sec => {
        const questions = kvtiQuestions[sec];
        if (!questions) {
            console.error(`Missing section: ${sec}`);
            return;
        }
        questions.forEach(q => {
            if (q.type === 'Likert') {
                answers[q.id] = 5; // Strongly Agree
            } else if (q.options) {
                answers[q.id] = q.options[0].value;
            } else {
                answers[q.id] = 5; // Default for others
            }
        });
    });

    try {
        console.log("Calculating result...");
        const result = calculateKvtiResult(answers);
        console.log("Result calculated successfully!");
        console.log("Persona:", result.report.persona.title);
        console.log("Industry:", result.report.persona.industry);
        console.log("Job:", result.report.recommendations[0].name_ko);
    } catch (error) {
        console.error("Error calculating result:", error);
        console.error(error.stack);
    }
}

test();
