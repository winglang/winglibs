bring cloud;
bring "../dynamodb.w" as dynamodb;

let table = new dynamodb.Table(
  attributes: [
    {
      name: "id",
      type: "S",
    },
    {
      name: "sk",
      type: "S",
    },
  ],
  hashKey: "id",
  rangeKey: "sk",
) as "query table";

test "query" {
  table.put(
    Item: {
      id: "1",
      sk: "a",
      body: "hello a",
    },
  );
  table.put(
    Item: {
      id: "2",
      sk: "a",
      body: "hello a",
    },
  );
  table.put(
    Item: {
      id: "1",
      sk: "b",
      body: "hello b",
    },
  );

  let response = table.query(
    KeyConditionExpression: "id = :id",
    ExpressionAttributeValues: {":id": "1"},
  );
  assert(response.Count == 2);
  assert(response.Items[0]["id"].asStr() == "1");
  assert(response.Items[0]["sk"].asStr() == "a");
  assert(response.Items[0]["body"].asStr() == "hello a");
  assert(response.Items[1]["id"].asStr() == "1");
  assert(response.Items[1]["sk"].asStr() == "b");
  assert(response.Items[1]["body"].asStr() == "hello b");
}
