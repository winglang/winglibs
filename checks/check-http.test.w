bring cloud;
bring "./check-http.w" as c;

let api = new cloud.Api();

api.get("/success", inflight () => {
  return { status: 200 };
});

api.get("/failure", inflight () => {
  return { status: 404, body: "damn you 404" };
});

let check_success = new c.CheckHttp(api.url, 
  path: "/success", 
  deploy: false
) as "success";

let check_failure = new c.CheckHttp(api.url, 
  path: "/failure", 
  status: 404, 
  body: "damn", 
  deploy: false
) as "failure";

test "check success" {
  assert(check_success.run().ok);
}

test "check failure" {
  assert(check_failure.run().ok);
}

