bring cloud;
bring util;
bring "../dynamodb.w" as dynamodb;

let bucket = new cloud.Bucket();
let table = new dynamodb.Table(
  attributes: [
    {
      name: "id",
      type: "S",
    },
  ],
  hashKey: "id",
);

table.onUpdate(inflight (record) => {
  bucket.putJson(record.eventName, record);
});

test "onUpdate" {
  table.put(
    Item: {
      id: "1",
      body: "hello",
    },
    ReturnValues: "NONE",
  );

  table.update(
    Key: {
      id: "1"
    },
    UpdateExpression: "set body = :body",
    ExpressionAttributeValues: {
      ":body": "hello there"
    },
    ReturnValues: "NONE",
  );

  table.delete(
    Key: {
      id: "1",
    },
    ReturnValues: "NONE",
  );

  util.sleep(2s);

  let list = bucket.list();
  assert(list.lastIndexOf("INSERT") == -1);
  assert(list.lastIndexOf("MODIFY") > -1);
  assert(list.lastIndexOf("REMOVE") == -1);
}
