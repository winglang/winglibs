pub struct RouteOptions {
  routeKey: str;
}

pub interface IWebSocket {
  connect(handler: inflight(str): Json): void;
  disconnect(handler: inflight(str): Json): void;
  addRoute(handler: inflight(str): Json, props: RouteOptions): void;

  inflight postToConnection(connectionId: str, message: str);
}

pub struct WebSocketProps {
  name: str;
  stageName: str?;
}
