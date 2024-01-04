bring expect;
bring util;
bring "./lib.w" as l;

let db = new l.Database(name: "test", pgVersion: 15);

test "run a simple query" {
  let result = db.query("SELECT 1 as one, 2 as two;");
  expect.equal(result.at(0), {one: 1, two: 2});
}
