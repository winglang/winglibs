const {
  generateRoutes,
  generateSpec,
} = require("tsoa");
const { join, resolve } = require("node:path");
const { execSync } = require("node:child_process");
const { mkdtempSync } = require("node:fs");

const build = async (file, outdir, cwd, homeEnv, pathEnv) => {
  const code = `
require("tsup").build({
  entry: ["${file}"],
  sourcemap: false,
  dts: false,
  outDir: "${outdir}",
  target: "esnext",
}).then((res) => {
  console.log("build finished");
})
`
  execSync(`node -e '${code}'`, { env: { HOME: homeEnv, PATH: pathEnv }, cwd });
}
exports.startService = async (props) => {
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
  
    console.log("generating spec...");
    await generateSpec(specOptions);
    console.log("generating routes...");
    await generateRoutes(routeOptions);
    console.log("compiling routes...");
    const outdir = mkdtempSync(join(resolve(workdir), "-cache-tsoa"))
    await build(require.resolve(join(routeOptions.routesDir, "./routes.ts")), outdir, basedir, homeEnv, pathEnv);
    console.log("starting server...");
    const { runServer } = require("./app.js");
    return runServer(join(outdir, "routes.js"), clients);
  } catch (e) {
    console.log(e);
    throw e;
  }
}

exports.dirname = () => __dirname;