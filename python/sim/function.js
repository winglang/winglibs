const { App } = require("@winglang/sdk/lib/core");
const { Function: SimFunction } = require("@winglang/sdk/lib/target-sim/function.js");

module.exports.Function = class Function extends SimFunction {
  constructor(
    scope,
    id,
    inflight,
    props = {},
    pythonInflight,
  ) {
    super(scope, id, inflight, props);

    this.pythonInflight = pythonInflight;

    if (!App.of(this).isTestEnvironment) {
      for (let key of ["AWS_REGION", "AWS_DEFAULT_REGION", "AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY"]) {
        let value = process.env[key];
        if (value) {
          this.addEnvironment(key, value);
        }
      }
    }
  }

  _preSynthesize() {
    this.pythonInflight.inner.preLift(this);
    return super._preSynthesize();
  }
}
