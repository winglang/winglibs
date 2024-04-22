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

test "put (`returnValues=NONE`)" {
  let response = table.put(
    Item: {
      id: "1",
      body: "hello",
    },
    ReturnValues: "NONE",
  );

  assert(response.Attributes == nil);
}

test "put (`returnValues=ALL_OLD`)" {
  table.put(
    Item: {
      id: "1",
      body: "hello world",
    },
  );

  let response = table.put(
    Item: {
      id: "1",
      body: "hello there",
    },
    ReturnValues: "ALL_OLD",
  );

  assert(response.Attributes?.tryGet("body")?.asStr() == "hello world");
}
