bring cloud;
bring expect;
bring http;
bring util;
bring aws;
bring "./lib.w" as l;

let api = new cloud.Api();
api.get("/hello", inflight (req) => {
  log("GET - This route is protected");

  return  {
    status: 200
  };
});

api.post("/hello", inflight (req) => {
  log("POST - This route is protected too");

  return  {
    status: 200
  };
});

api.put("/hello", inflight (req) => {
  log("PUT - This route is not protected");

  return  {
    status: 200
  };
});

let auth = new l.Cognito(api);
auth.get("/hello");
auth.post("/hello");

test "access endpoint with cognito auth" {
  expect.equal(http.get("{api.url}/hello").status, 401);
  expect.equal(http.post("{api.url}/hello").status, 401);
  expect.equal(http.put("{api.url}/hello").status, 200);

  auth.signUp("fakeId@monada.co", "This-is-my-test-99!");
  auth.adminConfirmUser("fakeId@monada.co");
  let token = auth.initiateAuth("fakeId@monada.co", "This-is-my-test-99!");
  let res2 = http.get("{api.url}/hello", headers: {
    "Authorization": "Bearer {token}"
  });

  expect.equal(res2.status, 200);

  let res3 = http.post("{api.url}/hello", headers: {
    "Authorization": "Bearer {token}"
  });

  expect.equal(res3.status, 200);
}

test "throw error when credentials are invalid" {
  let var err = false;
  auth.signUp("fakeId@monada.co", "This-is-my-test-99!");
  auth.adminConfirmUser("fakeId@monada.co");
  try {
    let token = auth.initiateAuth("fakeId@monada.co", "not-my-password");
  } catch {
    err = true;
  }

  expect.equal(err, true);
}
