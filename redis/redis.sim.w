bring "./api.w" as api;
bring "./utils.w" as utils;
bring cloud;
bring util;
bring sim;
bring containers;

pub class Redis_sim impl api.IRedis {
  connectionUrl: str;

  new(){
    let image = "redis:latest";
    let container = new containers.Workload(
      name: "redis",
      image: image,
      port: 6379,
      public: true,
    );
    this.connectionUrl = container.publicUrl ?? "error";
  }

  pub inflight get(key: str): str? {
    let redis = utils.newClient(this.connectionUrl);
    let val = redis.get(key);
    redis.disconnect();
    return val;
  }

  pub inflight set(key: str, value: str): void {
    let redis = utils.newClient(this.connectionUrl);
    redis.set(key, value);
    redis.disconnect();
  }

  pub inflight del(key: str): void{
    let redis = utils.newClient(this.connectionUrl);
    redis.del(key);
    redis.disconnect();
  }

  pub inflight smembers(key: str): Array<str>? {
    let redis = utils.newClient(this.connectionUrl);
    let val = redis.smembers(key);
    redis.disconnect();
    return val;
  }

  pub inflight sadd(key: str, value: str): void {
    let redis = utils.newClient(this.connectionUrl);
    redis.sadd(key, value);
    redis.disconnect();
  }

  pub inflight hget(key: str, field: str): str? {
    let redis = utils.newClient(this.connectionUrl);
    let val = redis.hget(key, field);
    redis.disconnect();
    return val;
  }

  pub inflight hset(key: str, field: str, value: str): void {
    let redis = utils.newClient(this.connectionUrl);
    redis.hset(key, field, value);
    redis.disconnect();
  }

  pub inflight url(): str {
    return this.connectionUrl;
  }
}