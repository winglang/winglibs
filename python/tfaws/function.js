const { Construct } = require("constructs");
const { Function: TfAwsFunction } = require("@winglang/sdk/lib/target-tf-aws/function.js");
const { App } = require("@winglang/sdk/lib/target-tf-aws/app.js");
const { Testing } = require("@winglang/sdk/lib/simulator");
const { Function: AwsFunction } = require("@winglang/sdk/lib/shared-aws/function.js");
const { Bucket: AwsBucket } = require("@winglang/sdk/lib/shared-aws/bucket.js");
const { normalPath } = require("@winglang/sdk/lib/shared/misc.js");
const cdktf = require("cdktf");
const awsProvider = require("@cdktf/provider-aws");
const { build } = require("../util.js");

module.exports.Function = class Function extends Construct {
  constructor(
    scope,
    id,
    inflight,
    props,
  ) {
    super(scope, id);
    const dummy = new TfAwsFunction(this, "Dummy", Testing.makeHandler(`
      async handle(event) {
        return;
      }`
    ));
    const entrypointDir = App.of(this).entrypointDir;
    const workDir = App.of(this).workdir;
    const pathEnv = process.env["PATH"] || "";
    const homeEnv = process.env["HOME"] || "";
    
    const outdir = build({
      entrypointDir: entrypointDir,
      workDir: workDir,
      path: inflight.inner.props.path,
      homeEnv: homeEnv,
      pathEnv: pathEnv,
    });

    const asset = new cdktf.TerraformAsset(this, "Code", {
      path: outdir,
      type: cdktf.AssetType.ARCHIVE
    });

    const roleArn = dummy.role.arn;

    const clients = {};
    for (let clientId of Object.keys(inflight.inner.lifts)) {
      const { client, options } = inflight.inner.lifts[clientId];
      const allow = options.allow;
      const bucket = AwsBucket.from(client);
      if (bucket !== undefined) {
        bucket.onLift(dummy, allow);
        clients[clientId] = {
          type: "cloud.Bucket",
          bucketName: cdktf.Fn.replace(bucket.bucketName, ".s3.amazonaws.com", ""),
          target: "aws",
        };
      }
    }

    this.lambda = new awsProvider.lambdaFunction.LambdaFunction(this, "PyFunction", {
      functionName: `${id}-${this.node.addr.substring(42-8)}`,
      role: roleArn,
      handler: inflight.inner.props.handler,
      runtime: "python3.11",
      filename: asset.path,
      sourceCodeHash: asset.assetHash,
      timeout: 60,
      environment: {
        variables: {
          WING_TARGET: process.env["WING_TARGET"],
          WING_CLIENTS: cdktf.Fn.jsonencode(clients),
        }
      }
    });
    this.lambdaArn = this.lambda.arn;
  }

  onLift(host, ops) {
    host.addEnvironment(this.envName(), this.lambdaArn);

    const lambda = AwsFunction.from(host);
    if (lambda !== undefined) {
      if (ops.includes("invoke") || ops.includes("invokeAsync")) {
        lambda.addPolicyStatements({
          actions: ["lambda:InvokeFunction"],
          effect: "Allow",
          resources: [
            this.lambdaArn,
          ]
        });
      }
    }
  }

  _toInflight() {
    const args = [`process.env["${this.envName()}"], "${this.node.path}"`];

    return `new (require("${normalPath(
      `${__dirname}/function.inflight.js`
    )}")).FunctionClient(${args.join(", ")})`;
  }

  envName() {
    return `FUNCTION_NAME_${this.node.addr.slice(-8)}`;
  }
}