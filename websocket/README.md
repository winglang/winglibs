## Wing WebSocket Support

This library allows you to create WebSocket using Wing.

## Installation

Use `npm` to install this library:

```sh
npm i @winglibs/websockets
```

## Bring it

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

/* This method is temporarily required only for local execution (target sim) and will be deprecated in the future.
*/
wb.initialize();
```

## `sim`

When executing in the Wing Simulator, the WebSocket uses the `ws` library.

## `tf-aws`

When running on AWS, the WebSocket utilizes the WebSocket API of API Gateway.

## `awscdk`

When running on AWS, the WebSocket utilizes the WebSocket API of API Gateway.
To compile to `awscdk`, we need to import the `@winglang/platform-awscdk`.

```bash
$ npm i @winglang/platform-awscdk
$ CDK_STACK_NAME=MySocketStack wing compile -t @winglang/platform-awscdk websocket.main.w
```

## Maintainers

[@marciocadev](https://github.com/marciocadev)

## License

Licensed under the [MIT License](./LICENSE).