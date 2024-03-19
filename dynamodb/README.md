# dynamodb

## Prerequisites

- [winglang](https://winglang.io).

## Installation

```sh
npm i @winglibs/dynamodb
```

## Usage

```js
bring dynamodb;

let table = new dynamodb.Table(
  attributes: [
    {
      name: "id",
      type: "S",
    },
  ],
  hashKey: "id",
);

// Streams.
table.setStreamConsumer(inflight (record) => {
  log("record processed = {Json.stringify(record)}");
});

// Put and query.
test "put and query" {
  table.put(
    item: {
      id: "1",
      body: "hello",
    },
  );
  let response = table.query(
    keyConditionExpression: "id = :id",
    expressionAttributeValues: {":id": "1"},
  );
  assert(response.count == 1);
  assert(response.items.at(0).get("id").asStr() == "1");
  assert(response.items.at(0).get("body").asStr() == "hello");
}
```

In case you want to instantiate your own DynamoDB SDK, you can get the connection details like this:

```wing
let connection = table.connection();
connection.endpoint;
connection.tableName;
```

## License

This library is licensed under the [MIT License](./LICENSE).
