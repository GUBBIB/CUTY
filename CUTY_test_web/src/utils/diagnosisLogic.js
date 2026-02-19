/**
 * Diagnosis Logic Implementation
 * 
 * Algo Spec:
 * 1. 5-Axis Score: Job, Growth, Reality, Culture, Visa
 *    - Note: Data has 4 categories. 'Visa' score will be derived from 'Reality' category 
 *      (specifically traits related to Visa/Legal) or mapped from Reality if not separable.
 *      *Decision*: 'Reality' category seems to cover Visa/Legal/Spec. 
 *                 We will use 'Reality' as the 'Visa' axis and also keep 'Reality' as 'Reality(Spec)'.
 *                 Actually, let's split 'Reality' features if possible, or just duplicate for the 5-point chart request.
 *                 Traits in Reality: Korean_Literacy, Major_Relevance, Regional_Flexibility, Visa_Knowledge, Expectation_Control.
 *                 Let's map: 
 *                 - Reality Axis: Major_Relevance, Korean_Literacy, Expectation_Control (Hard Spec/Mindset)
 *                 - Visa Axis: Visa_Knowledge, Regional_Flexibility (Legal/Strategy)
 * 
 * 2. E-7 Probability: (Job Score / 5) * 100 * (Reality Score Weight)
 * 3. Roadmap Type: Study vs Field (from Growth category)
 */

export const calculateResult = (answers) => {
    // 1. Initialize Scores
    const scores = {
        Job: { total: 0, count: 0, traits: {} },
        Growth: { total: 0, count: 0, traits: {} },
        Reality: { total: 0, count: 0, traits: {} },
        Culture: { total: 0, count: 0, traits: {} },
        // Derived axes
        Visa: { total: 0, count: 0 },
        Reality_Only: { total: 0, count: 0 }
    };

    // Helper to add score
    const addScore = (category, trait, score) => {
        if (!scores[category]) return;
        scores[category].total += score;
        scores[category].count += 1;

        // Track trait scores for specific logic
        if (!scores[category].traits[trait]) {
            scores[category].traits[trait] = 0;
        }
        scores[category].traits[trait] += score;
    };

    // 2. Process all answers
    // distinct feature separation for Reality vs Visa axis
    const visaTraits = ['Visa_Knowledge', 'Regional_Flexibility'];

    answers.forEach(ans => {
        const { category, target_trait, score } = ans; // score 1-5
        addScore(category, target_trait, score);

        // Special handling for splitting Reality into Reality/Visa axes
        if (category === 'Reality') {
            if (visaTraits.includes(target_trait)) {
                scores.Visa.total += score;
                scores.Visa.count += 1;
            } else {
                scores.Reality_Only.total += score;
                scores.Reality_Only.count += 1;
            }
        }
    });

    // 3. Calculate Averages (5-point scale)
    const getAvg = (total, count) => count === 0 ? 0 : (total / count).toFixed(1);

    const axisScores = {
        Job: Number(getAvg(scores.Job.total, scores.Job.count)),
        Growth: Number(getAvg(scores.Growth.total, scores.Growth.count)),
        // Reality Axis (Core Specs)
        Reality: Number(getAvg(scores.Reality_Only.total, scores.Reality_Only.count)),
        Culture: Number(getAvg(scores.Culture.total, scores.Culture.count)),
        // Visa Axis
        Visa: Number(getAvg(scores.Visa.total, scores.Visa.count))
    };

    // Refinement: If Reality was empty for some reason, fallback
    if (scores.Visa.count === 0 && scores.Reality.count > 0) {
        axisScores.Visa = axisScores.Reality; // Fallback to full Reality score
    }

    // 4. E-7 Matching Logic
    // Formula: (Job Score / 5) * 100 * (Reality Weight)
    // Let's assume Reality Weight is a factor (0.5 ~ 1.5) or just the raw score normalized?
    // Spec says: "(직무 기질 점수 / 5) * 100 * (비자 현실 점수 가중치)"
    // Let's interpret "Reality Score Weight" as (Reality Score / 5).
    // e.g. Job=5, Reality=5 -> 100 * 1 = 100%
    // e.g. Job=3, Reality=2 -> 60 * 0.4 = 24%
    const realityWeight = scores.Reality.count > 0 ? (scores.Reality.total / scores.Reality.count) / 5 : 0;
    const matchProbability = Math.round((axisScores.Job / 5) * 100 * realityWeight);

    // Determine Job Type
    const jobTraits = scores.Job.traits;
    const maxJobTrait = Object.keys(jobTraits).reduce((a, b) => jobTraits[a] > jobTraits[b] ? a : b, 'Analytical');

    let jobType = "General E-7";
    if (maxJobTrait === 'Analytical') jobType = "E-7-1 (Data/Research)";
    else if (maxJobTrait === 'Social') jobType = "E-7-4 (Overseas Sales)";
    else if (scores.Reality.traits['Regional_Flexibility'] >= 4.5 * (scores.Reality.count > 0 ? 1 : 0)) {
        // Note: Trait score logic might need normalization if multiple questions per trait
        // Assuming 4 questions per trait, max score is 20. 4.5 avg -> 18 total.
        // Let's check logic: "Regional_Flexibility가 4.5점 이상이면" -> This implies Average Score.
        // I need to calculate average per trait if I want to check "4.5".
        // Let's implement trait average helper if needed.
    }

    // Specific override for F-2-R
    // Calculate Regional_Flexibility average
    // We didn't store Count per trait in the simple structure, but we know dataset has balanced questions?
    // Let's allow simple total/count if needed, or assume count=4 from dataset stats. 
    // Safety: Calculate avg for Regional_Flexibility
    let regionalScore = 0;
    let regionalCount = 0;
    answers.forEach(a => {
        if (a.target_trait === 'Regional_Flexibility') {
            regionalScore += a.score;
            regionalCount += 1;
        }
    });
    const avgRegional = regionalCount > 0 ? regionalScore / regionalCount : 0;

    if (avgRegional >= 4.5) {
        jobType = "F-2-R (Regional Specialized)";
    }

    // 5. Roadmap Type
    const growthTraits = scores.Growth.traits;
    // Sum Study vs Field. 
    // Note: some traits might be mapped to Study/Field.
    // Traits in Growth: Field_Oriented, Study_Oriented, Collaborative_Learning, Independent_Learning.
    // We need to group them.
    // Let's assume Collaborative -> Field-ish? Independent -> Study-ish?
    // Or strictly use 'Field_Oriented' and 'Study_Oriented' explicitly named traits.
    // Spec says: "`Study_Oriented` 총점 vs `Field_Oriented` 총점 비교"

    const studyScore = growthTraits['Study_Oriented'] || 0;
    const fieldScore = growthTraits['Field_Oriented'] || 0;

    const roadmapType = studyScore > fieldScore ? "Type A (Academic/Study)" : "Type B (Action/Field)";

    return {
        radarData: [
            { subject: 'Job', A: axisScores.Job, fullMark: 5 },
            { subject: 'Growth', A: axisScores.Growth, fullMark: 5 },
            { subject: 'Reality', A: axisScores.Reality, fullMark: 5 },
            { subject: 'Culture', A: axisScores.Culture, fullMark: 5 },
            { subject: 'Visa', A: axisScores.Visa, fullMark: 5 },
        ],
        jobType,
        matchProbability,
        roadmapType,
        details: {
            studyScore,
            fieldScore,
            avgRegional
        }
    };
};
