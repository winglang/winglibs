const { execSync } = require("child_process");

exports.shell = (cmd, opts) => {
  const result = execSync(cmd, { shell: true, stdio: ["pipe", "pipe", "inherit"], ...opts });
  return result.toString("utf8");
}