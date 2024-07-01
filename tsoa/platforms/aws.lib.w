bring cloud;
bring aws;
bring ui;
bring util;
bring fs;
bring "@cdktf/provider-aws" as awsProvider;
bring "../types" as types;
bring "../builder" as builder;

pub class AWSService {
  pub function: cloud.Function;
  pub url: str;

  new(handler: inflight (Json): Json) {
    this.function = new cloud.Function(inflight (req) => {
      return unsafeCast(handler(unsafeCast(req)));
    });
    
    let awsFn: aws.IAwsFunction = unsafeCast(this.function);
    let handlerInvokeArn: str = unsafeCast(awsFn)?.invokeArn;

    let api = new awsProvider.apiGatewayRestApi.ApiGatewayRestApi(
      name: "wing-tsoa-api-{nodeof(this).addr.substring(42-8)}",
      endpointConfiguration: {
        types: ["EDGE"]
      }
    );

    let proxy = new awsProvider.apiGatewayResource.ApiGatewayResource(
      restApiId: api.id,
      parentId: api.rootResourceId,
      pathPart: #"{proxy+}"
    ) as "proxy resource";

    let proxyMethod = new awsProvider.apiGatewayMethod.ApiGatewayMethod(
      restApiId: api.id,
      resourceId: proxy.id,
      authorization: "NONE",
      httpMethod: "ANY"
    ) as "proxy method";

    let proxyIntegration = new awsProvider.apiGatewayIntegration.ApiGatewayIntegration(
      httpMethod: proxyMethod.httpMethod,
      resourceId: proxy.id,
      restApiId: api.id,
      type: "AWS_PROXY",
      integrationHttpMethod: "POST",
      uri: handlerInvokeArn,
    ) as "proxy integration";

    let rootMethod = new awsProvider.apiGatewayMethod.ApiGatewayMethod(
      restApiId: api.id,
      resourceId: api.rootResourceId,
      authorization: "NONE",
      httpMethod: "ANY"
    ) as "root method";

    let rootIntegration = new awsProvider.apiGatewayIntegration.ApiGatewayIntegration(
      httpMethod: rootMethod.httpMethod,
      resourceId: rootMethod.resourceId,
      restApiId: api.id,
      type: "AWS_PROXY",
      integrationHttpMethod: "POST",
      uri: handlerInvokeArn
    ) as "root integration";

    let deploy = new awsProvider.apiGatewayDeployment.ApiGatewayDeployment(
      restApiId: api.id,
      dependsOn: [proxyIntegration, rootIntegration],
      stageName: "prod",
    );

    new awsProvider.lambdaPermission.LambdaPermission(
      action: "lambda:InvokeFunction",
      functionName: awsFn?.functionName!,
      principal: "apigateway.amazonaws.com",
      sourceArn: "{api.executionArn}/*/*"
    );

    this.url = deploy.invokeUrl;
  }
}
