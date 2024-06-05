bring cloud;
bring http;
bring expect;
bring util;
bring fs;
bring "./lib.w" as python;

let bucket = new cloud.Bucket();

let queue = new cloud.Queue();
queue.setConsumer(new python.InflightQueueConsumer(
  path: fs.join(@dirname, "./test-assets"),
  handler: "main.queue_consumer_handler",
).lift(bucket, id: "bucket", allow: ["put"]));

new std.Test(inflight () => {
  queue.push("message1");
  util.waitUntil(inflight () => {
    return bucket.exists("queue.txt");
  });
  expect.equal(bucket.get("queue.txt"), "message1");
}, timeout: 3m) as "invokes a queue consumer";
