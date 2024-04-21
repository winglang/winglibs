const { Socket } = require("net");
const express = require("express");
const { setLifted } = require("./clients");

exports.runServer = async (routes, clients, lastPort) => {
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

  let port = 0;
  if (lastPort) {
    const requestedPort = parseInt(lastPort, 10);
    if (await isPortAvailable(requestedPort)) {
      port = requestedPort;
    }
  }

  return new Promise(resolve => {
    const server = app.listen(port, () => {
      if (server != null) {
        const port = server.address();
        console.log(`Express app listening at http://localhost:${port.port}`);
        resolve({
          port: () => port.port,
          close: () => {
            console.log("closing server...", port.port);
            require("fs").appendFileSync("/tmp/tnode.log", `closing server...${port.port}\n`);
            server.close();
            server.closeAllConnections();
          }
        });
      }
    });
  })
}

const LOCALHOST_ADDRESS = "127.0.0.1";

async function isPortAvailable(port) {
  return new Promise((resolve, _reject) => {
    const s = new Socket();
    s.once("error", (err) => {
      s.destroy();
      if (err.code !== "ECONNREFUSED") {
        resolve(false);
      } else {
        // connection refused means the port is not used
        resolve(true);
      }
    });

    s.once("connect", () => {
      s.destroy();
      // connection successful means the port is used
      resolve(false);
    });

    s.connect(port, LOCALHOST_ADDRESS);
  });
}
