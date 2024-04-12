pub inflight interface IRedis {
  inflight url(): str;
  inflight set(key:str, value: str): void;
  inflight get(key: str): str?;
  inflight hSet(key: str, field:str, value: str): void;
  inflight hGet(key: str, field: str): str?;
  inflight sAdd(key: str, value: str): void;
  inflight sMembers(key: str): Array<str>?;
  inflight del(key: str): void;
}

pub inflight interface IRedisClient extends IRedis {
  inflight connect(): void;
  inflight disconnect(): void;
}

