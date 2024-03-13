bring cloud;
bring aws;
bring "../commons/api.w" as commons;
bring "./aws/api.w" as awsapi;
bring "aws-cdk-lib" as awscdk;

pub class WebSocket_awscdk impl awsapi.IAwsWebSocket {
  api: awscdk.aws_apigatewayv2.CfnApi;
  role: awscdk.aws_iam.Role;
  deployment: awscdk.aws_apigatewayv2.CfnDeployment;
  region: str?;
  pub url: str;

  new(props: commons.WebSocketProps) {
    
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

    this.url = this.api.attrApiEndpoint;

    new awscdk.CfnOutput(
      value: this.url,
      exportName: "url"
    ) as "url";

    new awscdk.CfnOutput(
      value: "https://{this.api.attrApiId}.execute-api.{this.region!}.{urlSuffix}/{stageName}",
      exportName: "callbackUrl"
    ) as "callbackUrl";
  }

  pub onLift(host: std.IInflightHost, ops: Array<str>) {
    if let host = aws.Function.from(host) {
      if ops.contains("sendMessage") {
        host.addPolicyStatements(aws.PolicyStatement {
          effect: awscdk.aws_iam.Effect.ALLOW,
          actions: ["execute-api:ManageConnections", "execute-api:Invoke"],
          resources: ["*"],
        });
      }
    }
  }

  pub onConnect(handler: inflight(str): void): void {
    let routeKey = "$connect";
    let onConnectFunction = new cloud.Function(unsafeCast(inflight (event: awsapi.WebSocketAwsRequest): awsapi.WebSocketAwsResponse => {
      if event.requestContext.routeKey == routeKey {
        handler(event.requestContext.connectionId);
      }

      return {
        statusCode: 200,
        body: "ack"
      };
    })) as "on connect";

    this.addRoute(onConnectFunction, routeKey);
  }
  pub onDisconnect(handler: inflight(str): void): void {
    let routeKey = "$disconnect";
    let onDisconnectFunction = new cloud.Function(unsafeCast(inflight (event: awsapi.WebSocketAwsRequest): awsapi.WebSocketAwsResponse => {
      if event.requestContext.routeKey == routeKey {
        handler(event.requestContext.connectionId);
      }

      return {
        statusCode: 200,
        body: "ack"
      };
    })) as "on disconnect";

    this.addRoute(onDisconnectFunction, routeKey);
  }
  pub onMessage(handler: inflight(str, str): void): void {
    let routeKey = "$default";
    let onMessageFunction = new cloud.Function(unsafeCast(inflight (event: awsapi.WebSocketAwsRequest): awsapi.WebSocketAwsResponse => {
      if event.requestContext.routeKey == routeKey {
        handler(event.requestContext.connectionId, event.body);
      }

      return {
        statusCode: 200,
        body: "ack"
      };
    })) as "on message";

    this.addRoute(onMessageFunction, routeKey);
  }

  pub addRoute(handler: cloud.Function, routeKey: str): void {
    if let lambda = aws.Function.from(handler) {
      let functionArn = lambda.functionArn;
      
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
      ) as "{routeKey}Integration";

      let route = new awscdk.aws_apigatewayv2.CfnRoute(
        apiId: this.api.attrApiId,
        routeKey: routeKey,
        authorizationType: "NONE",
        target: "integrations/{integration.ref}",
      ) as "{routeKey}Route";

      this.deployment.addDependency(route);
    }
  }

  extern "../inflight/websocket.aws.js" static inflight _postToConnection(endpointUrl: str, connectionId: str, message: str): void;
  pub inflight sendMessage(connectionId: str, message: str) {
    WebSocket_awscdk._postToConnection(this.url.replace("wss://", "https://"), connectionId, message);
  }
}
