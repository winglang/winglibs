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
  assert(response.Items.at(0).get("id").asStr() == "1");
  assert(response.Items.at(0).get("sk").asStr() == "a");
  assert(response.Items.at(0).get("body").asStr() == "hello a");
  assert(response.Items.at(1).get("id").asStr() == "1");
  assert(response.Items.at(1).get("sk").asStr() == "b");
  assert(response.Items.at(1).get("body").asStr() == "hello b");
}
