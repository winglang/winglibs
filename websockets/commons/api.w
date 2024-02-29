/**
 * A cloud WebSocket interface
 */
pub interface IWebSocket extends std.IResource {
  /**
   * Adds an inflight handler to the WebSocket for connection requests.
   */
  onConnect(handler: inflight(str): void): void;
  /**
   * Adds an inflight handler to the WebSocket for disconnection requests.
   */
  onDisconnect(handler: inflight(str): void): void;
  /**
   * Adds an inflight handler to the WebSocket for processing message requests.
   */
  onMessage(handler: inflight(str, str): void): void;

  /**
   * Sends a message through the WebSocket with inflight handling.
   */
  inflight sendMessage(connectionId: str, message: str): void;
}

/**
 * Options for `WebSocket`.
 */
pub struct WebSocketProps {
  /** WebSocket api name */
  name: str;
  /**
   * Stage name
   * @default prod
   */
  stageName: str?;
}
