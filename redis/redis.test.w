bring expect;
bring "./redis.w" as r;

let redis = new r.Redis();

test "set and get" {
  redis.set("foo", "bar");
  expect.equal(redis.get("foo"), "bar");
}

test "set, get and del" {
  redis.set("foo", "bar");
  expect.equal(redis.get("foo"), "bar"); 
  redis.del("foo");
  expect.nil(redis.get("foo"));
}

test "hset and hget" {
  redis.hSet("foo", "bar", "baz");
  expect.equal(redis.hGet("foo", "bar"), "baz");
}