
bring aws;
bring cloud;
bring "cdktf" as cdktf;
bring "@cdktf/provider-aws" as tfaws;
bring "../commons/api.w" as api;

struct Record {
  body: str;
}

struct SqsEvent {
  Records: Array<Record>;
}

pub class MessageFanout_tfaws impl api.IMessageFanout {
  topic: cloud.Topic;
  topicArn: str;
  queueList: MutArray<tfaws.sqsQueue.SqsQueue>;

  new() {
    this.topic = new cloud.Topic();
    if let my_topic = aws.Topic.from(this.topic) {
      this.topicArn = my_topic.topicArn;
    }
    this.queueList = MutArray<tfaws.sqsQueue.SqsQueue>[]; 
  }

  pub addConsumer(handler: inflight(str): void, props: api.MessageFanoutProps): void {
    let my_function = new cloud.Function(inflight(event: str?): str? => {
      let json: Json = unsafeCast(event);
      let sqsEvent = SqsEvent.fromJson(event);
      for message in sqsEvent.Records {
        handler(message.body);
      }
    }) as props.name;

    let queue = new tfaws.sqsQueue.SqsQueue(
      visibilityTimeoutSeconds: props?.timeout?.seconds
        ?? duration.fromSeconds(120).seconds,
      messageRetentionSeconds: props?.retentionPeriod?.seconds
        ?? duration.fromHours(1).seconds,
    ) as "queue_" + props.name;

    let subscription = new tfaws.snsTopicSubscription.SnsTopicSubscription(
      topicArn: this.topicArn,
      endpoint: queue.arn,
      protocol: "sqs",
    ) as "subscription_" + props.name;
      
    let queue_policy = new tfaws.dataAwsIamPolicyDocument.DataAwsIamPolicyDocument(
      statement: [
        {
          effect: "Allow",
          actions: ["sqs:SendMessage"],
          resources: [queue.arn],
          principals: [{
            type: "Service",
            identifiers: ["sns.amazonaws.com"],
          }],
          conditions: [
            {
              test: "ArnEquals",
              values: [this.topicArn],
              key: "aws:SourceArn",
            }
          ]
        }
      ]
    ) as "policy_" + props.name;

    new tfaws.sqsQueuePolicy.SqsQueuePolicy(
      queueUrl: queue.id,
      policy: cdktf.Token.asString(queue_policy.json),
    ) as "queue_policy_" + props.name;

    if let lambda = aws.Function.from(my_function) {
      lambda.addPolicyStatements({
        actions: [
          "sqs:ReceiveMessage",
          "sqs:ChangeMessageVisibility",
          "sqs:GetQueueUrl",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
        ],
        resources: [queue.arn],
      });

      new tfaws.lambdaEventSourceMapping.LambdaEventSourceMapping(
        eventSourceArn: queue.arn,
        functionName: "{lambda.functionName}",
        batchSize: 1,
      ) as "event_source_mapping_" + props.name;
    }
    this.queueList.push(queue);
  }

  pub onLift(host: std.IInflightHost, ops: Array<str>): void {
    if let lambda = aws.Function.from(host) {
      let my_topic = aws.Topic.from(this.topic);

      if ops.contains("publish") {
        lambda.addPolicyStatements({
          actions: ["sns:Publish"],
          effect: aws.Effect.ALLOW,
          resources: [
            my_topic!.topicArn,
          ]
        });
      }
    }
  }

  extern "../inflight/publish.aws.js" static inflight _publish(topicArn: str, message: str): void;
  pub inflight publish(message: str) {
    MessageFanout_tfaws._publish(this.topicArn, message);
  }
}
