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

wb.onConnect(inflight(id: str): void => {
  tb.putItem({
    item: {
      "connectionId": id
    }
  });
});

wb.onDisconnect(inflight(id: str): void => {
  tb.deleteItem({
    key: {
      "connectionId": id
    }
  });
});

wb.onMessage(inflight (id: str, body: str): void => {
  let connections = tb.scan();
  for item in connections.items {
    wb.sendMessage(str.fromJson(item.get("connectionId")), body);
  }
});

wb.initialize();

interface IWebSocketJS {
  inflight on(cmd: str, handler: inflight(str):void);
  inflight send(e: str): void;
  inflight close(): void;
}
class Util {
  extern "./util.mts" pub static inflight _ws(url: str): IWebSocketJS;
  extern "./util.mts" pub static inflight _buffer_to_string(data: str): str;
}

test "simple websocket test" {
  let ws = Util._ws(wb.url());
    
  ws.on("open", () => {
    ws.send("Hello WebSocket!");
  });

  ws.on("message", (data: str) => {
    let msg = Util._buffer_to_string(data);
    assert(msg == "Hello WebSocket!");
    ws.close();
  });

  ws.on("close", () => {
    log("close socket");
  });
}
