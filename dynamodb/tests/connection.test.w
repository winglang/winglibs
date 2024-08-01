bring cloud;
bring util;
bring expect;
bring "../dynamodb.w" as dynamodb;

let table = new dynamodb.Table(
  name: "my-connection-table",
  attributes: [ { name: "id", type: "S" } ],
  hashKey: "id"
);

if util.env("WING_TARGET") == "sim" {

  test "sim returns localhost" {
    expect.equal(table.connection.tableName, "my-connection-table");
    expect.equal(table.connection.clientConfig?.credentials?.accessKeyId, "local");
    expect.equal(table.connection.clientConfig?.credentials?.secretAccessKey, "local");
    expect.equal(table.connection.clientConfig?.region, "local");
    assert(table.connection.clientConfig?.endpoint?.startsWith("http://localhost:")!);
  }

} else {

  test "non-sim returns the table name and nil" {
    expect.equal(table.connection.tableName, "my-connection-table");
    expect.equal(table.connection.clientConfig, nil);
  }

}