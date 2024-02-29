bring cloud;
bring aws;
bring "./../../types.w" as types;
bring "cdktf" as cdktf;
bring "./bus.w" as bus;
bring "@cdktf/provider-aws" as tfAws;

pub class EventBridge impl types.IEventBridge {
  extern "./publish.js" pub static inflight putEvent(name: str, event: types.PublishEvent): void;

  eventBridge: bus.EventBridgeBus;

  new() {
    this.eventBridge = bus.EventBridgeBus.of(this);
    log("EventBridge: created {this.eventBridge}");
  }

  pub subscribeFunction(name: str, handler: cloud.Function, pattern: Json): void {
    let rule = new tfAws.cloudwatchEventRule.CloudwatchEventRule(
      name: name,
      eventPattern: Json.stringify(pattern),
    );

    let awsHandler = aws.Function.from(handler);
    let target = new tfAws.cloudwatchEventTarget.CloudwatchEventTarget(
      rule: rule.name,
      arn: awsHandler?.functionArn!,
    );

    new tfAws.lambdaPermission.LambdaPermission(
      statementId: "AllowExecutionFromEventBridge",
      action: "lambda:InvokeFunction",
      principal: "events.amazonaws.com",
      sourceArn: rule.arn,
      functionName: awsHandler?.functionName!,
    );
  }

  pub subscribeQueue(name: str, queue: cloud.Queue, pattern: Json): void {
    let awsQueue = aws.Queue.from(queue);

    let rule = new tfAws.cloudwatchEventRule.CloudwatchEventRule(
      name: name,
      eventPattern: Json.stringify(pattern),
    );

    let target = new tfAws.cloudwatchEventTarget.CloudwatchEventTarget(
      rule: rule.name,
      arn: awsQueue?.queueArn!,
    );

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
    );

    new tfAws.sqsQueuePolicy.SqsQueuePolicy(
      queueUrl: awsQueue?.queueUrl!,
      policy: queuePolicyDocument.json,
    );
  }

  pub inflight publish(event: types.PublishEvent): void {
    let name = this.eventBridge.bus.name;
    EventBridge.putEvent(name, event);
  }

  pub onLift(host: std.IInflightHost, ops: Array<str>) {
    if let host = aws.Function.from(host) {
      if ops.contains("publish") {
        host.addPolicyStatements(aws.PolicyStatement {
          actions: ["events:PutEvents"],
          resources: [this.eventBridge.bus.arn],
        });
      }
    }
  }
}