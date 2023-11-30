bring cloud;
bring util;
bring "./lib.w" as lib;

let table = new lib.Table();

table.onStream(inflight (record) => {
  log("record processed = {Json.stringify(record)}");
});

new cloud.Function(inflight () => {
  table.putItem(
    item: {
      id: util.nanoid(),
    },
  );
}) as "Create Random Item";
