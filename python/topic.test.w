bring cloud;
bring http;
bring expect;
bring util;
bring "./lib.w" as python;

let bucket = new cloud.Bucket();

let topic = new cloud.Topic();
topic.onMessage(new python.InflightTopicOnMessage(
  path: "./test-assets",
  handler: "main.topic_onmessage_handler",
).lift(bucket, id: "bucket", allow: ["put"]));

test "invokes the topic subscriber" {
  topic.publish("topic1");
  util.waitUntil(inflight () => {
    return bucket.exists("topic.txt");
  });

  expect.equal(bucket.get("topic.txt"), "topic1");
}
