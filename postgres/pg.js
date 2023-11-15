const pg = require("pg");

exports._query = async function(query, opts) {
  const { host, port, user, password, database, ssl } = opts;
  const client = new pg.Client({
    host,
    user,
    port,
    password,
    database,
    ssl,
  });
  await client.connect();
  const res = await client.query(query);
  await client.end();
  return res.rows;
}
