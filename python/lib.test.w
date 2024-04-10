bring cloud;
bring http;
bring expect;
// bring "./lib.w" as python;

// let bucket = new cloud.Bucket();
// let func = new cloud.Function(python.Function.Inflight(this,
//   path: "./test-assets",
//   handler: "main.handler"
// ).lift("bucket", bucket, allow: ["get", "put"]));

// test "invokes the function" {
//   let res = func.invoke();
//   log("res: {res ?? "null"}");
//   expect.equal(Json.parse(res!).get("body"), "Hello!");
//   expect.equal(bucket.get("test.txt"), "Hello, world!");
// }

bring fs;
bring util;
new cloud.Service(inflight () => {
  fs.appendFile("/tmp/outpuuut", util.env("WING_SIMULATOR_URL"));
});

