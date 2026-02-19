import { motion } from 'framer-motion';

function PersonaCard({ personaTitle, typeCode, tags, quote }) {
    // Color mapping based on RIASEC Type
    const type = typeCode ? typeCode.split('-')[0] : 'R';
    const colors = {
        'R': 'from-blue-600 to-blue-400',
        'I': 'from-indigo-600 to-purple-400',
        'A': 'from-pink-500 to-rose-400',
        'S': 'from-yellow-400 to-orange-400',
        'E': 'from-red-600 to-orange-500',
        'C': 'from-teal-500 to-emerald-400'
    };
    const gradient = colors[type] || 'from-gray-600 to-gray-400';

    return (
        <motion.div
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            className={`relative overflow-hidden rounded-3xl p-8 text-white shadow-2xl bg-gradient-to-br ${gradient}`}
        >
            <div className="absolute top-0 right-0 -mr-10 -mt-10 w-64 h-64 bg-white/20 blur-3xl rounded-full pointer-events-none"></div>

            <div className="relative z-10 flex flex-col items-center text-center">
                <div className="bg-white/20 backdrop-blur-md px-4 py-1 rounded-full text-sm font-bold tracking-widest mb-4 border border-white/30 shadow-inner">
                    MY KVTI TYPE
                </div>

                <h1 className="text-6xl md:text-8xl font-black tracking-tighter mb-2 opacity-90 drop-shadow-md">
                    {typeCode}
                </h1>

                <h2 className="text-2xl md:text-3xl font-bold mb-6">
                    {personaTitle}
                </h2>

                <div className="flex flex-wrap justify-center gap-2 mb-8">
                    {tags && tags.map((tag, idx) => (
                        <span key={idx} className="bg-black/20 px-3 py-1 rounded-full text-xs md:text-sm backdrop-blur-sm border border-white/10">
                            {tag}
                        </span>
                    ))}
                </div>

                <p className="text-white/90 italic text-lg max-w-2xl leading-relaxed bg-black/10 p-4 rounded-xl border border-white/5">
                    "{quote}"
                </p>
            </div>
        </motion.div>
    );
}

export default PersonaCard;
