bring cloud;
bring util;
bring "./lib.w" as lib;
bring "./queue.w" as queue;

// let table = new lib.Table(
//   attributeDefinitions: [
//     {
//       attributeName: "id",
//       attributeType: "S",
//     },
//   ],
//   keySchema: [
//     {
//       attributeName: "id",
//       keyType: "HASH",
//     },
//   ],
// );

// table.onStream(inflight (record) => {
//   log("record processed = {Json.stringify(record)}");
// });

// new cloud.Function(inflight () => {
//   table.put(
//     item: {
//       id: util.nanoid(),
//     },
//   );
// }) as "Create Random Item";

let bus = new queue.Queue();

bus.onMessage(inflight (message) => {
  log("message = {Json.stringify(message)}");
});

new cloud.Function(inflight () => {
  bus.sendMessage(
    body: "hello there",
    groupId: "group_1",
    deduplicationId: "deduplication_1",
  );
});
