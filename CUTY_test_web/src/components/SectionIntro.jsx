// eslint-disable-next-line no-unused-vars
import { motion } from 'framer-motion';

function SectionIntro({ title, description, guide, isActive }) {
    if (!isActive) return null;

    return (
        <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            className="mb-8 text-center"
        >
            <h2 className="text-2xl font-bold text-amber-400 mb-2">{title}</h2>
            <p className="text-zinc-400 mb-4">{description}</p>
            {guide && (
                <div className="bg-white/5 border border-white/5 rounded-xl p-3 inline-block max-w-lg mx-auto shadow-lg shadow-amber-900/5">
                    <div className="flex items-start gap-2 text-left">
                        <span className="text-amber-400 text-lg">💡</span>
                        <p className="text-xs text-zinc-300 leading-relaxed mt-0.5">{guide}</p>
                    </div>
                </div>
            )}
        </motion.div>
    );
}

export default SectionIntro;
