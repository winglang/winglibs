bring cloud;
bring util;
bring sim;
bring "../commons/api.w" as api;

interface StartWebSocketApiResult {
  inflight close(): inflight(): void;
  inflight url(): str;
}

pub class WebSocket_sim impl api.IWebSocket {
  var connectFn: inflight(str): void;
  var disconnectFn: inflight(str): void;
  var messageFn: inflight(str, str): void;
  state: sim.State;
  inflight invokeUrl: str;

  new(props: api.WebSocketProps) {
    this.connectFn = inflight () => {};
    this.disconnectFn = inflight () => {};
    this.messageFn = inflight () => {};
    this.state = new sim.State();
  }

  inflight new() {
    this.invokeUrl = "invokeUrl";
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
      let res = WebSocket_sim._startWebSocketApi(this.connectFn, this.disconnectFn, this.messageFn);
      this.state.set(this.invokeUrl, res.url());
      return () => {
        res.close();
      };
    });
  }

  pub inflight url(): str {
    return str.fromJson(this.state.get(this.invokeUrl));
  }

  extern "./sim/wb.mts" static inflight _startWebSocketApi(
    connectFn: inflight (str): void,
    disconnectFn: inflight (str): void,
    onmessageFn: inflight (str, str): void,
  ): StartWebSocketApiResult;

  extern "../inflight/websocket.sim.mts" static inflight _sendMessage(
    connectionId: str,
    message: str,
  ): inflight(): void;
  pub inflight sendMessage(connectionId: str, message: str) {
    WebSocket_sim._sendMessage(connectionId, message);
  }
}