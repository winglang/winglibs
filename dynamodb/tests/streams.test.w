bring cloud;
bring expect;
bring util;
bring "../dynamodb.w" as dynamodb;

let table = new dynamodb.Table(
  attributes: [ { name: "id", type: "S" } ],
  hashKey: "id",
);

let c = new cloud.Counter();

table.setStreamConsumer(inflight (record) => {
  log("record processed = {Json.stringify(record)}");
  c.inc();
});

test "put()" {
  table.put(
    Item: {
      id: "1",
      body: "hello {datetime.utcNow().toIso()}",
    },
  );

  util.waitUntil(() => {
    return c.peek() > 0;
  });

  expect.equal(c.peek(), 1);
}