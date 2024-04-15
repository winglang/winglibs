bring cloud;
bring http;
bring expect;
bring "./lib.w" as python;

let bucketGet = new cloud.Bucket() as "bucket-get";
bucketGet.addObject("test.txt", "Hello, world!");

let bucketPut = new cloud.Bucket() as "bucket-put";
let func = new cloud.Function(new python.InflightFunction(
  path: "./test-assets",
  handler: "main.handler",
  lift: {
    "bucket-get": {
      obj: bucketGet,
      allow: ["get"],
    }
  },
).lift(bucketPut, id: "bucket-put", allow: ["put"]));

test "invokes the function" {
  let res = func.invoke();
  log("res: {res ?? "null"}");
  expect.equal(Json.parse(res!).get("body"), "Hello!");
  expect.equal(bucketPut.get("test.txt"), "Hello, world!");
}
