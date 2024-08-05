bring "./api.w" as b;
bring aws;

internal class Model_tfaws impl b.IModel {
  pub modelId: str;

  new(modelId: str) {
    this.modelId = modelId;
  }

  pub inflight invoke(body: Json): Json {
    return Model_tfaws._invokeModel({ modelId: this.modelId, body: body });
  }

  pub onLift(host: std.IInflightHost, ops: Array<str>) {
    if let lambda = aws.Function.from(host) {
      lambda.addPolicyStatements({
        actions: ["bedrock:InvokeModel"],
        effect: aws.Effect.ALLOW,
        resources: [
          "arn:aws:bedrock:*::foundation-model/{this.modelId}"
        ]
      });
    }
  }

  extern "./bedrock.js"
  static inflight _invokeModel(req: Json): Json; 
}
