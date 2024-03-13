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
    item: {
      id: "1",
      body: "hello",
    },
  );

  let response = table.scan();
  assert(response.count == 1);
  assert(response.items.at(0).get("id").asStr() == "1");
  assert(response.items.at(0).get("body").asStr() == "hello");
}
