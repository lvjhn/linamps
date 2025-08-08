import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vite.dev/config/
export default defineConfig({
  plugins: [vue()], 
  server: {
    allowedHosts: [
      "\\m.linamps-project.lan"
    ],
    hmr: {
      host: 'm.linamps-project.lan', // e.g., frontend.lan
      protocol: 'wss'
    }
  }
})
