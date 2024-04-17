const { Bucket: TfAwsBucket } = require("@winglang/sdk/lib/target-tf-aws/bucket.js");
const { BucketEventType } = require("@winglang/sdk/lib/cloud/bucket.js");
const { Node } = require("@winglang/sdk/lib/std/node.js");
const { Topic } = require("./topic.js");

const EVENTS = {
  [BucketEventType.DELETE]: ["s3:ObjectRemoved:*"],
  [BucketEventType.CREATE]: ["s3:ObjectCreated:Put"],
  [BucketEventType.UPDATE]: ["s3:ObjectCreated:Post"],
};

module.exports.Bucket = class Bucket extends TfAwsBucket {
  constructor(
    scope,
    id,
    props,
  ) {
    super(scope, id, props);
    this._topics = {};
  }

  onCreate(inflight, opts) {
    if (inflight._inflightType !== "_inflightPython") {
      return super.onCreate(inflight, props);
    }

    let topic = this._topics[BucketEventType.CREATE];
    if (!topic) {
      topic = this.createTopic(BucketEventType.CREATE);
      this._topics[BucketEventType.CREATE] = topic;
    }

    const handler = topic.onMessage(inflight);
    handler.addEnvironment("WING_BUCKET_EVENT", BucketEventType.CREATE);
  }

  onUpdate(inflight, opts) {
    if (inflight._inflightType !== "_inflightPython") {
      return super.onUpdate(inflight, props);
    }

    let topic = this._topics[BucketEventType.UPDATE];
    if (!topic) {
      topic = this.createTopic(BucketEventType.UPDATE);
      this._topics[BucketEventType.UPDATE] = topic;
    }

    const handler = topic.onMessage(inflight);
    handler.addEnvironment("WING_BUCKET_EVENT", BucketEventType.UPDATE);
  }

  onDelete(inflight, opts) {
    if (inflight._inflightType !== "_inflightPython") {
      return super.onDelete(inflight, props);
    }

    let topic = this._topics[BucketEventType.DELETE];
    if (!topic) {
      topic = this.createTopic(BucketEventType.DELETE);
      this._topics[BucketEventType.DELETE] = topic;
    }

    const handler = topic.onMessage(inflight);
    handler.addEnvironment("WING_BUCKET_EVENT", BucketEventType.DELETE);
  }

  onEvent(inflight, opts) {
    if (inflight._inflightType !== "_inflightPython") {
      return super.onEvent(inflight, props);
    }

    this.onCreate(inflight, opts);
    this.onUpdate(inflight, opts);
    this.onDelete(inflight, opts);
  }

  createTopic(actionType) {
    const topic = new Topic(this, actionType.toLowerCase());

    topic.addPermissionToPublish(this, "s3.amazonaws.com", this.bucket.arn);

    this.notificationTopics.push({
      id: `on-${actionType.toLowerCase()}-notification`,
      events: EVENTS[actionType],
      topicArn: topic.topicArn,
    });

    this.notificationDependencies.push(topic.permissions);

    this.node.addDependency(topic);

    Node.of(this).addConnection({
      source: this,
      target: topic,
      name: `${actionType}()`,
    });

    return topic;
  }
};
