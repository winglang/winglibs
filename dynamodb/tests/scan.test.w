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
  assert(response.Items.at(0).get("id").asStr() == "1");
  assert(response.Items.at(0).get("body").asStr() == "hello");
}
