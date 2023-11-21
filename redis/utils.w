bring "./api.w" as api;

pub class Util {
  extern "./redis.js" pub static inflight newClient(url: str): api.IRedis;
}