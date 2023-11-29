bring cloud;
bring util;
bring "./host.w" as host;

let table = new host.Table();

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
