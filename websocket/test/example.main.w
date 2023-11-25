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

wb.onConnect(inflight(id: str): Json => {
  log(id);
  tb.putItem({
    item: {
      "connectionId": id
    }
  });
  return { statusCode: 200 };
});

wb.onDisconnect(inflight(id: str): Json => {
  log(id);
  tb.deleteItem({
    key: {
      "connectionId": id
    }
  });
  return { statusCode: 200 };
});

wb.onMessage(inflight (id: str, body: str): Json => {
  let connections = tb.scan();
  for item in connections.items {
    wb.sendMessage(str.fromJson(item.get("connectionId")), body);
  }
  
  return { statusCode: 200 };
});
