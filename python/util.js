const { resolve, join } = require("node:path");
const { cpSync, existsSync, mkdtempSync } = require("node:fs");
const { execSync } = require("node:child_process");

exports.dirname = () => __dirname;

exports.resolve = (path1, path2) => {
  console.log(join(path1, path2))
  return join(path1, path2);
};

exports.build = (options) => {
  const { entrypointDir, workDir, path, homeEnv, pathEnv } = options;

  // create an output directory and copy the path to it
  const outdir = mkdtempSync(join(resolve(workDir), "py-func-"));
  const resolvedPath = join(entrypointDir, path);

  // if there is a requirements.txt file, install the dependencies
  const requirementsPath = join(resolvedPath, "requirements.txt");
  if (existsSync(requirementsPath)) {
    cpSync(requirementsPath, join(outdir, "requirements.txt"));
    execSync(`python -m pip install -r ${join(outdir, "requirements.txt")} -t python`, 
      { cwd: outdir, env: { HOME: homeEnv, PATH: pathEnv } });
    cpSync(resolvedPath, join(outdir, "python"), { recursive: true });
    return join(outdir, "python");
  } else {
    cpSync(resolvedPath, outdir, { recursive: true });
    return outdir;
  }
};

exports.liftTfAws = (id, resource) => {
  
};

exports.liftSim = (id, resource) => {
  function makeEnvVarName(type, resource) {
    return `${type
      .toUpperCase()
      .replace(/[^A-Z]+/g, "_")}_HANDLE_${resource.node.addr.slice(-8)}`;
  }

  if (
      typeof resource.onCreate === "function" &&
      typeof resource.addObject === "function" &&
      typeof resource.onEvent === "function") {
    return { 
      path: resource.node.path,
      handle: makeEnvVarName("bucket", resource),
      type: "cloud.Bucket",
      target: "sim",
    }
  }

  return undefined;
};
