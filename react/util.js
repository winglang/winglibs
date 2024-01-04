const { spawnSync, spawn } = require('child_process');

exports.shell = (command, opts) => {
  const result = spawnSync(command, { shell: true, stdio: "inherit", ...opts });
  if (result.error) {
    console.error(result.error);
    throw new Error(result.error);
  }
};

exports.spawn = async (command, opts) => {
  console.log("hello!");
  const child = spawn(command, { shell: true, stdio: "inherit", ...opts });
  return new Promise((ok, ko) => {
    child.on('spawn', ok(child));
    child.on('error', (err) => ko(err))
  });
};