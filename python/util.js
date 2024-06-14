const { join } = require("node:path");
const { cpSync, existsSync, mkdtempSync, mkdirSync, readFileSync, rmSync, writeFileSync } = require("node:fs");
const { execSync } = require("node:child_process");
const { tmpdir } = require("node:os");
const crypto = require("node:crypto");
const glob = require("glob");
const { App, Lifting } = require("@winglang/sdk/lib/core");
const { Node } = require("@winglang/sdk/lib/std");
const { Util } = require("@winglang/sdk/lib/util");

const createMD5ForProject = (requirementsFile, nodePath = "", path = "", handler = "") => {
  const hash = crypto.createHash('md5');
  hash.update(nodePath);
  hash.update(path);
  hash.update(handler);
  hash.update(requirementsFile);

  return hash.digest("hex");
};

exports.dirname = () => __dirname;

exports.resolve = (path1, path2) => {
  console.log(join(path1, path2))
  return join(path1, path2);
};

exports.buildSim = (options) => {
  const { nodePath, path, handler, homeEnv, pathEnv } = options;

  const requirementsPath = join(path, "requirements.txt");
  let requirements = "";
  if (existsSync(requirementsPath)) {
    requirements = readFileSync(requirementsPath, "utf8");
  }
  const md5 = createMD5ForProject(requirements, nodePath, path, handler);
  const imageName = `wing-py:${md5}`;

  const dockerfile = join(tmpdir(), `Dockerfile-${md5}`);
  if (!existsSync(dockerfile)) {
    const dockerfileContent = `
FROM public.ecr.aws/lambda/python:3.12
COPY requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt`
    writeFileSync(dockerfile, dockerfileContent);
  }

  execSync(`docker build -t ${imageName} -f ${dockerfile} ${path}`,
    {
      cwd: __dirname,
      env: { HOME: homeEnv, PATH: pathEnv }
    }
  );

  const forceReloadImage = () => {
    try {
      execSync(`docker inspect ${imageName}`);
      execSync(`docker save ${imageName} -o ${join(tmpdir(), imageName)}`);
      execSync(`docker load -i ${join(tmpdir(), imageName)}`);
      rmSync(join(tmpdir(), imageName));
      return true;
    } catch {}
  };

  if (process.env.CI) {
    Util.waitUntil(forceReloadImage);
  }

  return imageName;
};

exports.buildAws = (options) => {
  const { nodePath, path, handler, homeEnv, pathEnv } = options;

  const copyFiles = (src, dest) => {
    const files = glob.sync(join(src, "**/*.py"));
    for (let file of files) {
      const newFile = file.replace(src, `${dest}/`);
      cpSync(file, newFile, { force: true });
    }
  };

  // if there is a requirements.txt file, install the dependencies
  const requirementsPath = join(path, "requirements.txt");
  if (existsSync(requirementsPath)) {
    const requirements = readFileSync(requirementsPath, "utf8");
    const md5 = createMD5ForProject(requirements, nodePath, path, handler);
    const outdir = join(tmpdir(), "py-func-", md5);
    if (!existsSync(outdir)) {
      mkdirSync(outdir, { recursive: true });
      cpSync(requirementsPath, join(outdir, "requirements.txt"));
      execSync(`docker run --rm -v ${outdir}:/var/task:rw --entrypoint python python:3.12 -m pip install -r /var/task/requirements.txt -t /var/task/python`,
        {
          cwd: outdir, 
          env: { HOME: homeEnv, PATH: pathEnv }
        }
      );
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

exports.liftSim = (resource, options, host, clients) => {
  let lifted = getLifted(resource, options.id);

  if (lifted) {
    Lifting.lift(resource, host, options.allow);
    for (let op of options.allow) {
      Node.of(resource).addConnection({
        name: op,
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
  } else if (resource.constructor?.name === "MobileNotifications") {
    if (App.of(resource).isTestEnvironment) {
      lifted = {
        id,
        path: resource.node.path,
        handle: makeEnvVarName("MOBILE_CLIENT", resource),
        type: "@winglibs.sns.MobileNotifications",
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
        type: "@winglibs.sns.MobileNotifications",
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
