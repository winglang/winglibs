bring "./api.w" as api;
bring "./utils.w" as utils;
bring cloud;
bring util;
bring sim;
bring containers;

pub class Redis_sim impl api.IRedis {

    connectionUrl: str;

    new(){
        let image = "redis@sha256:e50c7e23f79ae81351beacb20e004720d4bed657415e68c2b1a2b5557c075ce0";
        let container = new containers.Workload(
            name: "redis",
            image: image,
            port: 6379,
            public: true,
        );
        this.connectionUrl = container.publicUrl ?? "";
    }

    pub inflight get(key: str): str? {
        let redis = utils.newClient(this.connectionUrl);
        return redis.get(key);
    }

    pub inflight set(key: str, value: str): void {
        let redis = utils.newClient(this.connectionUrl);
        redis.set(key, value);
    }
    pub inflight del(key: str): void{
        let redis = utils.newClient(this.connectionUrl);
        redis.del(key);
    }
    pub inflight smembers(key: str): Array<str> {
        let redis = utils.newClient(this.connectionUrl);
        return redis.smembers(key);
    }
    pub inflight sadd(key: str, value: str): num {
        let redis = utils.newClient(this.connectionUrl);
        return redis.sadd(key, value);
    }
    pub inflight hget(key: str, field: str): str? {
        let redis = utils.newClient(this.connectionUrl);
        return redis.hget(key, field);
    }
    pub inflight hset(key: str, field: str, value: str): num {
        let redis = utils.newClient(this.connectionUrl);
        return redis.hset(key, field, value);
    }
    pub inflight url(): str {
        return this.connectionUrl;
    }
}