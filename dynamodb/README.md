# dynamodb

## Prerequisites

- [winglang](https://winglang.io).
- [docker](https://www.docker.com/)

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
    Item: {
      id: "1",
      body: "hello",
    },
  );
  let response = table.query(
    KeyConditionExpression: "id = :id",
    ExpressionAttributeValues: {":id": "1"},
  );
  assert(response.Count == 1);
  assert(response.Items[0]["id"].asStr() == "1");
  assert(response.Items[0]["body"].asStr() == "hello");
}
```

In case you want to instantiate your own DynamoDB SDK, you can get the connection details like this:

```wing
table.connection.clientConfig.endpoint;
table.connection.clientConfig.credentials;
table.connection.clientConfig.region;
table.connection.tableName;
```

So you can use the AWS SDK DynamoDB client like this:

```js
new DynamoDB(table.connection.clientConfig);
```

## License

This library is licensed under the [MIT License](./LICENSE).
