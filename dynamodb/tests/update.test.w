bring cloud;
bring "../dynamodb.w" as dynamodb;

let table = new dynamodb.Table(
  attributes: [
    {
      name: "id",
      type: "S",
    },
  ],
  hashKey: "id",
);

test "update" {
  table.put(
    Item: {
      id: "1",
      body: "hello world",
    },
  );

  table.update(
    Key: {
      id: "1"
    },
    UpdateExpression: "set body = :body",
    ExpressionAttributeValues: {
      ":body": "hello there"
    }
  );

  let response = table.get(
    Key: {
      id: "1"
    }
  );

  assert(response.Item?.get("body")?.asStr() == "hello there");
}