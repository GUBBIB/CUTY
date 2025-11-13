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
    }

  }
})
