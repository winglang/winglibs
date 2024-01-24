bring cloud;
bring expect;
bring http;
bring util;
bring "./inflight.w" as typescript;

let myBucket = new cloud.Bucket();
let myQueue = new cloud.Queue();

new cloud.Function(inflight () => {
  myBucket.put("bing.txt", "123");
}) as "write";

let handler = new typescript.Inflight(
  src: "./example/index",
  lift: {
    myBucket: { obj: myBucket, ops: ["put"] },
    myQueue: { obj: myQueue, ops: ["push"] },
  }
);

myQueue.setConsumer(inflight (msg) => {
  log("queue received {msg}");
});

let fn = new cloud.Function(handler.forFunction()) as "typescript function";

let api = new cloud.Api();
api.get("/foo", handler.forApiEndpoint());
api.post("/bar", handler.forApiEndpoint());

test "api" {
  let response = http.get("{api.url}/foo?boom=42");
  log(response.body);
  let body = Json.parse(response.body);
  expect.equal(body.get("message").asStr(), "Hello, TypeScript");
  expect.equal(body.get("event").get("query").get("boom").asStr(), "42");
}

test "queue" {
  myQueue.push("boom boom");

  // this asserts that the consumer actually pops from the queue
  util.waitUntil(() => {
    return myQueue.approxSize() == 0;
  });
}

test "function" {
  let response = fn.invoke("18993487");
  let r: Json = unsafeCast(response);

  let bodyStr = r.get("body").asStr();

  let body = Json.parse(bodyStr);
  expect.equal(body.get("event").asStr(), "18993487");
  expect.equal(body.get("message").asStr(), "Hello, TypeScript");

  // expect the bucket to have an object
  expect.equal(myBucket.get("hello.txt"), "from typescript");

}