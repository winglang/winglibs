const { Api: TfAwsApi } = require("@winglang/sdk/lib/target-tf-aws/api.js");
const { App } = require("@winglang/sdk/lib/target-tf-aws/app.js");
const { Node } = require("@winglang/sdk/lib/std/node.js");
const { Function } = require("./function.js");
const { tryGetPythonInflight } = require("../inflight.js");

module.exports.Api = class Api extends TfAwsApi {
  addHandler(inflight, method, path, props) {
    const pythonInflight = tryGetPythonInflight(inflight);
    if (!pythonInflight) {
      return super.addHandler(inflight, method, path);
    }

    let handler = this.handlers[inflight._id];
    if (!handler) {
      handler = new Function(
        this,
        App.of(this).makeId(this, `${this.node.id}-OnMessage`),
        inflight,
        props,
        pythonInflight,
      );
      Node.of(handler).hidden = true;
      this.handlers[inflight._id] = handler;
    }

    return handler;
  }
};
