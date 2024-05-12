const { Function: SimFunction } = require("./sim/function.js");
const { Function: TfAwsFunction } = require("./tfaws/function.js");
const { Queue: TfAwsQueue } = require("./tfaws/queue.js");
const { Topic: TfAwsTopic } = require("./tfaws/topic.js");
const { Bucket: TfAwsBucket } = require("./tfaws/bucket.js");
const { Api: TfAwsApi } = require("./tfaws/api.js");

const FUNCTION_FQN = "@winglang/sdk.cloud.Function";
const QUEUE_FQN = "@winglang/sdk.cloud.Queue";
const TOPIC_FQN = "@winglang/sdk.cloud.Topic";
const BUCKET_FQN = "@winglang/sdk.cloud.Bucket";
const API_FQN = "@winglang/sdk.cloud.Api";

const createFunction = (target, scope, id, inflight, props) => {
  if (inflight._inflightType === "_inflightPython") {
    if (target === "tf-aws") {
      return new TfAwsFunction(scope, id, inflight, props);
    } else if (target === "sim") {
      return new SimFunction(scope, id, inflight, props);
    }
  }
};

module.exports.Platform = class Platform {
  newInstance(type, scope, id, ...props) {
    const target = process.env["WING_TARGET"];
    if (type === FUNCTION_FQN) {
      return createFunction(target, scope, id, ...props);
    } else if (type === QUEUE_FQN) {
      if (target === "tf-aws") {
        return new TfAwsQueue(scope, id, ...props);
      }
    } else if (type === TOPIC_FQN) {
      if (target === "tf-aws") {
        return new TfAwsTopic(scope, id, ...props);
      }
    } else if (type === BUCKET_FQN) {
      if (target === "tf-aws") {
        return new TfAwsBucket(scope, id, ...props);
      }
    } else if (type === API_FQN) {
      if (target === "tf-aws") {
        return new TfAwsApi(scope, id, ...props);
      }
    }
  }
};
