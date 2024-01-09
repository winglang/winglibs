const { spawn } = require("child_process");

exports.spawn = async (cmd, args, opts) => {
  const child = spawn(cmd, args, { stdio: "pipe", ...opts });
  return new Promise((resolve, reject) => {

    // route to `console.xxx` so it shows in wing console
    child.stdout.on("data", data => resolve({
      url: () => data.toString(),
      kill: async () => {
        if (child.killed) {
          return;
        }

        child.kill();
        return new Promise(resolve => child.on("close", resolve));
      }
    }))

    child.stderr.on("data", data => reject(new Error(data.toString())));
  });
};

