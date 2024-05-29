bring cloud;
bring http;
bring expect;
bring util;
bring fs;
bring "./lib.w" as python;

let bucket = new cloud.Bucket();
bucket.onCreate(new python.InflightBucketEvent(
  path: fs.join(@dirname, "./test-assets"),
  handler: "main.bucket_oncreate_handler",
).lift(bucket, id: "bucket", allow: ["put"]));

test "invokes bucket on create" {
  bucket.put("key1", "value1");
  util.waitUntil(inflight () => {
    return bucket.get("key1") == "onCreate";
  });
}
