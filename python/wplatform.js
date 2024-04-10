const { Function: TfAwsFunction } = require("./tfaws/function.js");

const FUNCTION_FQN = "@winglang/sdk.cloud.Function";

module.exports.Platform = class Platform {
  newInstance(type, scope, id, props) {
    const target = process.env["WING_TARGET"];
    if (type === FUNCTION_FQN) {
      if (props._inflightType === "_inflightPython") {
        if (target === "tf-aws") {
          return new TfAwsFunction(scope, id, props);
        }
      }
    }
  }
};
