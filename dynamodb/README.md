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
  attributeDefinitions: [
    {
      attributeName: "id",
      attributeType: "S",
    },
  ],
  keySchema: [
    {
      attributeName: "id",
      keyType: "HASH",
    },
  ],
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

## License

This library is licensed under the [MIT License](./LICENSE).
