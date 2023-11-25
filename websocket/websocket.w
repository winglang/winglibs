bring util;
bring "./commons/api.w" as api;
bring "./platform/awscdk.w" as awscdk;
bring "./platform/tf-aws.w" as tfaws;

pub class WebSocket impl api.IWebSocket {
  inner: api.IWebSocket;
  
  new(props: api.WebSocketProps) {
    let target = util.env("WING_TARGET");

    if target == "tf-aws" {
      this.inner = new tfaws.WebSocket_tfaws(props) as props.name;
    } elif target == "awscdk" {
      this.inner = new awscdk.WebSocket_awscdk(props) as props.name;
    } else {
      throw "unsupported target {target}";
    }
  }

  pub onConnect(handler: inflight(str): void): void {
    this.inner.onConnect(handler);
  }
  pub onDisconnect(handler: inflight(str): void): void {
    this.inner.onDisconnect(handler);
  }
  pub onMessage(handler: inflight(str, str): void): void {
    this.inner.onMessage(handler);
  }

  pub wssUrl(): str {
    return this.inner.wssUrl();
  }

  pub inflight sendMessage(connectionId: str, message: str) {
    this.inner.sendMessage(connectionId, message);
  }
}
