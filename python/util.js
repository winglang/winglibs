const { join } = require("node:path");
const { cpSync, existsSync, mkdtempSync, mkdirSync, readFileSync } = require("node:fs");
const { execSync } = require("node:child_process");
const { tmpdir } = require("node:os");
const crypto = require("node:crypto");
const glob = require("glob");
const { App, Lifting } = require("@winglang/sdk/lib/core");
const { Node } = require("@winglang/sdk/lib/std");

const createMD5ForProject = (filePath, path, handler) => {
  const hash = crypto.createHash('md5');
  hash.update(path);
  hash.update(handler);
  
  const file = readFileSync(filePath, "utf8");
  hash.update(file);

  return hash.digest("hex");
};

exports.dirname = () => __dirname;

exports.resolve = (path1, path2) => {
  console.log(join(path1, path2))
  return join(path1, path2);
};

exports.build = (options) => {
  const { path, handler, homeEnv, pathEnv } = options;

  const copyFiles = (src, dest) => {
    const files = glob.sync(join(src, "**/*.py"));
    for (let file of files) {
      const newFile = file.replace(src, `${dest}/`);
      cpSync(file, newFile);
    }
  };

  // if there is a requirements.txt file, install the dependencies
  const requirementsPath = join(path, "requirements.txt");
  if (existsSync(requirementsPath)) {
    const md5 = createMD5ForProject(requirementsPath, path, handler);
    const outdir = join(tmpdir(), "py-func-", md5);
    if (!existsSync(outdir)) {
      mkdirSync(outdir, { recursive: true });
      cpSync(requirementsPath, join(outdir, "requirements.txt"));
      execSync(`python -m pip install -r ${join(outdir, "requirements.txt")} -t python`, 
        { cwd: outdir, env: { HOME: homeEnv, PATH: pathEnv } });
    }
    copyFiles(path, join(outdir, "python"));
    return join(outdir, "python");
  } else {
    const outdir = mkdtempSync(join(tmpdir(), "py-func-"));
    copyFiles(path, outdir);
    return outdir;
  }
};

exports.liftTfAws = (id, resource) => {
  
};

exports.liftSim = (resource, options, host, clients, wingClients) => {
  let lifted = getLifted(resource, options.id);

  if (lifted) {
    Lifting.lift(resource, host, options.allow);
    for (let op of options.allow) {
      Node.of(resource).addConnection({
        name: op.endsWith("()") ? op : `${op}()`,
        source: host,
        target: resource,
      });
    }
    clients[options.id] = lifted;
  }
};

const getLifted = (resource, id) => {
  function makeEnvVarName(type, resource) {
    return `${type
      .toUpperCase()
      .replace(/[^A-Z]+/g, "_")}_HANDLE_${resource.node.addr.slice(-8)}`;
  }

  if (!resource) {
    return;
  }

  let lifted;
  if (
      typeof resource.onCreate === "function" &&
      typeof resource.addObject === "function" &&
      typeof resource.onEvent === "function") {
    lifted = {
      id,
      path: resource.node.path,
      handle: makeEnvVarName("bucket", resource),
      type: "cloud.Bucket",
      target: "sim",
      resource,
      props: {},
    }
  } else if (typeof resource.tableName === "string" &&
             typeof resource.connection === "object" ) {
    lifted = {
      id,
      path: resource.node.path,
      handle: makeEnvVarName("DYNAMODB_TABLE", resource),
      type: "@winglibs.dyanmodb.Table",
      target: "sim",
      resource,
      props: {
        connection: resource.connection,
      }
    }
  } else if (resource.constructor?.name === "MobileClient") {
    if (App.of(resource).isTestEnvironment) {
      lifted = {
        id,
        path: resource.node.path,
        handle: makeEnvVarName("MOBILE_CLIENT", resource),
        type: "@winglibs.sns.MobileClient",
        target: "sim",
        resource,
        props: {},
        children: {
          store: getLifted(resource.inner.store, "store"),
        }
      }
    } else {
      lifted = {
        id,
        path: resource.node.path,
        handle: makeEnvVarName("MOBILE_CLIENT", resource),
        type: "@winglibs.sns.MobileClient",
        target: "aws",
        resource,
        props: {},
      }
    }
  } else if (resource.constructor?.name === "EmailService") {
    if (App.of(resource).isTestEnvironment) {
      lifted = {
        id,
        path: resource.node.path,
        handle: makeEnvVarName("EMAIL_SERVICE", resource),
        type: "@winglibs.ses.EmailService",
        target: "sim",
        resource,
        props: {},
        children: {
          store: getLifted(resource.inner.store, "store"),
        }
      }
    } else {
      lifted = {
        id,
        path: resource.node.path,
        handle: makeEnvVarName("EMAIL_SERVICE", resource),
        type: "@winglibs.ses.EmailService",
        target: "aws",
        resource,
        props: {},
      }
    }
  }
  
  return lifted;
};
