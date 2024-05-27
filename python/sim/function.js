const { App } = require("@winglang/sdk/lib/core/app.js");

module.exports.handleSimInflight = (inflight, props) => {
  for (let e in props.env) {
    inflight.inner.service.addEnvironment(e, props.env[e]);
  }

  if (!App.of(inflight).isTestEnvironment) {
    for (let key of ["AWS_REGION", "AWS_DEFAULT_REGION", "AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY"]) {
      let value = process.env[key];
      if (value) {
        inflight.inner.service.addEnvironment(key, value);
      }
    }
  }
}
