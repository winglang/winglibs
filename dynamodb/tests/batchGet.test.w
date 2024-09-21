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

test "batchGet" {
  table.put(
    Item: {
      id: "1",
      body: "hello",
    },
  );

  table.put(
    Item: {
      id: "2",
      body: "wing",
    },
  );

  table.put(
    Item: {
      id: "3",
      body: "world",
    },
  );

  let response = table.batchGet(
    Keys: [
      {"id": "1"},
      {"id": "3"},
    ]
  );

  assert(response.UnprocessedKeys.size() == 0);

  let obj1 = response.Responses?.get(table.tableName)?.at(0);
  let obj2 = response.Responses?.get(table.tableName)?.at(1);

  assert(obj1?.get("body") == "hello");
  assert(obj2?.get("body") == "world");
}
