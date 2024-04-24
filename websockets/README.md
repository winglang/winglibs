# Websockets

This library enables you to create WebSockets using Wing.

WebSockets offer a persistent, bidirectional communication channel between a client and a server, facilitating real-time, low-latency communication.

By incorporating WebSockets through the Wing library, developers can enhance the interactivity and responsiveness of their applications, delivering a more engaging user experience. Whether you're building a real-time chat application or a collaborative tool, understanding and implementing WebSockets with Wing can significantly elevate your web development projects.

## Prerequisites

* [winglang](https://winglang.io).

## Installation

```sh
npm i @winglibs/websockets
```

## Usage

The example above shows us how we can broadcast a message to any connection assigned to the WebSocket.

```js
bring cloud;
bring ex;
bring websockets;

let tb = new ex.DynamodbTable(
  name: "WebSocketTable",
  hashKey: "connectionId",
  attributeDefinitions: {
    "connectionId": "S",
  },
);

let wb = new websockets.WebSocket(name: "MyWebSocket") as "my-websocket";

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
    wb.sendMessage(str.fromJson(item["connectionId"]), body);
  }
});

```

## `sim`

When executing in the Wing Simulator, the WebSocket uses the `ws` library.

## `tf-aws`

When running on AWS, the WebSocket utilizes the WebSocket API of API Gateway.

## `awscdk`

When running on AWS, the WebSocket utilizes the WebSocket API of API Gateway.
To compile to `awscdk`, we need to import the `@winglang/platform-awscdk`.


## Maintainers

[@marciocadev](https://github.com/marciocadev)

## License

This library is licensed under the [MIT License](./LICENSE).
