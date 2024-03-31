import express, { json, urlencoded } from "express";
import { AddressInfo } from "net";

export const runServer = async (buildDir) => {
  const app = express();

  app.use(
    urlencoded({
      extended: true,
    }),
  );
  app.use(json());

  console.log(1111 , `${buildDir}/routes.js` === "../test/build/routes.js")
  try {
    await import(`${buildDir}/routes.ts`);
  } catch (e) {
    console.log(e);
  }
  const routes = await import(`${buildDir}/routes.ts`);
  routes.RegisterRoutes(app);

  return new Promise(resolve => {
    const server = app.listen(0, () => {
      if (server != null) {
        const port: AddressInfo = server.address() as AddressInfo;
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
