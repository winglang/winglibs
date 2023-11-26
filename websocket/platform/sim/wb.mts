import { WebSocketServer } from "ws";

export const _startWebSocketApi = (
  onConnect: (connectionId: string) => void,
  onDisconnect: (connectionId: string) => void,
  onMessage: (connectionId: string, message: string) => void) => {

  const port = Math.floor(Math.random() * 1000 + 3000);
  const wss = new WebSocketServer({ port });
  global.wss = wss;

  wss.on('connection', function connection(ws) {
    (ws as any).id = Date.now().toString().slice(-6);
    ws.on('error', console.error);

    ws.on('message', function message(data) {
      onMessage((ws as any).id, data.toString("utf8"));
    });

    ws.on('close', function () {
      onDisconnect((ws as any).id);
    });

    onConnect((ws as any).id);
  });

  return {
    close: () => {
      console.log("closing...");
      wss.close();
    },
    url: () => `ws://127.0.0.1:${port}`
  }
};
