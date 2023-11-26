bring cloud;
bring "../commons/api.w" as api;

pub class WebSocket_sim impl api.IWebSocket {
  var connectFn: inflight(str): void;
  var disconnectFn: inflight(str): void;
  var messageFn: inflight(str, str): void;

  new(props: api.WebSocketProps) {
    this.connectFn = inflight () => {};
    this.disconnectFn = inflight () => {};
    this.messageFn = inflight () => {};
  }

  pub onConnect(handler: inflight(str): void): void {
    this.connectFn = handler;
  }
  pub onDisconnect(handler: inflight(str): void): void {
    this.disconnectFn = handler;
  }
  pub onMessage(handler: inflight(str, str): void): void {
    this.messageFn = handler;
  }

  pub initialize() {
    new cloud.Service(inflight () => {
      let res = "";
    });
  }
  pub wssUrl(): str {
    return "";
  }
  pub inflight sendMessage(connectionId: str, message: str): void {}  
}