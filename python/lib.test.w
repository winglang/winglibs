bring cloud;
bring http;
bring expect;
bring "./lib.w" as python;

let bucket = new cloud.Bucket();
let func = new python.Function(
  path: "./test-assets",
  handler: "main.handler",
);

func.liftClient("bucket", bucket, ["get", "put"]);

test "invokes the function" {
  let res = func.invoke();
  log("res: {res ?? "null"}");
  expect.equal(Json.parse(res!).get("body"), "Hello!");
  expect.equal(bucket.get("test.txt"), "Hello, world!");
}
