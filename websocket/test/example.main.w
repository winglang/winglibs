bring cloud;
bring ex;
bring util;
bring "../websocket.w" as websocket;

let tb = new ex.DynamodbTable(
  name: "WebSocketTable",
  hashKey: "connectionId",
  attributeDefinitions: {
    "connectionId": "S",
  },
);

let wb = new websocket.WebSocket(name: "MyWebSocket") as "my-websocket";

wb.connect(inflight(event: str): Json => {
  let payload: Json = event;
  let requestContext = payload.get("requestContext");
  tb.putItem({
    item: {
      "connectionId": requestContext.get("connectionId")
    }
  });
  return { statusCode: 200 };
});

wb.disconnect(inflight(event: str): Json => {
  let payload: Json = event;
  let requestContext = payload.get("requestContext");
  tb.deleteItem({
    key: {
      "connectionId": requestContext.get("connectionId")
    }
  });
  return { statusCode: 200 };
});

wb.addRoute(inflight (event: str): Json => {
  let payload: Json = event;
  let body = Json.parse(str.fromJson(payload.get("body")));
  let message = str.fromJson(body.get("message"));

  let connections = tb.scan();
  for item in connections.items {
    wb.postToConnection(str.fromJson(item.get("connectionId")), message);
  }
  
  return { statusCode: 200 };
}, routeKey: "broadcast");
