bring util;
bring "./commons/api.w" as api;
bring "./platform/awscdk.w" as awscdk;
bring "./platform/tf-aws.w" as tfaws;
bring "./platform/sim.w" as sim;

pub class WebSocket impl api.IWebSocket {
  inner: api.IWebSocket;

  pub url: str;
  
  new(props: api.WebSocketProps) {
    let target = util.env("WING_TARGET");

    if target == "tf-aws" {
      let ws = new tfaws.WebSocket_tfaws(props) as props.name;
      this.url = ws.url;
      this.inner = ws;
    } elif target == "awscdk" {
      let ws = new awscdk.WebSocket_awscdk(props) as props.name;
      this.url = ws.url;
      this.inner = ws;
    } elif target == "sim" {
      let ws = new sim.WebSocket_sim(props) as props.name;
      this.url = ws.url;
      this.inner = ws;
    } else {
      throw "unsupported target {target}";
    }
  }

  pub onConnect(handler: inflight(str, api.Request): void): void {
    this.inner.onConnect(handler);
  }
  pub onDisconnect(handler: inflight(str, api.Request): void): void {
    this.inner.onDisconnect(handler);
  }
  pub onMessage(handler: inflight(str, str, api.Request): void): void {
    this.inner.onMessage(handler);
  }

  pub initialize() {
    this.inner.initialize();
  }

  pub inflight sendMessage(connectionId: str, message: str) {
    this.inner.sendMessage(connectionId, message);
  }
}
