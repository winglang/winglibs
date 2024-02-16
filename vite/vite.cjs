const { execSync, spawnSync, spawn } = require("node:child_process");
const { parsePayload } = require("./util.cjs");

exports.cli = () => `${__dirname}/cli.mjs`;

exports.build = (options) => {
  const args = [
    options.cli,
    "build",
    "--wingEnvName",
    options.envName ?? "wing",
    "--wingEnv",
    JSON.stringify(options.env),
  ];

  if (options.generateTypeDefinitions) {
    args.push("--generateTypeDefinitions");
  }

  const buffer = spawnSync("node", args, {
    cwd: options.root,
    env: {
      HOME: options.homeEnv,
      PATH: options.pathEnv,
    },
  });
  const output = buffer.stdout.toString().split("\n");
  console.log(output.slice(1).join("\n"));
  return parsePayload(output[0]).outDir;
};

exports.dev = async (options) => {
  const args = [
    options.cli,
    "dev",
    "--wingEnvName",
    options.envName ?? "wing",
    "--wingEnv",
    JSON.stringify(options.env),
  ];

  if (options.generateTypeDefinitions) {
    args.push("--generateTypeDefinitions");
  }

  const child = spawn("node", args, {
    cwd: options.root,
    env: {
      HOME: options.homeEnv,
      PATH: options.pathEnv,
      // VITE_WING_ENV: JSON.stringify(options.env),
    },
  });

  return new Promise((resolve) => {
    child.stdout.on("data", (chunk) => {
      const payload = parsePayload(chunk.toString());
      if (payload) {
        resolve(payload.url);
        child.stdout.removeAllListeners("data");
      } else {
        // console.log(chunk.toString());
      }
    });
  });
};
