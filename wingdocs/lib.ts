import { execSync  } from "child_process";

export const shell = function(command: string, env: any) {
  execSync(command, { env: { ...process.env, ...env }, stdio: "inherit" });
};