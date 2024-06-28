bring cloud;
bring http;
bring expect;
bring util;
bring fs;
bring "./lib.w" as python;

let bucket = new cloud.Bucket();

let topic = new cloud.Topic();
topic.onMessage(new python.InflightTopicOnMessageHandler(
  path: fs.join(@dirname, "./test-assets"),
  handler: "main.topic_onmessage_handler",
).lift(bucket, id: "bucket", allow: ["put"]));

new std.Test(inflight () => {
  topic.publish("topic1");
  util.waitUntil(inflight () => {
    return bucket.exists("topic.txt");
  });

  expect.equal(bucket.get("topic.txt"), "topic1");
}, timeout: 3m) as "invokes the topic subscriber";
