bring cloud;
bring "../dynamodb.sim.w" as dynamodb;

let table = new dynamodb.Table_sim(
  attributes: [
    {
      name: "id",
      type: "S",
    },
  ],
  hashKey: "id",
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
