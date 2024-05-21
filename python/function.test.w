bring cloud;
bring http;
bring expect;
bring util;
bring dynamodb;
bring "./node_modules/@winglibs/sns/lib.w" as sns;
bring "./lib.w" as python;

let table = new dynamodb.Table(
  attributes: [
    {
      name: "id",
      type: "S",
    },
  ],
  hashKey: "id",
) as "table1";

let mobileClient = new sns.MobileClient();

let bucket = new cloud.Bucket();
bucket.addObject("test.txt", "Hello, world!");

let func = new cloud.Function(new python.InflightFunction(
  path: "./test-assets",
  handler: "main.handler",
  lift: {
    "bucket": {
      obj: bucket,
      allow: ["get", "put"],
    },
    "table": {
      obj: table,
      allow: ["get", "put"],
    },
    "sms": {
      obj: mobileClient,
      allow: ["publish"],
    },
  },
), { env: { "FOO": "bar" } });

test "invokes the function" {
  table.put(Item: { id: "test", body: "dynamoDbValue" });

  let res = func.invoke("function1");
  log("res: {res ?? "null"}");
  expect.equal(Json.parse(res!).get("body"), "Hello!");
  expect.equal(bucket.get("test.txt"), "Hello, world!function1bardynamoDbValue");
}
