const { Api: TfAwsApi } = require("@winglang/sdk/lib/target-tf-aws/api.js");
const { App } = require("@winglang/sdk/lib/target-tf-aws/app.js");
const { Node } = require("@winglang/sdk/lib/std/node.js");
const awsProvider = require("@cdktf/provider-aws");
const { Function } = require("./function.js");

module.exports.Api = class Api extends TfAwsApi {
  constructor(
    scope,
    id,
    props,
  ) {
    super(scope, id, props);
  }

  addHandler(inflight, method, path) {
    if (inflight._inflightType !== "_inflightPython") {
      return super.addHandler(inflight, method, path);
    }

    let handler = this.handlers[inflight._id];
    if (!handler) {
      handler = new Function(
        this,
        App.of(this).makeId(this, `${this.node.id}-OnMessage`),
        inflight,
        {},
      );
      Node.of(handler).hidden = true;
      this.handlers[inflight._id] = handler;
    }

    return handler;
  }
};
