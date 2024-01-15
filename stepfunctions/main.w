// bring "./stepfunctions.w" as sfn;
bring "aws-cdk-lib" as cdk;
bring cloud;
bring aws;
bring "@cdktf/provider-aws" as tf_aws;
bring "cdktf" as cdktf;

pub class StateMachine {
  roleName: str;

  new(machine: cdk.aws_stepfunctions.IChainable) {

    let body = cdk.aws_stepfunctions.DefinitionBody.fromChainable(machine);
    class Principal impl cdk.aws_iam.IPrincipal {
      pub addToPrincipalPolicy(statement: cdk.aws_iam.PolicyStatement): cdk.aws_iam.AddToPrincipalPolicyResult {
        log("adding!");
        return {
          statementAdded: false,
        };
      }
    }
    let p = new Principal();
    let stack = new cdk.Stack();
    let definitionToken = body.bind(stack, p, {});
    let def: Json = stack.resolve(definitionToken);

    let role = new tf_aws.iamRole.IamRole(
      assumeRolePolicy: Json.stringify({
        Version: "2012-10-17",
        Statement: [
          {
            Effect:"Allow",
            Principal: { Service: ["states.amazonaws.com"] },
            Action:"sts:AssumeRole",
          }
        ]}
      ),
    );

    this.roleName = role.name;


    let s = def.get("definitionString").asStr();
    log(s);
    new tf_aws.sfnStateMachine.SfnStateMachine(
      definition: s,
      roleArn: role.arn,
    );
  }

  pub addToPolicy(statement: Json) {
    new tf_aws.iamRolePolicy.IamRolePolicy(
      role: this.roleName,
      policy: Json.stringify({
        "Version": "2012-10-17",
        "Statement": statement
      })
    );
  }
}

pub class InvokeInflight extends cdk.aws_stepfunctions.TaskStateBase {
  pub arn: str;

  new(handler: inflight (): void) {
    super({});

    let fn = new cloud.Function(inflight () => {
      handler();
    });

    if let arn = aws.Function.from(fn)?.functionArn {
      this.arn = arn;
    }
  }

  protected _renderTask(): Json {
    return {
      Resource: "arn:aws:states:::lambda:invoke",
      Parameters: {
        FunctionName: this.arn,
      },
    };
  }

  pub grantInvoke(s: StateMachine) {
    s.addToPolicy({
      Action: [ "lambda:InvokeFunction" ],
      Resource: [ this.arn ],
      Effect: "Allow"
    });    
  }

}

let invoke = new InvokeInflight(inflight () => {
  log("hello, inflight!");
});

let t = cdk.aws_stepfunctions.WaitTime.secondsPath("12");
invoke.next(new cdk.aws_stepfunctions.Wait(time: t));
invoke.next(new InvokeInflight(inflight () => {
  log("hello again!");
}) as "i2");

let s = new StateMachine(invoke);

