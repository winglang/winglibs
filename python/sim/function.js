const { Function: SimFunction } = require("@winglang/sdk/lib/target-sim/function.js");

module.exports.handleSimInflight = (inflight, props) => {
  for (let e in props.env) {
    inflight.inner.service.addEnvironment(e, props.env[e]);
  }
}
