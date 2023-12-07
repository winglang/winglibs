import { WebSocketServer } from "ws";

export const _sendMessage = (connectionId: string, message: string) => {
  let wss: WebSocketServer = global.wss;
  if (!wss) {
    return;
  }

  wss.clients.forEach((ws) => {
    if ((ws as any).id !== connectionId) {
      return;
    }

    ws.send(message)
  });
}
