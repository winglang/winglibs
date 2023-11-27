pub interface IRedis extends std.IResource {
  inflight url(): str;
  inflight set(key:str, value: str): void;
  inflight get(key: str): str?;
  inflight hset(key: str, field:str, value: str): void;
  inflight hget(key: str, field: str): str?;
  inflight sadd(key: str, value: str): void;
  inflight smembers(key: str): Array<str>?;
  inflight del(key: str): void;
}

// TODO: remove this once we have a proper way to extend interfaces
pub interface IRedisClient extends IRedis {
  inflight disconnect(): void;
  // remove them
  inflight url(): str;
  inflight set(key:str, value: str): void;
  inflight get(key: str): str?;
  inflight hset(key: str, field:str, value: str): void;
  inflight hget(key: str, field: str): str?;
  inflight sadd(key: str, value: str): void;
  inflight smembers(key: str): Array<str>?;
  inflight del(key: str): void;
}

