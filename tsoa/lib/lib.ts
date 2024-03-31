import {
  generateRoutes,
  generateSpec,
  ExtendedRoutesConfig,
  ExtendedSpecConfig,
} from "tsoa";
import { runServer } from "./app";

export const startService = async (options) => {
  const specOptions: ExtendedSpecConfig = {
    "entryFile": options.entryFile,
    "noImplicitAdditionalProperties": "throw-on-extras",
    "controllerPathGlobs": options.controllerPathGlobs,
    "outputDirectory": options.outputDirectory,
    "spec": {
      "outputDirectory": options.spec?.outputDirectory,
      "specVersion": options.spec?.specVersion ?? 3
    },

  };

  const routeOptions: ExtendedRoutesConfig = {
    "entryFile": options.entryFile,
	  "noImplicitAdditionalProperties": "throw-on-extras",
	  "controllerPathGlobs": options.controllerPathGlobs,
	  "routesDir": options.routesDir,
    "bodyCoercion": false,
    "middlewareTemplate": "./templates/express.hbs",
  };

  try {
    console.log("generating routes...");
    await generateSpec(specOptions);
    await generateRoutes(routeOptions);

    console.log("starting server...", options.routesDir);
    return runServer(options.routesDir);
  } catch (e) {
    console.log(e);
    throw e;
  }
}
