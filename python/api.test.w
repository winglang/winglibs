bring cloud;
bring http;
bring expect;
bring util;
bring "./lib.w" as python;

let bucket = new cloud.Bucket();
let api = new cloud.Api();
api.get("/test", new python.InflightApiEndpointHandler(
  path: "./test-assets",
  handler: "main.api_handler",
).lift(bucket, id: "bucket", allow: ["put"]));

test "invokes api handler" {
  let res = http.get("{api.url}/test");
  log(Json.stringify(res));
  expect.equal(res.status, 200);
  expect.equal(res.body, "Hello from Api Handler!");
  expect.equal(res.headers["header1"], "value1");

  util.waitUntil(inflight () => {
    return bucket.exists("/test");
  });
}
