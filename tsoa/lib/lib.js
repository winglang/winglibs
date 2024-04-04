const {
  generateRoutes,
  generateSpec,
} = require("tsoa");
const { join } = require("node:path");

exports.startService = async (basedir, workdir, options) => {
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
      middlewareTemplate: join(basedir, "./templates/express.hbs"),
    };
  
    console.log("generating spec...");
    await generateSpec(specOptions);
    console.log("generating routes...");
    await generateRoutes(routeOptions);

    console.log("starting server...", options.routesDir);
    const { runServer } = require("./app.js");
    return runServer(workdir, routeOptions.routesDir);
  } catch (e) {
    console.log(e);
    throw e;
  }
}
