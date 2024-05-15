bring cloud;
bring expect;
bring http;
bring util;
bring aws;
bring "./lib.w" as cognito;
bring "./types.w" as types;

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

let auth = new cognito.Cognito(api);
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

let api2 = new cloud.Api() as "api with IAM auth";
api2.get("/hello", inflight (req) => {
  log("GET - This route is protected");

  return  {
    status: 200
  };
});

let authWithIAM = new cognito.Cognito(api2, authenticationType: types.AuthenticationType.AWS_IAM) as "IAM Auth";
authWithIAM.get("/hello");

test "access endpoint with IAM auth" {
  expect.equal(http.get("{api2.url}/hello").status, 403);

  authWithIAM.signUp("fakeId@monada.co", "This-is-my-test-99!");
  authWithIAM.adminConfirmUser("fakeId@monada.co");
  let token = authWithIAM.initiateAuth("fakeId@monada.co", "This-is-my-test-99!");
  let id = authWithIAM.getId(authWithIAM.userPoolId, authWithIAM.identityPoolId, token);
  let creds = authWithIAM.getCredentialsForIdentity(token, id);
  let res = Util.fetch("{api2.url}/hello", creds);
  expect.equal(res, 200);
}

class Util {
  pub extern "./test.js" static inflight fetch(url: str, credentials: Json): num;
}