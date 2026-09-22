import { defineConfig } from 'vite';

export default defineConfig({
  server: {
    port: 8100,
    proxy: {
      '/api': 'http://localhost:4000',
      '/uploads': 'http://localhost:4000',
    },
  },
});
