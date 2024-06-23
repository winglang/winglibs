bring expect;
bring aws;
bring cloud;
bring ex;
bring "../dynamodb-types.w" as dynamodb_types;
bring "../dynamodb.sim.w" as dynamodb_sim;
bring "../dynamodb.w" as dynamodb;

let tableWithBillingModeProvisioned = new dynamodb.Table({
  billingMode: dynamodb_types.BillingMode.PROVISIONED,
  attributes: [
      { name: "id", type: "S" },
  ],
  hashKey: "id",
});

let simClient = dynamodb_sim.Util.createClient({
  endpoint: "http://localhost:8000",
  region: "us-west",
  credentials: {
    accessKeyId: "accessKeyId",
    secretAccessKey: "secretAccessKey",
  },
});

test "Sim: table with billing mode `provisioned`" {

  let tableDescription = simClient.describeTable({
    TableName: tableWithBillingModeProvisioned.tableName,
  });

  expect.equal(
    tableDescription.billingMode,
    dynamodb_types.BillingMode.PROVISIONED
  );
}
