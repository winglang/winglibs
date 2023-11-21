const IoRedis = require("ioredis")

exports.newClient = (url) => {
    let port = url.split(":")[2];
    return new IoRedis(port)
}