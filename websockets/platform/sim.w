bring cloud;
bring util;
bring sim;
bring http;
bring "../commons/api.w" as api;

inflight interface StartWebSocketApiResult {
  inflight close(): inflight(): void;
  inflight url(): str;
  inflight local(): str;
}

pub class WebSocket_sim impl api.IWebSocket {
  var connectFn: inflight(str): void;
  var disconnectFn: inflight(str): void;
  var messageFn: inflight(str, str): void;
  state: sim.State;
  urlStateKey: str;
  localStateKey: str;

  pub url: str;

  new(props: api.WebSocketProps) {
    this.connectFn = inflight () => {};
    this.disconnectFn = inflight () => {};
    this.messageFn = inflight () => {};
    this.state = new sim.State();
    this.urlStateKey = "url";
    this.localStateKey = "local";

    this.url = this.state.token(this.urlStateKey);
    new cloud.Service(inflight () => {
      let res = WebSocket_sim._startWebSocketApi(this.connectFn, this.disconnectFn, this.messageFn);
      this.state.set(this.urlStateKey, res.url());
      this.state.set(this.localStateKey, res.local());
      return () => {
        res.close();
      };
    });
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

  extern "./sim/wb.js" static inflight _startWebSocketApi(
    connectFn: inflight (str): void,
    disconnectFn: inflight (str): void,
    onmessageFn: inflight (str, str): void,
  ): StartWebSocketApiResult;

  pub inflight sendMessage(connectionId: str, message: str) {
    let localUrl = this.state.get(this.localStateKey).asStr();
    http.post(localUrl, body: Json.stringify({
      connectionId: connectionId,
      message: message
    }));
  }
}
