bring "./workload.w" as containers;
bring cloud;

pub class Redis{
    connectionUrl: str?;
    new() {
        let image = "redis@sha256:e50c7e23f79ae81351beacb20e004720d4bed657415e68c2b1a2b5557c075ce0";
        let container = new containers.Workload(
            image: image,
            name: "redis",
            port: 6379,
            public: true
        );
        this.connectionUrl = container.publicUrl;
    }
    pub inflight getUrl(): str {
       let url = this.connectionUrl??"error";
       return url;
    }
}

let redis = new Redis();

new cloud.Function(inflight () => {
    let url = redis.getUrl();
    log("Redis URL: ${url}");
});
