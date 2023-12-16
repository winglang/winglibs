bring "./api.w" as api;

pub class Util {
  extern "./redis.js" pub static inflight newRedisClient(url: str, redisPassword:str): api.IRedisClient;
}