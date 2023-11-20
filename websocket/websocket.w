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
      throw "unsupported target ${target}";
    }
  }

  pub connect(handler: inflight(str): Json): void {
    this.inner.connect(handler);
  }
  pub disconnect(handler: inflight(str): Json): void {
    this.inner.disconnect(handler);
  }
  pub addRoute(handler: inflight(str):Json, props: api.RouteOptions): void {
    this.inner.addRoute(handler, props);
  }

  pub wssUrl(): str {
    return this.inner.wssUrl();
  }

  pub inflight postToConnection(connectionId: str, message: str) {
    this.inner.postToConnection(connectionId, message);
  }
}
