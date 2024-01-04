const { execSync, spawn } = require("node:child_process");

exports.cli = () => `${__dirname}/cli.mjs`;

exports.build = (options) => {
  execSync(`node ${options.cli} build`, {
    stdio: "inherit",
    cwd: options.root,
    env: {
      HOME: options.homeEnv,
      PATH: options.pathEnv,
      ...options.env,
    },
  });
};

exports.dev = (options, port) => {
  const args = [options.cli, "dev", "--port", port];

  if (options.generateTypeDefinitions) {
    args.push("--generateTypeDefinitions");
  }

  spawn("node", [options.cli, "dev"], {
    stdio: "inherit",
    cwd: options.root,
    env: {
      HOME: options.homeEnv,
      PATH: options.pathEnv,
      ...options.env,
    },
  });
};
