import { WebSocketServer } from "ws";
import getPort from "get-port";

export const _startWebSocketApi = async (
  onConnect,
  onDisconnect,
  onMessage) => {

  const port = await getPort();
  // const port = Math.floor(Math.random() * 1000 + 3000);
  const wss = new WebSocketServer({ port });
  global.wss = wss;

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

  return {
    close: () => {
      console.log("closing...");
      wss.close();
    },
    url: () => `ws://127.0.0.1:${port}`
  }
};
