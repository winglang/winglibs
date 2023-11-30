bring cloud;
bring util;
bring "./lib.w" as lib;

let table = new lib.Table(
  attributeDefinitions: [
    {
      attributeName: "id",
      attributeType: "S",
    },
  ],
  keySchema: [
    {
      attributeName: "id",
      keyType: "HASH",
    },
  ],
);

table.onStream(inflight (record) => {
  log("record processed = {Json.stringify(record)}");
});

new cloud.Function(inflight () => {
  table.put(
    item: {
      id: util.nanoid(),
    },
  );
}) as "Create Random Item";
