bring cloud;
bring expect;
bring "./cache.w" as momento;
bring util;

let token = new cloud.Secret(name: "MOMENTO_API_KEY");

let c = new momento.Cache(token: token) as "WinglyCache";

test "can set and get a cache value" {
  c.set("key", "value", ttl: 10s);
  let value = c.get("key");
  log(value ?? "nil");
  expect.equal(value, "value");
  util.sleep(11s);
  let value2 = c.get("key");
  log(value2 ?? "nil");
  expect.equal(value2, nil);
}
