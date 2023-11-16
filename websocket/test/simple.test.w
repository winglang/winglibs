bring cloud;
bring ex;
bring "../websocket.w" as websocket;

let tb = new ex.DynamodbTable(
  name: "WebSocketTable",
  hashKey: "connectionId",
  attributeDefinitions: {
    "connectionId": "S",
  },
);

let wb = new websocket.WebSocket(name: "MyWebSocket") as "my-websocket";

wb.connect(inflight(e: str): Json => {
  let a = Json.stringify(e);
  let b = Json.parse(a);
  let x = b.get("requestContext");
  tb.putItem({
    item: {
      "connectionId": x.get("connectionId")
    }
  });
  return { statusCode: 200 };
});

wb.disconnect(inflight(e: str): Json => {
  let a = Json.stringify(e);
  let b = Json.parse(a);
  let x = b.get("requestContext");
  tb.deleteItem({
    key: {
      "connectionId": x.get("connectionId")
    }
  });
  return { statusCode: 200 };
});