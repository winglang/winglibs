bring "../../dynamodb.w" as dynamodb;

let t1 = new dynamodb.Table(
  attributes: [
    {name: "k1", type: "S"},
    {name: "k2", type: "S"},
  ],
  hashKey: "k1",
  rangeKey: "k2",
);

test "transactWriteItems" {
  t1.put({
    Item: {
      "k1": "key1",
      "k2": "value1",
      "k3": "other-value1"
    }
  });
  t1.put({
    Item: {
      "k1": "key2",
      "k2": "value2",
      "k3": "other-value2"
    }
  });

  t1.transactWrite(TransactItems: [
    {
      Put: {
        Item: {
          "k1": "key3",
          "k2": "value3",
          "k3": "other-value3"
        }
      },
    },
    {
      Delete: {
        Key: { "k1": "key2", "k2": "value2" }
      },
    },
    {
      Update: {
        Key: { "k1": "key1", "k2": "value1" },
        UpdateExpression: "set k3 = :k3",
        ExpressionAttributeValues: { ":k3": "not-other-value1" }
      },
    }
  ]);

  let var r = t1.get({ Key: { "k1": "key1", "k2": "value1" } });
  assert(r.Item?.get("k1")?.asStr() == "key1");
  assert(r.Item?.get("k2")?.asStr() == "value1");
  assert(r.Item?.get("k3")?.asStr() == "not-other-value1");

  r = t1.get({ Key: { "k1": "key2", "k2": "value2" } });
  assert(r.Item?.tryGet("k1") == nil);

  r = t1.get({ Key: { "k1": "key3", "k2": "value3" } });
  assert(r.Item?.get("k1")?.asStr() == "key3");
  assert(r.Item?.get("k2")?.asStr() == "value3");
  assert(r.Item?.get("k3")?.asStr() == "other-value3");
}
