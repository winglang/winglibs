bring cloud;
bring http;
bring expect;
bring util;
bring fs;
bring "./lib.w" as python;

let bucket = new cloud.Bucket();
bucket.onCreate(new python.InflightBucketEventHandler(
  path: fs.join(@dirname, "./test-assets"),
  handler: "main.bucket_oncreate_handler",
).lift(bucket, id: "bucket", allow: ["put"]));

new std.Test(inflight () => {
  bucket.put("key1", "value1");
  util.waitUntil(inflight () => {
    return bucket.get("key1").lowercase() == "oncreate";
  });
}, timeout: 3m) as "invokes bucket on create";
