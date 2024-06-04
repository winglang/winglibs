const { Construct } = require("constructs");
const { Function: TfAwsFunction } = require("@winglang/sdk/lib/target-tf-aws/function.js");
const { App } = require("@winglang/sdk/lib/target-tf-aws/app.js");
const { inflight: createInflight } = require("@winglang/sdk/lib/core");
const { Function: AwsFunction } = require("@winglang/sdk/lib/shared-aws/function.js");
const { Bucket: AwsBucket } = require("@winglang/sdk/lib/shared-aws/bucket.js");
const { normalPath } = require("@winglang/sdk/lib/shared/misc.js");
const { Duration } = require("@winglang/sdk/lib/std/duration.js");
const { ResourceNames } = require("@winglang/sdk/lib/shared/resource-names");
const { DEFAULT_MEMORY_SIZE } = require("@winglang/sdk/lib/shared/function");
const cdktf = require("cdktf");
const awsProvider = require("@cdktf/provider-aws");
const { build } = require("../util.js");

const FUNCTION_NAME_OPTS = {
  maxLen: 64,
  disallowedRegex: /[^a-zA-Z0-9\_\-]+/g,
};

module.exports.Function = class Function extends Construct {
  constructor(
    scope,
    id,
    inflight,
    props = {},
  ) {
    super(scope, id);
    
    this.dummy = new TfAwsFunction(this, "Dummy", createInflight(async (ctx) => {}));
    const pathEnv = process.env["PATH"] || "";
    const homeEnv = process.env["HOME"] || "";
    
    const outdir = build({
      path: inflight.inner.props.path,
      handler: inflight.inner.props.handler,
      homeEnv: homeEnv,
      pathEnv: pathEnv,
    });

    const asset = new cdktf.TerraformAsset(this, "Code", {
      path: outdir,
      type: cdktf.AssetType.ARCHIVE
    });
    const bucket = App.of(this).codeBucket;
    const objectKey = `asset.${this.node.addr}.${asset.assetHash}.zip`;

    // Upload Lambda zip file to newly created S3 bucket
    const lambdaArchive = new awsProvider.s3Object.S3Object(this, "S3Object", {
      bucket: bucket.bucket,
      key: objectKey,
      source: asset.path,
    });

    const roleArn = this.dummy.role.arn;
    const roleName = this.dummy.role.name;

    const clients = {};
    for (let clientId of Object.keys(inflight.inner.lifts)) {
      const { client, options } = inflight.inner.lifts[clientId];
      const allow = options.allow;

      // SDK resources
      const bucket = AwsBucket.from(client);
      if (bucket !== undefined) {
        bucket.onLift(this.dummy, allow);
        clients[clientId] = {
          type: "cloud.Bucket",
          bucketName: cdktf.Fn.replace(bucket.bucketName, ".s3.amazonaws.com", ""),
          target: "aws",
        };
      }

      // Custom resources
      if (typeof client.tableName === "string" &&
          typeof client.connection === "object" ) {
        clients[clientId] = {
          type: "@winglibs.dyanmodb.Table",
          target: "aws",
          props: { connection: client.connection },
        }
      } else if (client.constructor?.name === "MobileClient") {
        clients[clientId] = {
          type: "@winglibs.sns.MobileClient",
          target: "aws",
          props: {},
        }
      } else if (client.constructor?.name === "EmailService") {
        clients[clientId] = {
          type: "@winglibs.ses.EmailService",
          target: "aws",
          props: {},
        }
      }
    }

    this.env = {
      WING_TARGET: process.env["WING_TARGET"],
      WING_CLIENTS: cdktf.Fn.jsonencode(clients),
    };

    this.name = ResourceNames.generateName(this, FUNCTION_NAME_OPTS);
    this.functionName = this.name;

    // Add execution role for lambda to write to CloudWatch logs
    new awsProvider.iamRolePolicyAttachment.IamRolePolicyAttachment(this, "IamRolePolicyAttachment", {
      policyArn:
        "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
      role: roleName,
    });

    if (!props.logRetentionDays || props.logRetentionDays >= 0) {
      new awsProvider.cloudwatchLogGroup.CloudwatchLogGroup(this, "CloudwatchLogGroup", {
        name: `/aws/lambda/${this.name}`,
        retentionInDays: props.logRetentionDays ?? 30,
      });
    } else {
      // Negative value means Infinite retention
    }

    this.lambda = new awsProvider.lambdaFunction.LambdaFunction(this, "PyFunction", {
      functionName: this.name,
      role: roleArn,
      handler: inflight.inner.props.handler,
      runtime: "python3.11",
      s3Bucket: bucket.bucket,
      s3Key: lambdaArchive.key,
      timeout: props.timeout
        ? props.timeout.seconds
        : Duration.fromMinutes(1).seconds,
      memorySize: props.memory ?? DEFAULT_MEMORY_SIZE,
      environment: {
        variables: cdktf.Lazy.anyValue({
          produce: () => ({
            ...props.env,
            ...this.env,
          }),
        }),
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

  addEnvironment(key, value) {
    this.env[key] = value;
  }
}