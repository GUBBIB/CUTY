import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig(() => {

  return {
    plugins: [
      react({
        babel: {
          plugins: [['babel-plugin-react-compiler']],
        },
      }),
    ],
    server: {
      host: 'localhost',
      port: 5173,
      open: true,
      proxy: {
        '/api' : {
          target: "https://zm3czse9yf.execute-api.ap-northeast-2.amazonaws.com/prod",
          changeOrigin: true,
          secure: false,
        }
      }
    }

  }
})
