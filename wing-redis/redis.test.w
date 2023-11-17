bring expect;
bring "./redis.w" as wing_redis;

let redis = new wing_redis.Redis();

test "set and get" {
  redis.set("foo", "bar");
  expect.equal(redis.get("foo"), "bar");
}

test "set and get and del" {
  redis.set("foo", "bar");
  redis.del("foo");
  expect.nil(redis.get("foo"));
}
