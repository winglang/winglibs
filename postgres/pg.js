const pg = require("pg");

exports._query = async function(query, opts) {
  const client = await connectWithRetry(opts);
  const res = await client.query(query);
  await client.end();
  return res.rows;
}
exports._queryWithConnectionString = async function(query, connectionString) {
  const client = await connectWithRetry({ connectionString: encodePasswordInConnectionString(connectionString) });
  const res = await client.query(query);
  await client.end();
  return res.rows;
}

function encodePasswordInConnectionString(connectionString) {
  const regex = /^(postgresql:\/\/)([^:]+):([^@]+)@([^:\/]+)(:\d+)?\/(.+)$/;
  const match = connectionString.match(regex);

  if (!match) {
    throw new Error('Invalid connection string format');
  }

  const [, protocol, username, password, host, port, database] = match;

  const encodedPassword = encodeURIComponent(password);

  return `${protocol}${username}:${encodedPassword}@${host}${port ?? ""}/${database}`;
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
