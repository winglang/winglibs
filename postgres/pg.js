const pg = require("pg");

exports._query = async function(query, credentials) {
  const { host, user, password, dbname } = credentials;
  const client = new pg.Client({
    host,
    user,
    password,
    database: dbname,
    ssl: true,
  });
  await client.connect();
  const res = await client.query(query);
  return res.rows;
}
