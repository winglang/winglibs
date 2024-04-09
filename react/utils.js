const child_process = require("node:child_process");
const http = require("node:http");

const finalhandler = require("finalhandler");
const serveStatic = require("serve-static");
const treeKill = require("tree-kill");

exports.exec = (command, env, cwd) => {
  process.env.NODE_NO_WARNINGS = "1"; // disable deprecation warnings

  const proc = child_process.exec(command, {
    env: { ...process.env, ...env },
    cwd,
  });

  proc.on("error", (error) => {
    console.log(`error: ${error}`);
  });

  // proc.stdout.setEncoding("utf8");
  // proc.stdout.on("data", (data) => {
  //   console.log(`stdout: [${command}] ${data}`);
  // });

  proc.stderr.setEncoding("utf8");
  proc.stderr.on("data", (data) => {
    console.log(`stderr: [${command}] ${data}`);
  });

  return async () => {
    await new Promise((resolve, reject) => {
      treeKill(proc.pid, "SIGKILL", (err) => {
        if (err) {
          reject(err);
        } else {
          resolve();
        }
      });
    });
  };
};

exports.execSync = (command, env, cwd) => {
  child_process.execSync(command, { env: { ...process.env, ...env }, cwd });
};

exports.serveStaticFiles = (path, port) => {
  const serve = serveStatic(path, { index: ["index.html", "index.htm"] });

  const server = http.createServer(function onRequest(req, res) {
    serve(req, res, finalhandler(req, res));
  });

  server.on("error", () => {});

  server.listen(port);

  return () => server.close();
};
