bring cloud;
bring "../dynamodb.sim.w" as dynamodb;

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

test "put (`returnValues=NONE`)" {
  let response = table.put(
    item: {
      id: "1",
      body: "hello",
    },
    returnValues: "NONE",
  );

  // assert(response.attributes?.tryGet("id")?.tryAsStr() == nil);
  assert(response.attributes == nil);
}

test "put (`returnValues=ALL_OLD`)" {
  table.put(
    item: {
      id: "1",
      body: "hello world",
    },
  );

  let response = table.put(
    item: {
      id: "1",
      body: "hello there",
    },
    returnValues: "ALL_OLD",
  );

  assert(response.attributes?.get("body")?.asStr() == "hello world");
}
