module.exports = {
  apps: [
    {
      name: 'meu-app',
      script: './apps/api/dist/start.js',
      instances: 1,
      exec_mode: 'fork',
      env: {
        PORT: '3000',
        HOST: '0.0.0.0',
        NODE_ENV: 'production'
      }
    }
  ]
};
