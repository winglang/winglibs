const { Queue: TfAwsQueue } = require("@winglang/sdk/lib/target-tf-aws/queue.js");
const { Node } = require("@winglang/sdk/lib/std/node.js");
const { Duration } = require("@winglang/sdk/lib/std/duration.js");
const awsProvider = require("@cdktf/provider-aws");
const { Function } = require("./function.js");

module.exports.Queue = class Queue extends TfAwsQueue {
  constructor(
    scope,
    id,
    props,
  ) {
    super(scope, id, props);
  }

  setConsumer(
    inflight,
    props = {},
  ) {
    if (inflight._inflightType !== "_inflightPython") {
      return super.setConsumer(inflight, props);
    }

    const consumer = new Function(this, "Consumer", inflight, {
      ...props,
      timeout: Duration.fromSeconds(
        this.queue.visibilityTimeoutSeconds ?? 30
      ),
    });
    
    consumer.dummy.addPolicyStatements({
      actions: [
        "sqs:ReceiveMessage",
        "sqs:ChangeMessageVisibility",
        "sqs:GetQueueUrl",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes",
      ],
      resources: [this.queue.arn],
    });

    new awsProvider.lambdaEventSourceMapping.LambdaEventSourceMapping(this, "EventSourceMapping", {
      functionName: consumer.lambda.functionName,
      eventSourceArn: this.queue.arn,
      batchSize: props.batchSize ?? 1,
    });

    Node.of(this).addConnection({
      source: this,
      target: consumer,
      name: "setConsumer()",
    });

    return consumer;
  }
};
