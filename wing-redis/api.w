pub interface IRedis extends std.IResource {
   inflight url(): str;
   inflight set(key:str, value: str): void;
   inflight get(key: str): str?;
   inflight hset(key: str, field:str, value: str): num;
   inflight hget(key: str, field: str): str?;
   inflight sadd(key: str, value: str): num;
   inflight smembers(key: str): Array<str>;
   inflight del(key: str): void;
}

pub struct RedisProps {
   host: str;
   port: num;
   password: str;
   db: num;
   name: str;
}
