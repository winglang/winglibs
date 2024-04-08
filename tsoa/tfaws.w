bring cloud;
bring aws;
bring ui;
bring util;
bring fs;
bring "@cdktf/provider-aws" as awsProvider;
bring "./types.w" as types;

class IFunction impl std.IInflightHost  {
  pub var _getCodeLines: (cloud.IFunctionHandler): Array<str>;
  pub var addEnvironment: (str, str): void;

  new() {
    this._getCodeLines = (handler) => {return Array<str>[];};
    this.addEnvironment = (name, key) => {};
  }
}

class TSOAFunction extends cloud.Function {
  _env: MutMap<str>;
  pub fn: IFunction;
  requires: Map<str>;

  new(requires: Map<str>, handler: inflight (Json?, Json?, Map<std.Resource>?): Json?) {
    this.requires = requires;
    this._env = MutMap<str>{};
    this.fn = unsafeCast(new cloud.Function(unsafeCast(handler)));
    this.fn._getCodeLines = unsafeCast(this._getCodeLines)?.bind(this);
    this.fn.addEnvironment = this.addEnvironment;
  }

  pub addEnvironment(name: str, value: str) {
    this._env.set(name, value);
  }

  protected _getCodeLines(handler: cloud.IFunctionHandler): Array<str> {
    let inflightClient = unsafeCast(handler)?._toInflight();
    let lines = MutArray<str>[];
    let client = "$handler";

    lines.push("\"use strict\";");
    for req in this.requires.entries() {
      lines.push("var {req.key} = require(\"{req.value}\");");
      lines.push("global[\"{req.key}\"] = {req.key};");
    }
    lines.push("var {client} = undefined;");
    lines.push("exports.handler = async function(event, context) \{");
    lines.push("  {client} = {client} ?? ({inflightClient});");
    lines.push("  return await {client}.handle(event, context);");
    lines.push("};");

    return lines.copy();
  }
}
/**
 * Starts a new TSOA service.
 */
pub class Service_tfaws impl types.IService {
  func: TSOAFunction;
  api: awsProvider.apiGatewayRestApi.ApiGatewayRestApi;
  pub url: str;
  clients: MutMap<std.Resource>;

  new(props: types.ServiceProps) {
    let currentdir = Service_tfaws.dirname();
    let entrypointDir = nodeof(this).app.entrypointDir;
    let workDir = nodeof(this).app.workdir;
    let homeEnv = util.tryEnv("HOME") ?? "";
    let pathEnv = util.tryEnv("PATH") ?? "";

    this.clients = MutMap<std.Resource>{};
    let res = Service_tfaws.build(
      currentdir: currentdir,
      basedir: entrypointDir,
      workdir: workDir,
      options: props,
      homeEnv: homeEnv,
      pathEnv: pathEnv,
      clients: this.clients.copy(),
    );
    
    this.func = new TSOAFunction({ RegisterRoutes: res }, inflight (event, context) => {
      return Service_tfaws.runHandler(event, context, this.clients.copy());
    });

    let awsFn = aws.Function.from(this.func.fn)!;
    let handlerInvokeArn: str = unsafeCast(awsFn)?.invokeArn;

    this.api = new awsProvider.apiGatewayRestApi.ApiGatewayRestApi(
      name: "wing-tsoa-api-{this.node.addr.substring(42-8)}",
      endpointConfiguration: {
        types: ["EDGE"]
      }
    );

    let proxy = new awsProvider.apiGatewayResource.ApiGatewayResource(
      restApiId: this.api.id,
      parentId: this.api.rootResourceId,
      pathPart: "\{proxy+}"
    ) as "proxy resource";

    let proxyMethod = new awsProvider.apiGatewayMethod.ApiGatewayMethod(
      restApiId: this.api.id,
      resourceId: proxy.id,
      authorization: "NONE",
      httpMethod: "ANY"
    ) as "proxy method";

    let proxyIntegration = new awsProvider.apiGatewayIntegration.ApiGatewayIntegration(
      httpMethod: proxyMethod.httpMethod,
      resourceId: proxy.id,
      restApiId: this.api.id,
      type: "AWS_PROXY",
      integrationHttpMethod: "POST",
      uri: handlerInvokeArn,
    ) as "proxy integration";

    let rootMethod = new awsProvider.apiGatewayMethod.ApiGatewayMethod(
      restApiId: this.api.id,
      resourceId: this.api.rootResourceId,
      authorization: "NONE",
      httpMethod: "ANY"
    ) as "root method";

    let rootIntegration = new awsProvider.apiGatewayIntegration.ApiGatewayIntegration(
      httpMethod: rootMethod.httpMethod,
      resourceId: rootMethod.resourceId,
      restApiId: this.api.id,
      type: "AWS_PROXY",
      integrationHttpMethod: "POST",
      uri: handlerInvokeArn
    ) as "root integration";

    let deploy = new awsProvider.apiGatewayDeployment.ApiGatewayDeployment(
      restApiId: this.api.id,
      dependsOn: [proxyIntegration, rootIntegration],
      stageName: "prod",
    );

    new awsProvider.lambdaPermission.LambdaPermission(
      action: "lambda:InvokeFunction",
      functionName: awsFn.functionName,
      principal: "apigateway.amazonaws.com",
      sourceArn: "{this.api.executionArn}/*/*"
    );

    this.url = deploy.invokeUrl;
  }

  pub liftClient(id: str, client: std.Resource, ops: Array<str>) {
    client.onLift(this.func.fn, ops);
    this.clients.set(id, client);
  }

  extern "./lib.js" static build(options: types.StartServiceOptions): str;
  extern "./lib.js" static dirname(): str;
  extern "./app-aws.js" inflight static runHandler(event: Json, context: Json, clients: Map<std.Resource>): Json;
}
