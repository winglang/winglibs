bring cloud;
bring aws;
bring "./../../types.w" as types;
bring "aws-cdk-lib" as cdk;

pub class Bus impl types.IBus {
  extern "../shared-aws/publish.js" pub static inflight putEvent(name: str, event: types.PublishEvent): void;
  extern "./helper.js" pub static addRulePermission(handler: str, arn: str): void;

  eventBridge: cdk.aws_events.EventBus;

  new(props: types.BusProps) {
    this.eventBridge = new cdk.aws_events.EventBus(eventBusName: props.name) as "EventBridge";
  }

  pub subscribeFunction(name: str, handler: inflight (types.Event): void, pattern: Json): void {
    // event will be json of type `types.Event`
    let funk = new cloud.Function(inflight (event) => {
      let json: MutJson = unsafeCast(event);
      json.set("detailType", json.tryGet("detail-type") ?? "");
      handler(unsafeCast(event));
    });

    let awsHandler = aws.Function.from(funk);
    
    let rule = new cdk.aws_events.CfnRule(
      name: name,
      eventBusName: this.eventBridge.eventBusName,
      eventPattern: pattern,
      targets: [{
        arn: awsHandler?.functionArn,
        id: name,
      }],
    ) as name;

    Bus.addRulePermission(unsafeCast(awsHandler), rule.attrArn);
  }

  pub subscribeQueue(name: str, queue: cloud.Queue, pattern: Json): void {
    let awsQueue = aws.Queue.from(queue);
    let cdkQueue: cdk.aws_sqs.Queue = unsafeCast(queue)?.queue;
    let rule = new cdk.aws_events.CfnRule(
      name: name,
      eventBusName: this.eventBridge.eventBusName,
      eventPattern: pattern,
      targets: [{
        arn: awsQueue?.queueArn,
        id: name,
      }],
    ) as name;

    let statement = new cdk.aws_iam.PolicyStatement({
      effect: cdk.aws_iam.Effect.ALLOW,
      actions: ["sqs:SendMessage"],
      resources: [awsQueue?.queueArn!],
      principals: [new cdk.aws_iam.ServicePrincipal("events.amazonaws.com")]
    });

    cdkQueue.addToResourcePolicy(statement);
  }

  pub inflight publish(event: types.PublishEvent): void {
    let name = this.eventBridge.eventBusName;
    Bus.putEvent(name, event);
  }

  pub onLift(host: std.IInflightHost, ops: Array<str>) {
    if let host = aws.Function.from(host) {
      if ops.contains("publish") {
        host.addPolicyStatements(aws.PolicyStatement {
          effect: cdk.aws_iam.Effect.ALLOW,
          actions: ["events:PutEvents"],
          resources: [this.eventBridge.eventBusArn],
        });
      }
    }
  }
}
