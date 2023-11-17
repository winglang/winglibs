bring expect;
bring "./redis.w" as wing_redis;

let redis = new wing_redis.Redis() as "redis";

test "set and get" {
  redis.set("foo", "bar");
  expect.equal(redis.get("foo"), "bar");
}
