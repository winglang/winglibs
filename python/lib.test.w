bring cloud;
bring http;
bring expect;
bring "./lib.w" as python;

let bucket = new cloud.Bucket();
let func = new cloud.Function(python.Function.Inflight(this,
  path: "./test-assets",
  handler: "main.handler"
).lift("bucket", bucket, allow: ["get", "put"]));
  bring util;
test "invokes the function" {
  let res = func.invoke();
  log("calling wing simulator{util.env("WING_SIMULATOR_URL")}");
      let resss = http.post("{util.env("WING_SIMULATOR_URL")}/v1/call", { body: Json.stringify({
        "caller": util.env("WING_SIMULATOR_CALLER"),
        "handle": "asdasds",
        "method": "put",
        "args": ["aaa", "bbb"],
      })});
      log("called {Json.stringify(resss)}");
  log("res: {res ?? "null"}");
  expect.equal(Json.parse(res!).get("body"), "Hello!");
  expect.equal(bucket.get("test.txt"), "Hello, world!");
}
