import { motion } from 'framer-motion';

function SectionGuideScreen({ title, description, guide, onStart, icon = "🚀" }) {
    return (
        <div className="min-h-screen bg-kvti-bg text-white flex flex-col items-center justify-center p-6 text-center">
            <motion.div
                initial={{ opacity: 0, scale: 0.9 }}
                animate={{ opacity: 1, scale: 1 }}
                transition={{ duration: 0.5 }}
                className="max-w-2xl w-full space-y-8"
            >
                <div className="text-6xl mb-4 animate-bounce">{icon}</div>

                <h1 className="text-3xl md:text-5xl font-black text-transparent bg-clip-text bg-gradient-to-r from-kvti-primary to-kvti-gold">
                    {title}
                </h1>

                <p className="text-lg md:text-xl text-slate-300 font-light leading-relaxed">
                    {description}
                </p>

                <div className="bg-white/5 border border-white/10 rounded-2xl p-6 md:p-8 backdrop-blur-sm">
                    <h3 className="text-kvti-gold font-bold uppercase tracking-widest text-xs mb-3">
                        DIAGNOSIS GUIDE
                    </h3>
                    <p className="text-md md:text-lg text-white leading-relaxed font-medium">
                        "{guide}"
                    </p>
                </div>

                <button
                    onClick={onStart}
                    className="group relative px-8 py-4 bg-white text-kvti-bg font-bold rounded-full hover:bg-kvti-primary hover:text-white transition-all duration-300 shadow-xl hover:shadow-2xl hover:-translate-y-1"
                >
                    <span className="flex items-center gap-2">
                        Start This Section
                        <svg className="w-5 h-5 group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 7l5 5m0 0l-5 5m5-5H6" />
                        </svg>
                    </span>
                </button>
            </motion.div>
        </div>
    );
}

export default SectionGuideScreen;
