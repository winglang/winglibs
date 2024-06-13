const { spawn } = require("node:child_process");

exports.env = () => {
  return process.env;
};

exports.os = function() {
  return process.platform;
};

exports._spawn = function(command, args, options) {
  const child = spawn(command, args, {
    stdio: "pipe",
    ...options,
  });

  child.stdout.on("data", (data) =>
    console.log(data.toString().trim())
  );

  child.stderr.on("data", (data) =>
    console.log(data.toString().trim())
  );

  child.once("error", (err) => {
    console.error(err);
  });
}
