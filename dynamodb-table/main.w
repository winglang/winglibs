bring cloud;
bring util;
bring "./lib.w" as lib;

let table = new lib.Table();

new cloud.Service(inflight () => {
  table.processStreamRecords();
}) as "Process Stream Records";

new cloud.Function(inflight () => {
  table.putItem(
    item: {
      id: { S: util.nanoid() },
    },
  );
}) as "Create Random Item";
