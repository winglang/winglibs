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

test "delete (`returnValues=NONE`)" {
  let response = table.delete(
    key: {
      id: "1",
    },
    returnValues: "NONE",
  );

  assert(response.attributes == nil);
}

test "delete (`returnValues=ALL_OLD`)" {
  table.put(
    item: {
      id: "1",
      body: "hello world",
    },
  );

  let response = table.delete(
    key: {
      id: "1",
    },
    returnValues: "ALL_OLD",
  );

  assert(response.attributes?.get("body")?.asStr() == "hello world");
}
