import { execFile } from "child_process";
import { promisify } from "util";
import extern from "./service.extern";

const execFilePromisified = promisify(execFile);

export const generateRoutes: extern["generateRoutes"] = async (
  generatorScript,
  outputDirectory,
  controllerPathGlobs
) => {
  console.log("Generating routes...");
  await execFilePromisified(
    process.execPath,
    [
      generatorScript,
      JSON.stringify({
        controllerPathGlobs,
        outputDirectory,
      }),
    ],
    {
      windowsHide: true,
    }
  );
  console.log("Routes generated.");
};
