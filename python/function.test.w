bring cloud;
bring http;
bring expect;
bring util;
bring "./lib.w" as python;

let bucket = new cloud.Bucket();
bucket.addObject("test.txt", "Hello, world!");
let func = new cloud.Function(new python.InflightFunction(
  path: "./test-assets",
  handler: "main.handler",
  lift: {
    "bucket": {
      obj: bucket,
      allow: ["get", "put"],
    }
  },
), { env: { "FOO": "bar" } });

test "invokes the function" {
  let res = func.invoke("function1");
  log("res: {res ?? "null"}");
  expect.equal(Json.parse(res!).get("body"), "Hello!");
  expect.equal(bucket.get("test.txt"), "Hello, world!function1bar");
}
