const { Topic: TfAwsTopic } = require("@winglang/sdk/lib/target-tf-aws/topic.js");
const { App } = require("@winglang/sdk/lib/target-tf-aws/app.js");
const { Node } = require("@winglang/sdk/lib/std/node.js");
const awsProvider = require("@cdktf/provider-aws");
const { Function } = require("./function.js");
const { tryGetPythonInflight } = require("../inflight.js");

module.exports.Topic = class Topic extends TfAwsTopic {
  constructor(
    scope,
    id,
    props,
  ) {
    super(scope, id, props);
  }

  onMessage(
    inflight,
    props = {}
  ) {
    const pythonInflight = tryGetPythonInflight(inflight);
    if (!pythonInflight) {
      return super.setConsumer(inflight, props);
    }

    let fn = this.handlers[inflight._id];
    if (fn) {
      return fn;
    }

    const consumer = new Function(
      this,
      App.of(this).makeId(this, `${this.node.id}-OnMessage`),
      inflight,
      props,
      pythonInflight,
    );
    this.handlers[inflight._id] = consumer;

    new awsProvider.snsTopicSubscription.SnsTopicSubscription(
      this,
      App.of(this).makeId(this, "TopicSubscription"),
      {
        topicArn: this.topicArn,
        protocol: "lambda",
        endpoint: consumer.lambdaArn,
      }
    );

    new awsProvider.lambdaPermission.LambdaPermission(
      this,
      `InvokePermission-${this.node.addr}`,
      {
        functionName: consumer.lambda.functionName,
        action: "lambda:InvokeFunction",
        principal: "sns.amazonaws.com",
        sourceArn: this.topic.arn,
      }
    );

    Node.of(this).addConnection({
      source: this,
      target: consumer,
      name: "onMessage()",
    });

    return consumer;
  }

  addPermissionToPublish(
    source,
    principal,
    sourceArn
  ) {
    this.permissions = new awsProvider.snsTopicPolicy.SnsTopicPolicy(
      this,
      `PublishPermission-${source.node.addr}`,
      {
        arn: this.topic.arn,
        policy: JSON.stringify({
          Statement: [
            {
              Effect: "Allow",
              Principal: {
                Service: principal,
              },
              Action: "sns:Publish",
              Resource: this.topic.arn,
              Condition: {
                ArnEquals: {
                  "aws:SourceArn": sourceArn,
                },
              },
            },
          ],
        }),
      }
    );
  }
};
