const {createClient} = require("redis");

exports.newClient = async (url) => {
  let port = url.split(":")[2];
  let redisUrl = `redis://:PASSWORD@localhost:${port}`;
  return await createClient({url: redisUrl});
};