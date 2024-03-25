const cdk = require("aws-cdk-lib");

module.exports.addRulePermission = (handler, arn) => {
  const func = handler.function;
  func.addPermission("AllowExecutionFromEventBridge", {
    principal: new cdk.aws_iam.ServicePrincipal("events.amazonaws.com"),
    sourceArn: arn,
    action: "lambda:InvokeFunction",
  });
};
