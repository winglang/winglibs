bring cloud;
bring expect;
bring http;
bring util;
bring aws;
bring "./lib.w" as l;

let api = new cloud.Api();
api.get("/hello", inflight (req) => {
  log("Hello World {Json.stringify(req.headers)}");

  return  {
    status: 200
  };
});

let auth = new l.Cognito(api);
auth.get("/hello");

test "access endpoint with cognito auth" {
  let res = http.get("{api.url}/hello");
  expect.equal(res.status, 401);

  auth.signUp("fakeId@monada.co", "This-is-my-test-99!");
  auth.adminConfirmUser("fakeId@monada.co");
  let token = auth.initiateAuth("fakeId@monada.co", "This-is-my-test-99!");
  let res2 = http.get("{api.url}/hello", headers: {
    "Authorization": "Bearer {token}"
  });

  expect.equal(res2.status, 200);
}
