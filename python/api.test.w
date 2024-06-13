// bring cloud;
// bring http;
// bring expect;
// bring util;
// bring fs;
// bring "./lib.w" as python;

// let bucket = new cloud.Bucket();
// let api = new cloud.Api();
// api.get("/test", new python.InflightApiEndpointHandler(
//   path: fs.join(@dirname, "./test-assets"),
//   handler: "main.api_handler",
// ).lift(bucket, id: "bucket", allow: ["put"]), env: { FOO: "bar" });

// new std.Test(inflight () => {
//   let res = http.get("{api.url}/test");
//   log(Json.stringify(res));
//   expect.equal(res.status, 200);
//   expect.equal(res.body, "Hello from Api Handler!");
//   expect.equal(res.headers["header1"], "value1");
//   expect.equal(res.headers["foo"], "bar");

//   util.waitUntil(inflight () => {
//     return bucket.exists("/test");
//   });
// }, timeout: 3m) as "invokes api handler";
