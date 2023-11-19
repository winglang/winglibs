// example file for redis.w
bring ex;
bring cloud;
bring "./redis.w" as wing_redis;

let redis1 = new wing_redis.Redis() as "Redis1";

let key = "KEY";
let value = "VALUE";

new cloud.Function(inflight () => {
    redis1.set(key, value);
    log("value set to redis1 successfully");
}) as "setValToRedis1";

new cloud.Function(inflight () => {
    let value = redis1.get(key);
    log("value get from redis1 ${value}");
}) as "getValFromRedis1";

new cloud.Function(inflight () => {
    redis1.del(key);
    log("value deleted from redis1 successfully");
}) as "delValFromRedis1";

let hash = "HASH";
let field = "FIELD";
let hashValue = "HASH_VALUE";

new cloud.Function(inflight () => {
    redis1.hset(hash, field, hashValue);
    log("hash value set to redis1 successfully");
}) as "setHashValToRedis1";

new cloud.Function(inflight () => {
    let value = redis1.hget(hash, field);
    log("hash value get from redis1 ${value}");
}) as "getHashValFromRedis1";

let set = "SET";
let setValue = "SET_VALUE";

new cloud.Function(inflight () => {
    redis1.sadd(set, setValue);
    log("set value set to redis1 successfully");
}) as "setSetValToRedis1";

new cloud.Function(inflight () => {
    let value = redis1.smembers(set);
    log("set value get from redis1 ${value}");
}) as "getSetValFromRedis1";

