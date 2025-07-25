import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vite.dev/config/
export default defineConfig({
  plugins: [vue()], 
  server: {
    allowedHosts: [
      "\\linamps-project.lan"
    ],
    hmr: {
      host: 'linamps-project.lan', // e.g., frontend.lan
      protocol: 'wss'
    }
  }
})
