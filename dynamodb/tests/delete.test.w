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

test "delete (`returnValues=NONE`)" {
  let response = table.delete(
    Key: {
      id: "1",
    },
    ReturnValues: "NONE",
  );

  assert(response.Attributes == nil);
}

test "delete (`returnValues=ALL_OLD`)" {
  table.put(
    Item: {
      id: "1",
      body: "hello world",
    },
  );

  let response = table.delete(
    Key: {
      id: "1",
    },
    ReturnValues: "ALL_OLD",
  );

  assert(response.Attributes?.tryGet("body")?.asStr() == "hello world");
}
