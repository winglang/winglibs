import { execFileSync } from "child_process";
import extern from "./builder.extern";
import * as path from "path";

let generatedRoutes = false;

export const prepareHandler: extern["prepareHandler"] = (
  shouldBuildRoutes,
  outputDirectory,
  controllerPathGlobs
) => {
  return new (class {
    lifts: any[] = [];
    get _liftMap() {
      return {
        handle: this.lifts.map((lift) => [lift.obj, lift.allow ?? []]),
      };
    }
    lift(data: any) {
      this.lifts.push(data);
    }
    _toInflight() {
      if (shouldBuildRoutes && !generatedRoutes) {
        generatedRoutes = true;
        execFileSync(
          process.execPath,
          [
            require.resolve("./tsoaGenerate.mjs"),
            JSON.stringify({
              controllerPathGlobs,
              outputDirectory,
            }),
          ],
          {
            windowsHide: true,
            stdio: "inherit",
          }
        );
        console.log("Generating routes...");
      }

      const clients = Object.fromEntries(
        this.lifts.map((lift) => {
          let id = lift.id ?? lift.obj.node.id;
          let obj = lift.obj as any;
          return [id, obj._toInflight()];
        })
      );
      return `\
(await (async () => {
  const express = require("express");
  const serverlessHttp = require("serverless-http");
  const { setLifted } = require("${path.join(__dirname, "..", "clients")}");
  const clients = { ${Object.entries(clients)
    .map(([name, liftable]) => `${name}: ${liftable}`)
    .join(",\n")}
  };
  const app = express();
  app.use((req, res, next) => {
    setLifted(clients);
    next();
  });

  app.use(
    express.urlencoded({
      extended: true,
    }),
  );
  app.use(express.json());

  const { RegisterRoutes } = require('${path.join(
    outputDirectory,
    "routes.ts"
  )}');
  RegisterRoutes(app);

  const h = serverlessHttp(app, {
    request(request, event, context) {
      const body = request.body.toString();
      if(body !== "") {
        request.body = JSON.parse(body);
      } else {
        request.body = undefined;
      }
    },
  });

  let handler = async (...args) => {
    return h(...args);
  };
  handler.handle = handler;

  return handler;
})())`;
    }
  })() as any;
};
