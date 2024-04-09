bring cloud;
bring util;
bring aws;
bring "cdktf" as cdktf;
bring "@cdktf/provider-aws" as awsProvider;
bring "../types.w" as types;
bring "../util.w" as libutil;

pub class Function impl types.IFunction {
  pub url: str;
  dummy: cloud.Function;
  lambda: awsProvider.lambdaFunction.LambdaFunction;
  lambdaArn: str;
  clients: MutMap<Json>;
  
  new(props: types.FunctionProps) {
    let entrypointDir = nodeof(this).app.entrypointDir;
    let workDir = nodeof(this).app.workdir;
    let homeEnv = util.tryEnv("HOME") ?? "";
    let pathEnv = util.tryEnv("PATH") ?? "";

    let outdir = libutil.build(
      entrypointDir: entrypointDir,
      workDir: workDir,
      path: props.path,
      homeEnv: homeEnv,
      pathEnv: pathEnv,
    );

    this.dummy = new cloud.Function(inflight () => {});
    let asset = new cdktf.TerraformAsset(path: outdir, type: cdktf.AssetType.ARCHIVE);
    let roleArn: str = unsafeCast(this.dummy)?.role?.arn;

    this.lambda = new awsProvider.lambdaFunction.LambdaFunction(
      functionName: "{this.node.id}-{this.node.addr.substring(42-8)}",
      role: roleArn,
      handler: props.handler,
      runtime: "python3.11",
      filename: asset.path,
      sourceCodeHash: asset.assetHash,
    );

    let url = new awsProvider.lambdaFunctionUrl.LambdaFunctionUrl(
      functionName: this.lambda.functionName,
      authorizationType: "NONE",
    );

    this.url = url.functionUrl;
    this.lambdaArn = this.lambda.arn;
    this.clients = MutMap<Json>{};
  }

  pub liftClient(id: str, client: std.Resource, ops: Array<str>) {
    client.onLift(this.dummy, ops);

    if let bucket = aws.Bucket.from(unsafeCast(client)) {
      this.clients.set(id, {
        type: "cloud.Bucket",
        bucketName: cdktf.Fn.replace(bucket.bucketName, ".s3.amazonaws.com", ""),
        target: "aws",
      });
    }
  }

  pub inflight invoke(payload: str?): str? {
    return Function._invoke(this.lambdaArn, payload);
  }

  pub onLift(host: std.IInflightHost, ops: Array<str>) {
    if let lambda = aws.Function.from(host) {
      if ops.contains("invoke") {
        lambda.addPolicyStatements({
          actions: ["lambda:InvokeFunction"],
          effect: aws.Effect.ALLOW,
          resources: [
            this.lambdaArn,
          ]
        });
      }
    }
  }

  _preSynthesize(): void {
    this.lambda.environment.variables = {
      "WING_TARGET" => util.env("WING_TARGET"),
      "WING_CLIENTS" => cdktf.Fn.jsonencode(this.clients),
    };
  }

  extern "./function.js" inflight static _invoke(functionArn: str, payload: str?): str?;
}
