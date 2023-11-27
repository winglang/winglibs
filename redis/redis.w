bring util;
bring "./api.w" as api;
bring "./redis.sim.w" as sim;

pub class Redis impl api.IRedis {
  inner: api.IRedis;
  
  new() {
    let target = util.env("WING_TARGET");
    if target == "sim" {
      this.inner = new sim.Redis_sim();
    } else {
      throw "unsupported target {target}";
    }
  }

  pub inflight get(key: str): str? {
    return this.inner.get(key);
  }

  pub inflight set(key: str, value: str): void? {
    return this.inner.set(key, value);
  }

  pub inflight del(key: str): void? {
    return this.inner.del(key);
  }

  pub inflight url(): str {
    return this.inner.url();
  }

  pub inflight hget(key: str, field: str): str? {
    return this.inner.hget(key, field);
  }

  pub inflight hset(key: str, field: str, value: str): void? {
    return this.inner.hset(key, field, value);
  }

  pub inflight smembers(key: str): Array<str>? {
    return this.inner.smembers(key);
  }

  pub inflight sadd(key: str, value: str): void? {
    return this.inner.sadd(key, value);
  }
}


