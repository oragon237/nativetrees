import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  // Beta builds serve the admin SPA from a subpath:
  // VITE_BASE_PATH=/native/backend npm run build
  base: process.env.VITE_BASE_PATH ?? '/',
  server: {
    port: 5173,
    proxy: {
      '/api': 'http://localhost:4000',
      '/uploads': 'http://localhost:4000',
    },
  },
});
