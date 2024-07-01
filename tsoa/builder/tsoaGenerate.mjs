/// This is run from build.ts in a separate process to use async APIs from tsoa
import { generateRoutes, generateSpec } from "tsoa";

const args = process.argv.slice(2);
if (args.length !== 1) {
  throw new Error(
    "Expected exactly one argument: stringified JSON options object"
  );
}
/** @type {{ controllerPathGlobs: string[]; outputDirectory: string; }} */
const options = JSON.parse(args[0]);
const entryFile = "";

/**
 * @type {import("tsoa").ExtendedSpecConfig}
 */
const specOptions = {
  entryFile: entryFile,
  noImplicitAdditionalProperties: "throw-on-extras",
  controllerPathGlobs: options.controllerPathGlobs,
  outputDirectory: options.outputDirectory,
  specVersion: 3,
};

/**
 * @type {import("tsoa").ExtendedRoutesConfig}
 */
const routeOptions = {
  entryFile: entryFile,
  noImplicitAdditionalProperties: "throw-on-extras",
  controllerPathGlobs: options.controllerPathGlobs,
  routesDir: options.outputDirectory,
  bodyCoercion: false,
  middleware: "express",
};

await Promise.all([generateSpec(specOptions), generateRoutes(routeOptions)]);
