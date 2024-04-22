const express = require("express");
const { setLifted } = require("./clients");

exports.runServer = async (routes, clients) => {
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

  try {
    const { RegisterRoutes } = require(routes);
    RegisterRoutes(app);
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
