bring expect;
bring util;
bring "./lib.w" as l;
bring cloud;
bring sim;

let db = new l.Database(name: "test", pgVersion: 15);

let myport = db.connection.port;
assert(myport.contains("#attrs.port")); // <-- token

test "run a simple query" {
  let result = db.query("SELECT 1 as one, 2 as two;");
  expect.equal(result[0], {one: 1, two: 2});
}

test "port is only resolved after the database is created" {
  assert(num.fromStr(myport) > 10);
}
