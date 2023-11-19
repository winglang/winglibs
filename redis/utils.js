const child_process = require("child_process");
const IoRedis = require("ioredis");


exports.shell = async function (command, args, cwd) {
    return new Promise((resolve, reject) => {
        child_process.execFile(command, args, { cwd }, (error, stdout, stderr) => {
            if (error) {
                console.error(stderr);
                return reject(error);
            }

            return resolve(stdout ? stdout : stderr);
        });
    });
};

exports.ioRedisGet = async function (redisUrl, key){
    let redis = new IoRedis(redisUrl);
    const result = await redis.get(key);
    return result;
}

exports.ioRedisSet = async function (redisUrl, key, value){
    let redis = new IoRedis(redisUrl);
    await redis.set(key, value);
}

exports.ioRedisDel = async function (redisUrl, key) {
    let redis = new IoRedis(redisUrl);
    await redis.del(key);
}

exports.ioRedisHset = async function (redisUrl, key, field, value) {
    let redis = new IoRedis(redisUrl);
    await redis.hset(key, field, value);
}

exports.ioRedisHget = async function (redisUrl, key, field) {
    let redis = new IoRedis(redisUrl);
    const result = await redis.hget(key, field);
    return result;
}

exports.ioRedisSadd = async function (redisUrl, key, value) {
    let redis = new IoRedis(redisUrl);
    await redis.sadd(key, value);
}

exports.ioRedisSmembers = async function (redisUrl, key) {
    let redis = new IoRedis(redisUrl);
    const result = await redis.smembers(key);
    return result ?? [];
}