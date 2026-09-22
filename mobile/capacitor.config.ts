import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'ph.katutubongpuno.app',
  appName: 'Katutubong Puno',
  webDir: 'dist',
  server: {
    // Point at the deployed backend when packaging for Android.
    // url: 'https://app.example.com',
    // cleartext: true,
  },
};

export default config;
