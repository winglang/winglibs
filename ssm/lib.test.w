bring expect;
bring "./lib.w" as ssm;

let param = new ssm.Parameter(name: "/winglibs/test/param1", value: "value1");
let paramRef = new ssm.ParameterRef(arn: "arn:aws:ssm:us-east-1:112233445566:parameter/param-name");

test "get parameter value" {
  expect.equal(param.value(), "value1");
}
