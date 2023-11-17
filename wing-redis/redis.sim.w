bring "./api.w" as api;
bring "./utils.w" as utils;
bring cloud;
bring util;
bring sim;

pub class Redis_sim impl api.IRedis {
    redisContainerName: str;
    redisImage: str;
    state: sim.State;

    init() {
    this.redisContainerName = "wing-sim-redis-${this.node.id}-${util.uuidv4()}";
    // Redis version 7.0.9
    this.redisImage = "redis@sha256:e50c7e23f79ae81351beacb20e004720d4bed657415e68c2b1a2b5557c075ce0";
    this.state = new sim.State();
    // start and stop the instance
    let s = new cloud.Service(inflight () => {
        this.start();
        return () => {     
            this.stop();
        };
    });
    }
    inflight start(){
        log("starting redis server locally");
        try{
            // check if image exists
            utils.shell("docker", ["image", "inspect", this.redisImage]);
            log("image already exists ${this.redisImage}");
        }catch{
            // pull image
            log("pulling image ${this.redisImage}");
            utils.shell("docker", ["pull", this.redisImage]);
        }
        log("starting container ${this.redisContainerName}");
        utils.shell("docker", ["run", "-d", "--name", this.redisContainerName, "-p", "6379", this.redisImage]);

        // inspect the container to get the port
        let inspect = utils.shell("docker", ["inspect", this.redisContainerName]);
        let inspectJson = Json.parse(inspect);
        let port = inspectJson.tryGetAt(0)?.tryGet("NetworkSettings")?.tryGet("Ports")?.tryGet("6379/tcp")?.tryGetAt(0)?.tryGet("HostPort")?.asStr();
        let connectionUrl = "redis://localhost:${port}";
        // set the connection_url in the state
        this.state.set("connection_url", connectionUrl);
        // set the ioredis connection in the state
        let connection = utils.redisClient(connectionUrl);
        this.state.set("connection", connection);
        log("redis server running on port ${port}");
    }

    inflight stop() {
        log("stopping container ${this.redisContainerName}");
        utils.shell("docker", ["rm", "-f", this.redisContainerName]);
    }

    pub inflight get(key: str): str? {
        let connection:MutJson = this.state.get("connection");
        let value = utils.redisGet(connection, key);
        return value;
    }
    pub inflight set(key: str, value: str): void {
        let redisClient = this.state.get("connection");
        utils.redisSet(redisClient, key, value);
    }
    pub inflight del(key: str): void{
        let connection = this.state.get("connection").asStr();
        utils.redisDel(connection, key);
    }
    pub inflight smembers(key: str): Array<str> {
        return ["", ""];
    }
    pub inflight sadd(key: str, value: str): num {
        return 0;
    }
    pub inflight hget(key: str, field: str): str? {
        return "";
    }
    pub inflight hset(key: str, field: str, value: str):num {
        return 0;
    }
    pub inflight url(): str {
        return this.state.get("connection_url")?.asStr() ?? "";
    }
}