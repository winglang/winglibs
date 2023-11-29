bring cloud;
bring util;
bring "./host.w" as host;

let table = new host.Table();

new cloud.Service(inflight () => {
  table.processStreamRecords();
});

new cloud.Function(inflight () => {
  table.putItem(
    item: {
      id: { S: "1" },
      name: { S: "John Doe"},
      age: { N: "42" },
    },
  );

  let item = table.getItem(
    key: {
      id: { S: "1" },
    },
  );
  log(Json.stringify(unsafeCast(item)?.Item));
});
