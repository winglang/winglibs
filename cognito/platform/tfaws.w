bring cloud;
bring aws as awsUtils;
bring "@cdktf/provider-aws" as aws;
bring "../types.w" as types;

pub class Cognito impl types.ICognito {
  api: cloud.Api;
  name: str;
  pub clientId: str;
  pub userPoolId: str;

  new(api: cloud.Api, props: types.CognitoProps?) {
    this.api = api;
    this.name = props?.name ?? "cognito-{this.node.id}";

    let userPool = new aws.cognitoUserPool.CognitoUserPool(
      name: "{this.name}-user-pool",
      usernameAttributes: props?.usernameAttributes ?? ["email"],
      autoVerifiedAttributes: props?.autoVerifiedAttributes ?? ["email"],
      schema: props?.schema ?? [
        {
          name: "email",
          attributeDataType: "String",
          required: true,
        },
      ],
    );

    let client = new aws.cognitoUserPoolClient.CognitoUserPoolClient(
      name: "{this.name}-user-pool-client",
      userPoolId: userPool.id,
      explicitAuthFlows: ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"],
    );

    let apiSpec: MutJson = unsafeCast(this.api)?.apiSpec;
    let cognitoDefinition = {
      type: "apiKey",
      name: props?.headerKey ?? "Authorization",
      in: "header",
      "x-amazon-apigateway-authtype": "cognito_user_pools",
      "x-amazon-apigateway-authorizer": {
        "type": "cognito_user_pools",
        "providerARNs": [
          "{userPool.arn}"
        ]
      }
    };

    let securityScheme = MutJson{};
    securityScheme.set(this.name, cognitoDefinition);
    apiSpec.set("components", {
      "securitySchemes": Json.deepCopy(securityScheme),
    });

    this.clientId = client.id;
    this.userPoolId = userPool.id;
  }

  pub get(path: str) {
    this.addSecurity(path, "get");
  }

  pub post(path: str) {
    this.addSecurity(path, "post");
  }

  pub put(path: str) {
    this.addSecurity(path, "put");
  }

  pub patch(path: str) {
    this.addSecurity(path, "patch");
  }

  pub delete(path: str) {
    this.addSecurity(path, "delete");
  }

  pub head(path: str) {
    this.addSecurity(path, "head");
  }

  pub options(path: str) {
    this.addSecurity(path, "options");
  }

  pub connect(path: str) {
    this.addSecurity(path, "connect");
  }

  addSecurity(path: str, method: str) {
    let apiSpec: MutJson = unsafeCast(this.api)?.apiSpec;
    let paths = apiSpec.get("paths");
    if !paths.tryGet(path)? {
      throw "Path {path} not found. `cloud.Api.{method}({path}) must be called before.`";
    }
    let methods = paths.get(path);
    if !methods.tryGet(method)? {
      throw "Method {method} not found. `cloud.Api.{method}({path}) must be called before.`";
    }
    let spec = methods.get(method);
    let security = MutJson{};
    security.set(this.name, []);
    spec.set("security", [security]);
  }

  pub inflight signUp(email: str, password: str): void {
    Cognito._signUp(this.clientId, email, password);
  }

  pub inflight adminConfirmUser(email: str): void {
    Cognito._adminConfirmUser(this.userPoolId, email);
  }

  pub inflight initiateAuth(email: str, password: str): str {
    return Cognito._initiateAuth(this.clientId, email, password);
  }

  pub onLift(host: std.IInflightHost, ops: Array<str>) {
    if let awsFunc = awsUtils.Function.from(host) {
      if ops.contains("adminConfirmUser") {
        awsFunc.addPolicyStatements({
          effect: awsUtils.Effect.ALLOW,
          actions: ["cognito-idp:AdminConfirmSignUp"],
          resources: [
            "arn:aws:cognito-idp:*:*:userpool/{this.userPoolId}"
          ]
        });
      }
    }
  }

  extern "./aws-utils.ts" static pub inflight _signUp(clientId: str, email: str, password: str): void;
  extern "./aws-utils.ts" static pub inflight _adminConfirmUser(poolId: str, email: str): void;
  extern "./aws-utils.ts" static pub inflight _initiateAuth(clientId: str, email: str, password: str): str;
}
