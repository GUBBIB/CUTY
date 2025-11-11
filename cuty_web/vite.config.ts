import { defineConfig, loadEnv } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), '')

  const isDebug = env.VITE_DEBUG === 'true'

  console.log(`************ 🛠️  Running Vite in ${isDebug ? 'DEBUG (local)' : 'PRODUCTION'} mode`)
  console.log(`************ 🌐  API Base URL = ${env.VITE_API_BASE}`)

  return {
    plugins: [
      react({
        babel: {
          plugins: [['babel-plugin-react-compiler']],
        },
      }),
    ],
    server: isDebug
      ? {
          host: 'localhost',
          port: 5173,
          open: true,
        }
      : undefined, // 프로덕션 빌드는 서버 설정 불필요
    define: {
      __DEBUG__: JSON.stringify(isDebug),
      __API_BASE__: JSON.stringify(env.VITE_API_BASE),
    },
  }
})
