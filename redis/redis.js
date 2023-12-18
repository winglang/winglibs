const {createClient} = require("redis");

exports.newRedisClient = async (url, redisPassword) => {
  let port = url.split(":")[2];
  let redisUrl = `redis://:${redisPassword}@localhost:${port}`;
  return await createClient({url: redisUrl});
};