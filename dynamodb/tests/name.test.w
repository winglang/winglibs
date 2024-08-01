bring cloud;
bring util;
bring expect;
bring "../dynamodb.w" as dynamodb;

let table = new dynamodb.Table(
  name: "my-explicit-table-name",
  attributes: [ { name: "id", type: "S" } ],
  hashKey: "id"
) as "explicit name";

let table2 = new dynamodb.Table(
  attributes: [ { name: "id", type: "S" } ],
  hashKey: "id"
) as "implicit name";

// It is not possible to create 2 tests with the explicit 
// table name when using AWS; running the tests in parallel
// will result in a conflict when creating more than one table
// with the same name.
test "explicit and implicit table name" {
  expect.equal(table.tableName, "my-explicit-table-name");

  assert(table2.tableName.contains("implicit-name"));
}
