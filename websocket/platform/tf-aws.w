bring aws;
bring cloud;
bring "../commons/api.w" as api;
bring "cdktf" as cdktf;
bring "@cdktf/provider-aws" as tfaws;

pub class WebSocket_tfaws impl api.IWebSocket {
  webSocketApi: tfaws.apigatewayv2Api.Apigatewayv2Api;
  role: tfaws.iamRole.IamRole;
  pub url: str;

  new(props: api.WebSocketProps) {

    this.webSocketApi = new tfaws.apigatewayv2Api.Apigatewayv2Api(
      name: props.name,
      protocolType: "WEBSOCKET",
      routeSelectionExpression: "$request.body.action",
    );

    this.role = new tfaws.iamRole.IamRole(
      assumeRolePolicy: Json.stringify({
        Version: "2012-10-17",
        Statement: {
          Action: "sts:AssumeRole",
          Effect: "Allow",
          Sid: "",
          Principal: {
            Service: "apigateway.amazonaws.com"
          }
        },
      }),
    );

    let stageName = props.stageName ?? "prod";

    let stage = new tfaws.apigatewayv2Stage.Apigatewayv2Stage(
      apiId: cdktf.Token.asString(this.webSocketApi.id),
      name: stageName,
      autoDeploy: true,
    );

    this.url = stage.invokeUrl;
  }

  pub onLift(host: std.IInflightHost, ops: Array<str>) {
    if let host = aws.Function.from(host) {
      if ops.contains("postToConnection") {
        host.addPolicyStatements(aws.PolicyStatement {
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
  pub addRoute(handler: inflight(str): Json, props: api.RouteOptions): void {
    let func = new cloud.Function(handler) as props.routeKey.replace("$", "");
    if let func = aws.Function.from(func) {
      let functionArn = func.arn();
        
      let iamPolicy = new tfaws.iamPolicy.IamPolicy(
        policy: cdktf.Fn.jsonencode({
          Version: "2012-10-17",
          Statement: [{
            Action: ["lambda:InvokeFunction"],
            Effect: "Allow",
            Resource: Json.stringify(functionArn)
          }]
        })
      ) as "{props.routeKey}Policy";
  
      new tfaws.iamRolePolicyAttachment.IamRolePolicyAttachment(
        role: this.role.name,
        policyArn: iamPolicy.arn,
      ) as "{props.routeKey}PolicyAttachment";
  
      let integration = new tfaws.apigatewayv2Integration.Apigatewayv2Integration(
        apiId: cdktf.Token.asString(this.webSocketApi.id),
        integrationType: "AWS_PROXY",
        integrationUri: functionArn,
        credentialsArn: this.role.arn,
      ) as "{props.routeKey}Integration";
  
      let route = new tfaws.apigatewayv2Route.Apigatewayv2Route(
        apiId: this.webSocketApi.id,
        routeKey: props.routeKey,
        authorizationType: "NONE",
        target: "integrations/{integration.id}",
      ) as "{props.routeKey}Route";
    }
  }

  extern "../inflight/websocket.aws.js" static inflight _postToConnection(endpointUrl: str, connectionId: str, message: str): void;
  pub inflight postToConnection(connectionId: str, message: str) {
    let url = this.url;
    WebSocket_tfaws._postToConnection(url.replace("wss://", "https://"), connectionId, message);
  }
}

