bring "cdktf" as cdktf;
bring "@cdktf/provider-aws" as aws;
bring cloud;
bring aws as awsUtil;
bring "./api.w" as api;

struct Record {
  body: str;
}

struct SqsEvent {
  Records: Array<Record>;
}

pub class FifoQueue_aws impl api.IFifoQueue {
  queue: aws.sqsQueue.SqsQueue;
  url: str;
  arn: str;
  new(props: api.FifoQueueProps?) {
    this.queue = new aws.sqsQueue.SqsQueue(
      visibilityTimeoutSeconds: props?.timeout?.seconds
        ?? duration.fromSeconds(120).seconds,
      messageRetentionSeconds: props?.retentionPeriod?.seconds
        ?? duration.fromHours(1).seconds,
      fifoQueue: true,
      contentBasedDeduplication: true,
    );
    this.url = this.queue.url;
    this.arn = this.queue.arn;
  }

  pub setConsumer(handler: inflight (str) : void, options: api.SetConsumerOptions?) {
    let lambdaFn = new cloud.Function(inflight (event) => {
      let json: Json = unsafeCast(event);
      let sqsEvent = SqsEvent.fromJson(event);
      for message in sqsEvent.Records {
        handler(message.body);
      }
    }, env: options?.env, logRetentionDays: options?.logRetentionDays, memory: options?.memory, timeout: options?.timeout);

    let lambda = awsUtil.Function.from(lambdaFn);
    lambda?.addPolicyStatements({
      actions: [
        "sqs:ReceiveMessage",
        "sqs:ChangeMessageVisibility",
        "sqs:GetQueueUrl",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes",
      ],
      resources: [this.arn],
    });

    new aws.lambdaEventSourceMapping.LambdaEventSourceMapping(
      functionName: "{lambda?.functionName}",
      eventSourceArn: this.arn,
      batchSize: options?.batchSize ?? 1
    );
  }

  pub onLift(host: std.IInflightHost, ops: Array<str>) {
    if let lambda = awsUtil.Function.from(host) {
      if ops.contains("push") {
        lambda.addPolicyStatements({
          actions: ["sqs:SendMessage"],
          effect: awsUtil.Effect.ALLOW,
          resources: [
            this.arn
          ]
        });
      }
    }
  }

  pub inflight push(message: str, options: api.PushOptions) {
    FifoQueue_aws._push(this.url, message, options.groupId);
  }

  extern "./aws.js" static inflight _push(queueUrl: str, message: str, groupId: str): void;
}
