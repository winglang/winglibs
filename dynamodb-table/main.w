bring cloud;
bring util;
bring "./lib.w" as lib;
bring "./queues.w" as queues;

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

table.setStreamConsumer(inflight (record) => {
  log("record processed = {Json.stringify(record)}");
});

// new cloud.Function(inflight () => {
//   table.put(
//     item: {
//       id: util.nanoid(),
//     },
//   );
// }) as "Create Random Item";

let queue = new queues.FIFOQueue();

queue.setConsumer(inflight (message) => {
  // log("message = {Json.stringify(message)}");
  table.put(
    item: {
      id: message.deduplicationId,
      body: message.body,
    },
  );
});

new cloud.Function(inflight () => {
  queue.sendMessage(
    body: "hello there",
    groupId: "group_1",
    deduplicationId: util.nanoid(),
  );
});
