pub struct RouteOptions {
  routeKey: str;
}

/**
 * A cloud WebSocket interface
 */
pub interface IWebSocket extends std.IResource {
  onConnect(handler: inflight(str): void): void;
  onDisconnect(handler: inflight(str): void): void;
  onMessage(handler: inflight(str, str): void): void;

  initialize(): void;

  inflight sendMessage(connectionId: str, message: str);

  inflight url(): str;
}

/**
 * Options for `WebSocket`.
 */
pub struct WebSocketProps {
  name: str;
  stageName: str?;
}
