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

test "update" {
  table.put(
    Item: {
      id: "1",
      val1: "anything",
      val2: "something"
    },
  );

  let var response = table.query(
    KeyConditionExpression: "id = :id",
    ExpressionAttributeValues: {":id": "1"},
  );
  assert(response.Items[0]["val1"].asStr() == "anything");
  assert(response.Items[0]["val2"].asStr() == "something");

  table.update(
    Key: { id: "1" },
    UpdateExpression: "SET val2 = :v",
    ExpressionAttributeValues: {":v": "everything"}
  );

  response = table.query(
    KeyConditionExpression: "id = :id",
    ExpressionAttributeValues: {":id": "1"},
  );
  assert(response.Items[0]["val1"].asStr() == "anything");
  assert(response.Items[0]["val2"].asStr() == "everything");
}