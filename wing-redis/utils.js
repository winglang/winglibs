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

exports.redisClient = async function (connectionUrl) {
    try {
        if (!connectionUrl) {
            throw new Error("connectionUrl is required")
        }
        let redis = await new IoRedis(connectionUrl);
        // redis = JSON.stringify(redis);
        return redis;
    } catch (error) {
        console.error(error);
        throw error;
    }
};

const redisGet = async (redisClient, key) =>{
    console.log("redisClient at get", redisClient);
    const value = await redisClient.get(key);
    return value;
}

const redisSet = async (redisClient, key, value) => {
    try {
        await redisClient.set(key, value);
    } catch (error) {
        console.error(error);
    }
}

exports.redisDel = async function (redisClient, key) {
    return redisClient.del(key);
}

exports.redisGet = redisGet;
exports.redisSet = redisSet;