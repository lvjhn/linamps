module.exports = {
  apps: [
    {
      name: "WEB-SERVER (WEB)",
      script: "bash",
      args: ["scripts/run-frontend.web.sh"],
      interpreter: null,
      autorestart: false,
      watch: false,
      time: true
    },
    {
      name: "WEB-SERVER (MOBILE)",
      script: "bash",
      args: ["scripts/run-frontend.mobile.sh"],
      interpreter: null,
      autorestart: false,
      watch: false,
      time: true
    },
    {
      name: "MAILPIT",
      script: "bash",
      args: ["scripts/run-mailpit.sh"],
      interpreter: null,
      autorestart: false,
      watch: false,
      time: true
    },
    {
      name: "ADMINER",
      script: "bash",
      args: ["scripts/run-adminer.sh"],
      interpreter: null,
      autorestart: false,
      watch: false,
      time: true
    },
    {
      name: "NGINX",
      script: "bash",
      args: ["scripts/run-nginx.sh"],
      interpreter: null,
      autorestart: false,
      watch: false,
      time: true
    }
  ]
};
