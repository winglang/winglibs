bring "./check.w" as c;
bring http;
bring cloud;
bring expect;

let checkName = "Test";
let api = new cloud.Api();
let s = new cloud.Bucket() as "customize";
let responseKey = "response.json";
let simulateFailure = inflight () => {
  s.putJson(responseKey, cloud.ApiResponse {
    status: 404
  });
};

api.get("/foo", inflight (req) => {
  let response = s.tryGetJson(responseKey) ?? { status: 200, body: req.path };
  return cloud.ApiResponse.fromJson(response);
});

new cloud.Function(simulateFailure) as "simulate failure";

let check = new c.Check(inflight () => {
  let response = http.get("{api.url}/foo");
  if !response.ok {
    throw "response status {response.status}";
  }

  log(response.body);
  expect.equal(response.body, "/foo"); // body is expected to be the path
}, deploy: false) as checkName;

test "run() with success" {
  let result = check.run();
  assert(result.ok);
  assert(result.timestamp.length > 0);
  log(Json.stringify(result));
}

test "latest() is nil before first run" {
  expect.nil(check.latest());
}

test "latest() returns the last check status" {
  let result = check.run();
  let latest = check.latest();
  log(Json.stringify(latest));
  expect.equal(latest?, true);
  expect.equal(result, latest);
}

test "run() with failure" {
  assert(check.run().ok); // first run
  simulateFailure();
  let result = check.run();
  assert(!result.ok);
  expect.equal(result.error, "response status 404");
  expect.equal(check.latest()?.ok, false);
}

let check_id = nodeof(check).id;
test "check name is set" {
  expect.equal("check {check_id}", "check {checkName}");
}