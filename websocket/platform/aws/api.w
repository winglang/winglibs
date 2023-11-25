bring cloud;
bring "../../commons/api.w" as api;

pub struct WebSocketAwsRequestContext {
  routeKey: str;
  connectionId: str;
}

pub struct WebSocketAwsRequest {
  requestContext: WebSocketAwsRequestContext;
  body: str;
}

pub struct WebSocketAwsResponse {
  statusCode: num;
  body: str?;
}

pub interface IAwsWebSocket  extends api.IWebSocket {
  addRoute(handler: cloud.Function, props: api.RouteOptions): void;
}