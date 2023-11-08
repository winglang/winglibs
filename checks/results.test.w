bring "./results.w" as r;

class MyClass {
  pub results: r.Results;

  init() {
    this.results = r.Results.of(this);
  }
}

let c1 = new MyClass() as "c1";
let c2 = new MyClass() as "c2";

test "store/load test" {
  let checkid = "a1234";
  let ts = datetime.utcNow().toIso();
  c1.results.store(checkid: checkid, checkpath: "/foo/bar", ok: true, timestamp: ts);

  // reading results through "c2" which implies that the bucket is shared
  let response = c2.results.latest(checkid);
  log(Json.stringify(response));

  assert(response?);
  assert(response?.ok == true);
  assert(response?.timestamp == ts);
}