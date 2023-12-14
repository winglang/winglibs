export const _sendMessage = (connectionId, message) => {
  let wss = global.wss;
  if (!wss) {
    return;
  }

  wss.clients.forEach((ws) => {
    if (ws.id !== connectionId) {
      return;
    }

    ws.send(message)
  });
}
