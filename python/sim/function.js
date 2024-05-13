const { Function: SimFunction } = require("@winglang/sdk/lib/target-sim/function.js");

module.exports.Function = class Function extends SimFunction {
  constructor(
    scope,
    id,
    inflight,
    props = {},
  ) {
    super(scope, id, inflight, props);
    for (let e in props.env) {
      inflight.inner.service.addEnvironment(e, props.env[e]);
    }
  }
};
