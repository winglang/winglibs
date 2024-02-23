bring cloud;
bring "../lib.w" as lib;

let table = new lib.Table(
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
