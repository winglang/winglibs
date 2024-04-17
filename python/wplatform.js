const { Function: TfAwsFunction } = require("./tfaws/function.js");
const { Queue: TfAwsQueue } = require("./tfaws/queue.js");
const { Topic: TfAwsTopic } = require("./tfaws/topic.js");
const { Bucket: TfAwsBucket } = require("./tfaws/bucket.js");

const FUNCTION_FQN = "@winglang/sdk.cloud.Function";
const QUEUE_FQN = "@winglang/sdk.cloud.Queue";
const TOPIC_FQN = "@winglang/sdk.cloud.Topic";
const BUCKET_FQN = "@winglang/sdk.cloud.Bucket";

module.exports.Platform = class Platform {
  newInstance(type, scope, id, props) {
    const target = process.env["WING_TARGET"];
    if (type === FUNCTION_FQN) {
      if (props._inflightType === "_inflightPython") {
        if (target === "tf-aws") {
          return new TfAwsFunction(scope, id, props);
        }
      }
    } else if (type === QUEUE_FQN) {
      if (target === "tf-aws") {
        return new TfAwsQueue(scope, id, props);
      }
    } else if (type === TOPIC_FQN) {
      if (target === "tf-aws") {
        return new TfAwsTopic(scope, id, props);
      }
    } else if (type === BUCKET_FQN) {
      if (target === "tf-aws") {
        return new TfAwsBucket(scope, id, props);
      }
    }
  }
};
