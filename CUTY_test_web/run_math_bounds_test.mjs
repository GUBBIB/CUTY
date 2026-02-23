import fs from 'fs';
import { calculateKvtiResult } from './src/utils/kvtiLogic.js';

// Mock KVTI Dictionary so the test doesn't crash on undefined attributes
global.KVTI_DICTIONARY = { "BCH": { nickname: "Test", description: "Test" }, "BEH": { nickname: "Test", description: "Test" }, "IAH": { nickname: "Test", description: "Test" } };

let results = [];

function runTest(testName, mockAnswers, expectedChar1, expectedChar2) {
    const baseProfile = { university: "서울대학교", major: "소프트웨어", gpa: "4.0", topik: 5, kiip: 0, age: 25, degree: "학사", languages: [] };

    try {
        // kvtiLogic.js directly imports kvti_questions.json, so we only need to pass the Answers map.
        const result = calculateKvtiResult(mockAnswers, 'senior', baseProfile);

        let passed = true;
        let reasons = [];
        if (expectedChar1 && result.dashboard.kvti_code.charAt(0) !== expectedChar1) {
            passed = false; reasons.push(`Expected Char 1: ${expectedChar1}, got ${result.dashboard.kvti_code.charAt(0)}`);
        }
        if (expectedChar2 && result.dashboard.kvti_code.charAt(1) !== expectedChar2) {
            passed = false; reasons.push(`Expected Char 2: ${expectedChar2}, got ${result.dashboard.kvti_code.charAt(1)}`);
        }

        results.push({
            name: testName,
            passed: passed,
            kvti: result.dashboard.kvti_code,
            mdjm_raw: result.dashboard.mdjm_raw_results,
            mdjm_top_jobs: result.dashboard.recommended_jobs,
            score: result.diagnosis?.visa_probability?.score,
            error: passed ? null : reasons.join(", ")
        });
    } catch (e) {
        results.push({ name: testName, passed: false, error: e.message, stack: e.stack });
    }
}

// TEST 1: Extreme IT & Analytical Bias
// Should force 'I' (IT) and 'A' (Analytical)
let answers1 = {
    // RIASEC: I and C drive 'A' (Analytical)
    JP_I_01: 5, JP_I_02: 5, JP_I_03: 5, JP_I_04: 5,
    JP_C_01: 5, JP_C_02: 5, JP_C_03: 5, JP_C_04: 5,
    JP_E_01: 1, JP_E_02: 1, JP_S_01: 1, JP_R_01: 1, JP_A_01: 1,
    // Industry: IT (I) drives 'I'
    IND_I_01: 5, IND_I_02: 5, IND_I_03: 5, IND_I_04: 5,
    IND_B_01: 1, IND_M_01: 1, IND_D_01: 1, IND_C_01: 1,
    // Culture & Residency
    PER_R_01: 4, PER_R_02: 4, LIF_VIS_01: 5
};
runTest("Extreme IT & Analytical Bias", answers1, 'I', 'A');

// TEST 2: Extreme Business & Enterprising Bias
// Should force 'B' (BIZ) and 'E' (Enterprising)
let answers2 = {
    // RIASEC: E and S drive 'E' (Enterprising)
    JP_E_01: 5, JP_E_02: 5, JP_E_03: 5, JP_E_04: 5,
    JP_S_01: 5, JP_S_02: 5, JP_S_03: 5, JP_S_04: 5,
    JP_I_01: 1, JP_I_02: 1, JP_C_01: 1, JP_R_01: 1, JP_A_01: 1,
    // Industry: BIZ (B) drives 'B'
    IND_B_01: 5, IND_B_02: 5, IND_B_03: 5, IND_B_04: 5,
    IND_I_01: 1, IND_M_01: 1, IND_D_01: 1, IND_C_01: 1,
    // Culture & Residency
    PER_R_01: 2, PER_R_02: 2, LIF_VIS_01: 1
};
runTest("Extreme Business & Enterprising Bias", answers2, 'B', 'E');

// TEST 3: MDJM Hybrid Case (50:50 BIZ & IT Split)
// Should result in a hybrid job like 2742 (Tech Sales) or similar being recommended.
let answers3 = {
    // RIASEC: I (IT) + E (BIZ) combo
    JP_I_01: 5, JP_I_02: 5, JP_I_03: 5,
    JP_E_01: 5, JP_E_02: 5, JP_E_03: 5,
    JP_S_01: 3, JP_C_01: 3, JP_R_01: 1, JP_A_01: 1,
    // Industry: 49% BIZ, 51% IT
    IND_B_01: 4, IND_B_02: 4, IND_T_01: 4,
    IND_I_01: 4, IND_I_02: 4, IND_I_03: 5, // IT wins slightly
    IND_M_01: 1, IND_D_01: 1, IND_C_01: 1,
    // Culture & Residency
    PER_R_01: 3, PER_R_02: 3, LIF_VIS_01: 3
};
runTest("Borderline 49:51 IT/BIZ Hybrid Matching", answers3, 'I', 'E'); // I from IT, E from E+S vs I+C

fs.writeFileSync('test_results.json', JSON.stringify(results, null, 2));
