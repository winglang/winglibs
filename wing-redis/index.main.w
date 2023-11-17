bring ex;
bring cloud;
bring "./redis.w" as wing_redis;

let redis1 = new wing_redis.Redis() as "Redis1";
// let redis2 = new wing_redis.Redis() as "Redis2";

let key = "KEY";
let value = "VALUE";

new cloud.Function(inflight () => {
    redis1.set(key, value);
    log("value set to redis1 successfully");
}) as "setValToRedis1";

