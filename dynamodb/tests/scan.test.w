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

test "scan" {
  table.put(
    Item: {
      id: "1",
      body: "hello",
    },
  );

  let response = table.scan();
  assert(response.Count == 1);
  assert(response.Items[0]["id"].asStr() == "1");
  assert(response.Items[0]["body"].asStr() == "hello");
}
