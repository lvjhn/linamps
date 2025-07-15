const ENVIRONMENT = process.env.ENVIRONMENT 

console.log(`RUNNING ENVIRONMENT [${ENVIRONMENT}]`)

module.exports = {
  apps: [
    {
      name: "WEB-SERVER (BACKEND)",
      script: "bash",
      args: [`scripts/${ENVIRONMENT}/run-backend.sh`],
      interpreter: null,
      autorestart: false,
      watch: false,
      time: true
    },
    {
      name: "WEB-SERVER (WEB)",
      script: "bash",
      args: [`scripts/${ENVIRONMENT}/run-frontend.web.sh`],
      interpreter: null,
      autorestart: false,
      watch: false,
      time: true
    },
    {
      name: "WEB-SERVER (MOBILE)",
      script: "bash",
      args: [`scripts/${ENVIRONMENT}/run-frontend.mobile.sh`],
      interpreter: null,
      autorestart: false,
      watch: false,
      time: true
    },
    {
      name: "MAILPIT",
      script: "bash",
      args: [`scripts/${ENVIRONMENT}/run-mailpit.sh`],
      interpreter: null,
      autorestart: false,
      watch: false,
      time: true
    },
    {
      name: "ADMINER",
      script: "bash",
      args: [`scripts/${ENVIRONMENT}/run-adminer.sh`],
      interpreter: null,
      autorestart: false,
      watch: false,
      time: true
    },
    {
      name: "NGINX",
      script: "bash",
      args: [`scripts/${ENVIRONMENT}/run-nginx.sh`],
      interpreter: null,
      autorestart: false,
      watch: false,
      time: true
    }
  ]
};