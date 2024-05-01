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
) as "table1";

let table2 = new dynamodb.Table(
  attributes: [
    {
      name: "id",
      type: "S",
    },
  ],
  hashKey: "id",
) as "table2";

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

test "put in multiple tables" {
  table.put(
    Item: {
      id: "1",
      body: "hello world",
    },
  );

  table2.put(
    Item: {
      id: "1",
      body: "hello world",
    },
  );

  assert(table.get(
    Key: {
      id: "1",
    },
  ).Item?.tryGet("id")?.tryAsStr() == "1");
  assert(table2.get(
    Key: {
      id: "1",
    },
  ).Item?.tryGet("id")?.tryAsStr() == "1");
}
