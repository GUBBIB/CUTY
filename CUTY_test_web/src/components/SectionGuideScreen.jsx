// eslint-disable-next-line no-unused-vars
import { motion } from 'framer-motion';

function SectionGuideScreen({ title, description, guide, onStart, icon = "🚀" }) {
    return (
        <div className="theme-charcoal min-h-screen bg-kvti-bg text-white flex flex-col items-center justify-center p-6 text-center transition-colors duration-500">
            <motion.div
                initial={{ opacity: 0, scale: 0.9 }}
                animate={{ opacity: 1, scale: 1 }}
                transition={{ duration: 0.5 }}
                className="max-w-2xl w-full space-y-8"
            >
                <div className="text-6xl mb-4 animate-bounce">{icon}</div>

                <h1 className="text-3xl md:text-5xl font-black text-transparent bg-clip-text bg-gradient-to-r from-amber-200 to-amber-500">
                    {title}
                </h1>

                <p className="text-lg md:text-xl text-zinc-300 font-light leading-relaxed">
                    {description}
                </p>

                <div className="bg-white/5 border border-white/5 rounded-2xl p-6 md:p-8 backdrop-blur-sm shadow-2xl shadow-amber-900/10">
                    <h3 className="text-amber-400 font-bold uppercase tracking-widest text-xs mb-3">
                        DIAGNOSIS GUIDE
                    </h3>
                    <p className="text-md md:text-lg text-zinc-100 leading-relaxed font-medium">
                        "{guide}"
                    </p>
                </div>

                <button
                    onClick={onStart}
                    className="group relative px-8 py-4 bg-amber-400 text-zinc-900 font-bold rounded-full hover:bg-amber-300 transition-all duration-300 shadow-xl shadow-amber-500/20 hover:shadow-2xl hover:shadow-amber-400/30 hover:-translate-y-1"
                >
                    <span className="flex items-center gap-2">
                        {/* Use provided button text if available in props, otherwise default */}
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
