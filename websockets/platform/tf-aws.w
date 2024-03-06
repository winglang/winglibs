bring aws;
bring cloud;
bring "../commons/api.w" as commons;
bring "cdktf" as cdktf;
bring "@cdktf/provider-aws" as tfaws;
bring "./aws/api.w" as awsapi;

pub class WebSocket_tfaws impl awsapi.IAwsWebSocket {
  webSocketApi: tfaws.apigatewayv2Api.Apigatewayv2Api;
  role: tfaws.iamRole.IamRole;
  pub url: str;

  new(props: commons.WebSocketProps) {

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
      if ops.contains("sendMessage") {
        host.addPolicyStatements(aws.PolicyStatement {
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
    }), env: {
      "url": this.url,
    }) as "on connect";

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
    }), env: {
      "url": this.url,
    }) as "on disconnect";

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
    }), env: {
      "url": this.url,
    }) as "on message";

    this.addRoute(onMessageFunction, routeKey);
  }

  pub addRoute(handler: cloud.Function, routeKey: str): void {
    if let func = aws.Function.from(handler) {
      let functionArn = func.functionArn;
        
      let iamPolicy = new tfaws.iamPolicy.IamPolicy(
        policy: cdktf.Fn.jsonencode({
          Version: "2012-10-17",
          Statement: [{
            Action: ["lambda:InvokeFunction"],
            Effect: "Allow",
            Resource: Json.stringify(functionArn)
          }]
        })
      ) as "{routeKey}Policy";
  
      new tfaws.iamRolePolicyAttachment.IamRolePolicyAttachment(
        role: this.role.name,
        policyArn: iamPolicy.arn,
      ) as "{routeKey}PolicyAttachment";
  
      let integration = new tfaws.apigatewayv2Integration.Apigatewayv2Integration(
        apiId: cdktf.Token.asString(this.webSocketApi.id),
        integrationType: "AWS_PROXY",
        integrationUri: functionArn,
        credentialsArn: this.role.arn,
      ) as "{routeKey}Integration";
  
      let route = new tfaws.apigatewayv2Route.Apigatewayv2Route(
        apiId: this.webSocketApi.id,
        routeKey: routeKey,
        authorizationType: "NONE",
        target: "integrations/{integration.id}",
      ) as "{routeKey}Route";
    }
  }

  extern "../inflight/websocket.aws.js" static inflight _postToConnection(endpointUrl: str, connectionId: str, message: str): void;
  pub inflight sendMessage(connectionId: str, message: str): void {
    // TODO: str.replace does not work when applied to the class property `this.url`, so we need to use a local var for now.
    let var url = this.url;
    url = url.replace("wss://", "https://");
    WebSocket_tfaws._postToConnection(url, connectionId, message);
  }
}
