import { motion } from 'framer-motion';

function LikertScale({ selected, onSelect, labels = { 1: "전혀 아님", 3: "보통", 5: "매우 그렇다" } }) {
    return (
        <div className="flex flex-col gap-2">
            <div className="grid grid-cols-5 gap-2 md:gap-4">
                {[1, 2, 3, 4, 5].map((score) => (
                    <motion.button
                        key={score}
                        whileHover={{ scale: 1.05 }}
                        whileTap={{ scale: 0.95 }}
                        onClick={() => onSelect(score)}
                        className={`
                            flex flex-col items-center justify-center p-3 rounded-xl transition-all duration-200 border
                            ${selected === score
                                ? 'bg-kvti-primary text-kvti-bg border-kvti-gold shadow-lg shadow-kvti-gold/20'
                                : 'bg-white/5 text-slate-400 border-white/10 hover:bg-white/10 hover:text-white'
                            }
                        `}
                    >
                        <span className={`text-xl font-bold mb-1 ${selected === score ? 'text-kvti-bg' : 'text-inherit'}`}>
                            {score}
                        </span>
                        <span className="text-[10px] md:text-xs text-center font-medium opacity-80 hidden md:block">
                            {labels[score] || ""}
                        </span>
                    </motion.button>
                ))}
            </div>
            <div className="flex justify-between px-1 text-[10px] text-slate-500 md:hidden">
                <span>{labels[1]}</span>
                <span>{labels[5]}</span>
            </div>
        </div>
    );
}

export default LikertScale;
