import { WebSocketServer } from "ws";
import getPort from "get-port";
import * as http from "http";

export const _startWebSocketApi = async (onConnect, onDisconnect, onMessage) => {
  const port = await getPort();
  const wss = new WebSocketServer({ port });

  wss.on('connection', function connection(ws) {
    ws.id = Date.now().toString().slice(-6);
    ws.on('error', console.error);

    ws.on('message', function message(data) {
      onMessage(ws.id, data.toString("utf8"));
    });

    ws.on('close', function () {
      onDisconnect(ws.id);
    });

    onConnect(ws.id);
  });

  // This is a local HTTP server that will be used to send messages to a client
  const server = http.createServer((req, res) => {
    const body = [];
    req.on('data', chunk => body.push(chunk)).on('end', () => {
      try {
        const jsonBody = JSON.parse(Buffer.concat(body).toString());
        const { connectionId, message } = jsonBody;
        if (!connectionId) {
          console.error("No connectionId in body:", body);
          res.statusCode = 400;
          return res.end();
        }

        for (const ws of wss.clients) {
          if (ws.id === connectionId) {
            ws.send(message)
          }
        }

        return res.end();
      } catch (e) {
        console.error("Failed to parse body as JSON:", body, e.message);
        res.statusCode = 400;
        return res.end();
      }
    });
  });

  return new Promise((ok, ko) => {
    server.listen(() => {
      return ok({
        close: () => {
          console.log("closing...");
          wss.close();
          server.close();
        },
        url: () => `ws://127.0.0.1:${port}`,
        local: () => `http://127.0.0.1:${server.address().port}`,
      });
    });
  });
};
