bring cloud;
bring dynamodb;
bring util;
bring "./lib.w" as websockets;

let tb = new dynamodb.Table(
  name: "WebSocketTable",
  hashKey: "connectionId",
  attributes: [{
    name: "connectionId", type: "S",
  }],
);

let wb = new websockets.WebSocket(name: "MyWebSocket") as "my-websocket";

wb.onConnect(inflight(id: str): void => {
  tb.put({
    Item: {
      "connectionId": id
    }
  });
});

wb.onDisconnect(inflight(id: str): void => {
  tb.delete({
    Key: {
      "connectionId": id
    }
  });
});

wb.onMessage(inflight (id: str, body: str): void => {
  let connections = tb.scan();
  for item in connections.Items {
    wb.sendMessage(str.fromJson(item.get("connectionId")), body);
  }
});

inflight interface IWebSocketJS {
  inflight on(cmd: str, handler: inflight(str): void): void;
  inflight send(e: str): void;
  inflight close(): void;
}
class Util {
  extern "./util.js" pub static inflight _ws(url: str): IWebSocketJS;
  extern "./util.js" pub static inflight _buffer_to_string(data: str): str;
}

let counter = new cloud.Counter(initial: 1);

let receiver = new cloud.Service(inflight () => {
  let ws = Util._ws(wb.url);

  ws.on("open", () => {
    log("open socket (receiver)");
    ws.on("message", (data: str) => {
      let msg = Util._buffer_to_string(data);

      let n = num.fromStr(msg);
      assert(n >= 1 && n < 10);
      if msg == "1" {
        log("first message received");
      } elif msg == "9" {
        log("last message received");
        ws.close();
      }
    });
  });

  ws.on("close", () => {
    log("close socket (receiver)");
  });

  return () => {
    ws.close();
  };
}) as "receive message";

let sender = new cloud.Service(inflight () => {
  let ws = Util._ws(wb.url);

  ws.on("open", () => {
    log("open socket (sender)");

    ws.on("message", (data: str) => {
      let msg = Util._buffer_to_string(data);

      let n = num.fromStr(msg);
      assert(n >= 1 && n < 10);
      if msg == "1" {
        log("sender also receive the first message");
      } elif msg == "9" {
        log("sender also receive the last message");
        ws.close();
      }
    });

    for i in 1..10 {
      ws.send("{counter.inc()}");
    }
  });

  ws.on("close", () => {
    log("close socket (sender)");
  });

  return () => {
    ws.close();
  };
}) as "send message";

test "simple websocket test" {
  assert(receiver.started());
  assert(sender.started());

  log("waiting 10s");
  util.sleep(10s);

  assert(counter.peek() == 10);
}
