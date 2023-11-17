bring "./api.w" as api;
bring fs;

pub class Util {
  extern "./utils.js" pub static inflight shell(command: str, args: Array<str>, cwd: str?): str;
  // redis client methods
  extern "./utils.js" pub static inflight ioRedisGet(redisUrl:str, key:str): str;
  extern "./utils.js" pub static inflight ioRedisSet(redisUrl:str, key:str, value:str): str;
  extern "./utils.js" pub static inflight ioRedisDel(redisUrl:str, key:str): str;
  extern "./utils.js" pub static inflight ioRedisHset(redisUrl:str, key:str, field:str, value:str): num;
  extern "./utils.js" pub static inflight ioRedisHget(redisUrl:str, key:str, field:str): str;
  extern "./utils.js" pub static inflight ioRedisSadd(redisUrl:str, key:str, value:str): num;
  extern "./utils.js" pub static inflight ioRedisSmembers(redisUrl:str, key:str): Array<str>;
}