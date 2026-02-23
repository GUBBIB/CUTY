import { calculateKvtiResult } from './src/utils/kvtiLogic.js';
import kvtiQuestions from './src/data/kvti_questions.json';

const getBlindAnswers = () => {
    let answers = {};
    Object.values(kvtiQuestions).forEach(section => {
        if (Array.isArray(section)) {
            section.forEach(q => {
                if (!q.id) return;
                let val = 1;

                // Imitate Tester C
                const traits = { likesTech: true, likesArt: true, isIndependent: true };

                if (traits.likesTech && (q.id.startsWith('JP_I') || q.id === 'I')) val = 5;
                if (traits.likesArt && (q.id.startsWith('JP_A') || q.id === 'A')) val = 5;

                if (traits.likesTech && q.id.startsWith('IND_I')) val = 5;
                if (traits.likesArt && q.id.startsWith('IND_C')) val = 5;

                if (traits.isIndependent && q.id === 'PER_I_01') val = 5;
                if (traits.isIndependent && q.id.startsWith('PER_R')) val = 1;

                answers[q.id] = val;
            });
        }
    });
    return answers;
};

const ans = getBlindAnswers();
console.log('PER_I_01 answer:', ans['PER_I_01']);
console.log('JP_A_01 answer:', ans['JP_A_01']);
console.log('IND_I_01 answer:', ans['IND_I_01']);

const res = calculateKvtiResult(ans, 'senior', { grade: '1학년' });

import fs from 'fs';
fs.writeFileSync('debug_out.txt', res.dashboard.recommended_jobs.map(j => `${j.code}: ${j.readiness}%`).join('\n'));
console.log('Wrote to debug_out.txt');
