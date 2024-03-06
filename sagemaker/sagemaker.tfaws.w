bring "./types.w" as types;
bring aws;

pub class SageMaker_tfaws impl types.ISageMaker {
  pub endpointName: str;
  pub inferenceComponentName: str;

  new(endpointName: str, inferenceComponentName: str) {
    this.endpointName = endpointName;
    this.inferenceComponentName = inferenceComponentName;
  }

  pub inflight invoke(body: Json, options: types.InvocationOptions?): types.InvocationOutput{
    return SageMaker_tfaws._invoke(this.endpointName, body, this.inferenceComponentName, options);
  }

  pub onLift(host: std.IInflightHost, ops: Array<str>) {
    if let lambda = aws.Function.from(host) {
      lambda.addPolicyStatements({
        actions: ["sagemaker:InvokeEndpoint"],
        effect: aws.Effect.ALLOW,
        resources: [
          "arn:aws:sagemaker:*:*:endpoint/{this.endpointName.lowercase()}",
          "arn:aws:sagemaker:*:*:inference-component/{this.inferenceComponentName.lowercase()}"
        ]
      });
    } 
  }

  extern "./sagemaker.js"
  static inflight _invoke(endpointName: str, body: Json, inferenceComponentName: str, options: types.InvocationOptions?): types.InvocationOutput; 
}
