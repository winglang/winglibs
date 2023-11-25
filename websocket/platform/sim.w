bring "../commons/api.w" as api;

pub class WebSocket_sim impl api.IWebSocket {
  pub onConnect(handler: inflight(str): void): void {}
  pub onDisconnect(handler: inflight(str): void): void {}
  pub onMessage(handler: inflight(str, str): void): void {}
  pub wssUrl(): str {
    return "";
  }
  pub inflight sendMessage(connectionId: str, message: str): void {}  
}