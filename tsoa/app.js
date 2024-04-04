const express = require("express");
const { mkdtemp } = require("fs/promises");
const { join, resolve } = require("path");
const tsImport = require("ts-import");

exports.runServer = async (workDir, buildDir) => {
  const app = express();

  app.use(
    express.urlencoded({
      extended: true,
    }),
  );
  app.use(express.json());

  try {
    const outDir = await mkdtemp(join(resolve(workDir), "-cache-tsoa"))
    const routes = tsImport.loadSync(`${buildDir}/routes.ts`, {
      mode: "compile",
      useCache: false,
      compilerOptions: {
        outDir,
      }
    });
    routes.RegisterRoutes(app);
  } catch (e) {
    console.log(e);
    throw e;
  }

  return new Promise(resolve => {
    const server = app.listen(0, () => {
      if (server != null) {
        const port = server.address();
        console.log(`Express app listening at http://localhost:${port.port}`);
        resolve({
          port: () => port.port,
          close: () => {
            server.close();
            server.closeAllConnections();
          }
        });
      }
    });
  })
}
