bring cloud;
bring util;
bring expect;
bring "../dynamodb.w" as dynamodb;

let table = new dynamodb.Table(
  name: "my-table-name",
  attributes: [ { name: "id", type: "S" } ],
  hashKey: "id"
) as "explicit_name";

let table2 = new dynamodb.Table(
  attributes: [ { name: "id", type: "S" } ],
  hashKey: "id"
) as "implicit_name";

test "explicit table name" {
  expect.equal(table.tableName, "my-table-name");
}

test "implicit table name" {
  log(table.tableName);
  assert(table.tableName.length > 0);
}