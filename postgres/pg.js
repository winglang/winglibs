const pg = require("pg");

exports._query = async function(query, opts) {
  const client = await connectWithRetry(opts);
  const res = await client.query(query);
  await client.end();
  return res.rows;
}

// workaround for readiness probe
async function connectWithRetry(opts, maxRetries = 5, interval = 1000) {
  for (let i = 0; i < maxRetries; i++) {
    try {
      const client = new pg.Client(opts);
      await client.connect();
      return client;
    } catch (error) {
      if (i === maxRetries - 1) throw error;
      await new Promise(resolve => setTimeout(resolve, interval));
    }
  }
}
