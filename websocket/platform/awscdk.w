bring cloud;
bring aws;
bring "../commons/api.w" as api;
bring "aws-cdk-lib" as awscdk;

pub class WebSocket_awscdk impl api.IWebSocket {
  api: awscdk.aws_apigatewayv2.CfnApi;
  role: awscdk.aws_iam.Role;
  deployment: awscdk.aws_apigatewayv2.CfnDeployment;
  region: str?;
  callbackUrl: str;
  pub url: str;

  new(props: api.WebSocketProps) {
    
    this.api = new awscdk.aws_apigatewayv2.CfnApi(
      name: props.name,
      protocolType: "WEBSOCKET",
      routeSelectionExpression: "$request.body.action",
    ) as "Default";
      
    this.role = new awscdk.aws_iam.Role(
      assumedBy: new awscdk.aws_iam.ServicePrincipal("apigateway.amazonaws.com")
    );

    let stageName = props.stageName ?? "prod";

    this.deployment = new awscdk.aws_apigatewayv2.CfnDeployment(apiId: this.api.attrApiId);

    let stage = new awscdk.aws_apigatewayv2.CfnStage(
      apiId: this.api.attrApiId,
      stageName: stageName,
      deploymentId: this.deployment.attrDeploymentId,
      autoDeploy: true
    );

    this.region = awscdk.Stack.of(this).region;
    let urlSuffix = awscdk.Stack.of(this).urlSuffix;

    this.url = "wss://{this.api.attrApiId}.execute-api.{this.region}.amazonaws/prod";
    this.callbackUrl = "https://{this.api.attrApiId}.execute-api.{this.region}.{urlSuffix}/{stageName}";

    new awscdk.CfnOutput(
      value: this.url,
      exportName: "url"
    ) as "url";

    new awscdk.CfnOutput(
      value: this.callbackUrl,
      exportName: "callbackUrl"
    ) as "callbackUrl";
  }

  pub onLift(host: std.IInflightHost, ops: Array<str>) {
    if let host = aws.Function.from(host) {
      if ops.contains("postToConnection") {
        host.addPolicyStatements(aws.PolicyStatement {
          effect: awscdk.aws_iam.Effect.ALLOW,
          actions: ["execute-api:ManageConnections", "execute-api:Invoke"],
          resources: ["*"],
        });
      }
    }
  }

  pub connect(handler: inflight(str):Json): void {
    this.addRoute(handler, {
      routeKey: "$connect",
    });
  }

  pub disconnect(handler: inflight(str):Json): void {
    this.addRoute(handler, {
      routeKey: "$disconnect",
    });
  }

  pub addRoute(handler: inflight(str): void, props: api.RouteOptions): void {
    let func = new cloud.Function(handler) as props.routeKey;
    if let lambda = aws.Function.from(func) {
      let functionArn = lambda.arn();
      
      this.role.addToPolicy(
        new awscdk.aws_iam.PolicyStatement(
          effect: awscdk.aws_iam.Effect.ALLOW,
          resources: [functionArn],
          actions: ["lambda:InvokeFunction"]
        )
      );

      let integrationUri = awscdk.Stack.of(this).formatArn({
        service: "apigateway",
        account: "lambda",
        resource: "path/2015-03-31/functions",
        resourceName: "{functionArn}/invocations",
      });
      
      let integration = new awscdk.aws_apigatewayv2.CfnIntegration(
        apiId: this.api.attrApiId,
        integrationType: "AWS_PROXY",
        integrationUri: integrationUri,
        credentialsArn: this.role.roleArn,
      ) as "{props.routeKey}Integration";

      let route = new awscdk.aws_apigatewayv2.CfnRoute(
        apiId: this.api.attrApiId,
        routeKey: props.routeKey,
        authorizationType: "NONE",
        target: "integrations/{integration.ref}",
      ) as "{props.routeKey}Route";

      this.deployment.addDependency(route);
    }
  }

  pub wssUrl(): str {
    return this.url;    
  }

  extern "../inflight/websocket.aws.js" static inflight _postToConnection(endpointUrl: str, connectionId: str, message: str): void;
  pub inflight postToConnection(connectionId: str, message: str) {
    WebSocket_awscdk._postToConnection(this.callbackUrl, connectionId, message);
  }
}
