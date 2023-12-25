bring "./api.w" as api;
bring "./utils.w" as utils;
bring cloud;
bring util;
bring sim;
bring containers;

pub class Redis_sim impl api.IRedis {
  connectionUrl: str;
  redisPassword: str;
  inflight redis: api.IRedisClient;

  new() {
    let image = "redis:latest";
    this.redisPassword = "PASSWORD";
    let container = new containers.Workload(
      name: "redis",
      image: image,
      port: 6379,
      public: true,
      args: ["--requirepass", this.redisPassword]
    );
    this.connectionUrl = container.publicUrl ?? "error";
  }

  inflight new() {
    this.redis = utils.newRedisClient(this.connectionUrl, this.redisPassword);
  }

  pub inflight get(key: str): str? {
    this.redis.connect();
    let val = this.redis.get(key);
    this.redis.disconnect();
    return val;
  }

  pub inflight set(key: str, value: str): void {
    this.redis.connect();
    this.redis.set(key, value);
    this.redis.disconnect();
  }

  pub inflight del(key: str): void {
    this.redis.connect();
    this.redis.del(key);
    this.redis.disconnect();
  }

  pub inflight sMembers(key: str): Array<str>? {
    this.redis.connect();
    let val = this.redis.sMembers(key);
    this.redis.disconnect();
    return val;
  }

  pub inflight sAdd(key: str, value: str): void {
    this.redis.connect();
    this.redis.sAdd(key, value);
    this.redis.disconnect();
  }

  pub inflight hGet(key: str, field: str): str? {
    this.redis.connect();
    let val = this.redis.hGet(key, field);
    this.redis.disconnect();
    return val;
  }

  pub inflight hSet(key: str, field: str, value: str): void {
    this.redis.connect();
    this.redis.hSet(key, field, value);
    this.redis.disconnect();
  }

  pub inflight url(): str {
    return this.connectionUrl;
  }
}