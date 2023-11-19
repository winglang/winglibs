bring expect;
bring "./redis.w" as wing_redis;

let redis = new wing_redis.Redis();

test "set and get" {
  redis.set("foo", "bar");
  expect.equal(redis.get("foo"), "bar");
}

test "set, get and del" {
  redis.set("foo", "bar");
  redis.del("foo");
  expect.nil(redis.get("foo"));
}

test "hset and hget" {
  redis.hset("foo", "bar", "baz");
  expect.equal(redis.hget("foo", "bar"), "baz");
}