const {
  generateRoutes,
  generateSpec,
} = require("tsoa");
const { join, resolve } = require("node:path");
const { execSync } = require("node:child_process");
const { mkdtempSync, watch } = require("node:fs");

const build = async (file, outdir, cwd, homeEnv, pathEnv) => {
  const code = `
require("tsup").build({
  entry: ["${file}"],
  sourcemap: true,
  dts: false,
  outDir: "${outdir}",
  target: "esnext",
}).then((res) => {
  console.log("build finished");
})
`
  execSync(`node -e '${code}'`, { env: { HOME: homeEnv, PATH: pathEnv }, cwd });
}

const buildAndStartServer = async (runServer, props, clients, lastPort) => {
  const outdir = await exports.buildService(props);
  console.log("starting server...");
  const res = await runServer(join(outdir.outdir, "routes.js"), clients, lastPort);
  return { port: res.port, close: res.close, outdir };
};

exports.startService = async (props) => {
  const { basedir, options, clients, lastPort } = props;
  try {
    let res;
    let port = lastPort;
    const { runServer } = require("./app.js");
    if (options.watchDir) {
      console.log("watching directory...", join(basedir, options.watchDir))
      watch(join(basedir, options.watchDir), { recursive: true }, async () => {
        if (res) {
          res.close();
        }

        res = await buildAndStartServer(runServer, props, clients, port);
        port = res.port();
      });
    }

    res = await buildAndStartServer(runServer, props, clients, port);
    port = res.port();
    return {
      specFile: () => res.outdir.specFile,
      port: () => port,
      close: () => {
        res.close();
      },
    };
  } catch (e) {
    console.log(e);
    throw e;
  }
}

exports.buildService = async (props) => {
  const { basedir, workdir, options, homeEnv, pathEnv, clients } = props;
  try {
    const specOptions = {
      entryFile: options.entryFile ? join(basedir, options.entryFile) : "./app.js",
      noImplicitAdditionalProperties: "throw-on-extras",
      controllerPathGlobs: options.controllerPathGlobs.map((path) => join(basedir, path)),
      outputDirectory: join(basedir, options.outputDirectory),
      spec: options.spec ? {
        outputDirectory: options.spec.outputDirectory ? join(basedir, options.spec.outputDirectory) : undefined,
        specVersion: options.spec.specVersion ?? 3
      } : undefined,
    };

    const routeOptions = {
      entryFile: options.entryFile ? join(basedir, options.entryFile) : "./app.js",
      noImplicitAdditionalProperties: "throw-on-extras",
      controllerPathGlobs: options.controllerPathGlobs.map((path) => join(basedir, path)),
      routesDir: join(basedir, options.routesDir),
      bodyCoercion: false,
      middlewareTemplate: join(require.resolve("@tsoa/cli"), "../routeGeneration/templates/express.hbs"),
    };
  
    console.log("generating spec and routes...");
    await Promise.all([generateSpec(specOptions), generateRoutes(routeOptions)]);
    console.log("compiling routes...");
    const outdir = mkdtempSync(join(resolve(workdir), "-cache-tsoa"))
    await build(require.resolve(join(routeOptions.routesDir, "./routes.ts")), outdir, basedir, homeEnv, pathEnv);
    return { outdir, specFile: join(specOptions.outputDirectory, "swagger.json") };
  } catch (e) {
    console.log(e);
    throw e;
  }
}

exports.build = (props) => {
  props.workdir = resolve(props.workdir);
  const { currentdir, basedir, workdir, options, homeEnv, pathEnv, clients } = props;
  console.log("building service...")
  try {
    const code = `
require("${currentdir}/lib.js").buildService(${JSON.stringify(props)}).then((res) => {
  console.log(\`output=\$\{res.outdir\}\`);
  console.log(\`specFile=\$\{res.specFile\}\`);
})
`
    const output = execSync(`node -e '${code}'`, { env: { HOME: homeEnv, PATH: pathEnv }, cwd: basedir });
    let outdir;
    let specFile;
    for (let line of output.toString().split(/\r?\n/)) {
      if (line.startsWith("output=")) {
        outdir = line.slice("output=".length);
        specFile = line.slice("specFile=".length);
      }
    }

    return { routesFile: join(outdir, "routes.js"), specFile };
  } catch (e) {
    console.log(e);
    throw e;
  }
}

exports.dirname = () => __dirname;
