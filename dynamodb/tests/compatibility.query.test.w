bring "../dynamodb.w" as dynamodb;

let t1 = new dynamodb.Table(
  attributes: [
    {name: "k1", type: "S"},
    {name: "k2", type: "S"},
  ],
  hashKey: "k1",
  rangeKey: "k2",
);

test "query" {
  t1.put({
    Item: {
      "k1": "key1",
      "k2": "value1",
      "k3": "other-value1"
    }
  });
  t1.put({
    Item: {
      "k1": "key1",
      "k2": "value2",
      "k3": "other-value2"
    }
  });

  let result = t1.query(
    KeyConditionExpression: "k1 = :k1",
    ExpressionAttributeValues: {
      ":k1": "key1",
    },
  );

  assert(result.Count == 2);
  assert(result.Items[0]["k1"] == "key1");
  assert(result.Items[0]["k2"] == "value1");
  assert(result.Items[0]["k3"] == "other-value1");
  assert(result.Items[1]["k1"] == "key1");
  assert(result.Items[1]["k2"] == "value2");
  assert(result.Items[1]["k3"] == "other-value2");
}
