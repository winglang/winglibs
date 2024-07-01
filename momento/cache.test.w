bring expect;
bring "./cache.w" as momento;
bring util;

let c = new momento.Cache() as "WinglyCache";
let c2 = new momento.Cache() as "WinglyCache2";

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
