bring cloud;
bring aws;
bring "../types.w" as types;
bring "@cdktf/provider-aws" as tfaws;

struct AwsParameter {
  Name: str;
  Value: str;
}

pub class Parameter impl types.IParameter {
  key: str;
  arn: str;

  new(props: types.ParameterProps) {
    this.key = props.name;
    let parameter = new tfaws.ssmParameter.SsmParameter(
      name: this.key,
      type: "String",
      value: props.value,
    );
    this.arn = parameter.arn;
  }

  pub inflight value(): str {
    return Parameter.fetchParameter(this.key).Value;
  }

  pub onLift(host: std.IInflightHost, ops: Array<str>) {
    if let host = aws.Function.from(host) {
      if ops.contains("value") {
        host.addPolicyStatements(aws.PolicyStatement {
          actions: ["ssm:GetParameter"],
          resources: [this.arn],
          effect: aws.Effect.ALLOW,
        });
      }
    }
  }

  extern "./aws.ts" pub static inflight fetchParameter(key: str): AwsParameter;
}
