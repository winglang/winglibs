bring cloud;
bring "../../commons/api.w" as api;

/**
 * Context information for an AWS WebSocket request.
 */
pub struct WebSocketAwsRequestContext {
  /**
   * The route key associated with the WebSocket request.
   */
  routeKey: str;
  /**
   * The connection ID associated with the WebSocket request.
   */
  connectionId: str;
}

/**
 * AWS WebSocket request object.
 */
pub struct WebSocketAwsRequest {
  /**
   * The context information for the AWS WebSocket request.
   */
  requestContext: WebSocketAwsRequestContext;
  /**
   * The body content of the AWS WebSocket request.
   */
  body: str;
}

/**
 * AWS WebSocket response object.
 */
pub struct WebSocketAwsResponse {
  /**
   * The status code of the AWS WebSocket response.
   */
  statusCode: num;
  /**
   * The optional body content of the AWS WebSocket response.
   */
  body: str?;
}

/**
 * Represents an interface for AWS WebSocket communication.
 */
pub interface IAwsWebSocket extends api.IWebSocket {
  /**
   * Adds a route with the specified handler function and route key to the AWS WebSocket.
   */
  addRoute(handler: cloud.Function, routeKey: str): void;
}