bring cloud;
bring util;
bring sim;
bring "../commons/api.w" as api;

interface StartWebSocketApiResult {
  inflight close(): inflight(): void;
  inflight url(): str;
}

pub class WebSocket_sim impl api.IWebSocket {
  var connectFn: inflight(str, api.Request): void;
  var disconnectFn: inflight(str, api.Request): void;
  var messageFn: inflight(str, str): void;
  state: sim.State;
  urlStateKey: str;

  pub url: str;

  new(props: api.WebSocketProps) {
    this.connectFn = inflight () => {};
    this.disconnectFn = inflight () => {};
    this.messageFn = inflight () => {};
    this.state = new sim.State();
    this.urlStateKey = "url";
    this.url = this.state.token(this.urlStateKey);
  }

  pub onConnect(handler: inflight(str, api.Request): void): void {
    this.connectFn = handler;
  }
  pub onDisconnect(handler: inflight(str, api.Request): void): void {
    this.disconnectFn = handler;
  }
  pub onMessage(handler: inflight(str, str): void): void {
    this.messageFn = handler;
  }

  pub initialize() {
    new cloud.Service(inflight () => {
      let res = WebSocket_sim._startWebSocketApi(this.connectFn, this.disconnectFn, this.messageFn);
      this.state.set(this.urlStateKey, res.url());
      return () => {
        res.close();
      };
    });
  }

  extern "./sim/wb.js" static inflight _startWebSocketApi(
    connectFn: inflight (str, api.Request): void,
    disconnectFn: inflight (str, api.Request): void,
    onmessageFn: inflight (str, str): void,
  ): StartWebSocketApiResult;

  extern "../inflight/websocket.sim.js" static inflight _sendMessage(
    connectionId: str,
    message: str,
  ): inflight(): void;
  pub inflight sendMessage(connectionId: str, message: str) {
    WebSocket_sim._sendMessage(connectionId, message);
  }
}
