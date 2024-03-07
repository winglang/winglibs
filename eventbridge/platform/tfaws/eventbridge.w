bring cloud;
bring aws;
bring "./../../types.w" as types;
bring "cdktf" as cdktf;
bring "@cdktf/provider-aws" as tfAws;

pub class Bus impl types.IBus {
  extern "../aws/publish.js" pub static inflight putEvent(name: str, event: types.PublishEvent): void;

  busName: str;
  busArn: str;

  new(props: types.BusProps) {
    let bus = new tfAws.cloudwatchEventBus.CloudwatchEventBus(name: props.name) as "EventBridge";
    this.busName = bus.name;
    this.busArn = bus.arn;
    log("EventBridge: created {bus}");
  }

  pub subscribeFunction(name: str, handler: inflight (types.Event): void, pattern: Json): void {
    let rule = new tfAws.cloudwatchEventRule.CloudwatchEventRule(
      name: name,
      eventBusName: this.busName,
      eventPattern: Json.stringify(pattern),
    ) as name;

    // event will be json of type `types.Event`
    let funk = new cloud.Function(inflight (event) => {
      let json: MutJson = unsafeCast(event);
      json.set("detailType", json.tryGet("detail-type") ?? "");
      handler(unsafeCast(event));
    });

    let awsHandler = aws.Function.from(funk);
    let target = new tfAws.cloudwatchEventTarget.CloudwatchEventTarget(
      rule: rule.name,
      arn: awsHandler?.functionArn!,
      eventBusName: this.busName,
    ) as "{name}-target";

    new tfAws.lambdaPermission.LambdaPermission(
      statementId: "AllowExecutionFromEventBridge",
      action: "lambda:InvokeFunction",
      principal: "events.amazonaws.com",
      sourceArn: rule.arn,
      functionName: awsHandler?.functionName!,
    ) as "{name}-permission";
  }

  pub subscribeQueue(name: str, queue: cloud.Queue, pattern: Json): void {
    let awsQueue = aws.Queue.from(queue);

    let rule = new tfAws.cloudwatchEventRule.CloudwatchEventRule(
      name: name,
      eventBusName: this.busName,
      eventPattern: Json.stringify(pattern),
    ) as name;

    let target = new tfAws.cloudwatchEventTarget.CloudwatchEventTarget(
      rule: rule.name,
      arn: awsQueue?.queueArn!,
      eventBusName: this.busName,
    ) as "{name}-target";

    let queuePolicyDocument = new tfAws.dataAwsIamPolicyDocument.DataAwsIamPolicyDocument(
      statement: {
        effect: "Allow",
        actions: ["sqs:SendMessage"],
        resources: [awsQueue?.queueArn],
        principals: {
          type: "Service",
          identifiers: ["events.amazonaws.com"],
        },
      }
    ) as "{name}-policy-document";

    new tfAws.sqsQueuePolicy.SqsQueuePolicy(
      queueUrl: awsQueue?.queueUrl!,
      policy: queuePolicyDocument.json,
    ) as "{name}-policy";
  }

  pub inflight publish(event: types.PublishEvent): void {
    let name = this.busName;
    Bus.putEvent(name, event);
  }

  pub onLift(host: std.IInflightHost, ops: Array<str>) {
    if let host = aws.Function.from(host) {
      if ops.contains("publish") {
        host.addPolicyStatements(aws.PolicyStatement {
          actions: ["events:PutEvents"],
          resources: [this.busArn],
        });
      }
    }
  }
}
