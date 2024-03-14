bring expect;
bring "./lib.w" as ssm;

let param = new ssm.Parameter(name: "/winglibs/test/param1", value: "value1");

test "get parameter value" {
  expect.equal(param.value(), "value1");
}
