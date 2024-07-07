bring cloud;
bring aws as awsUtils;
bring "@cdktf/provider-aws" as aws;
bring "cdktf" as cdktf;
bring "../types.w" as types;

pub class Cognito_tfaws impl types.ICognito {
  api: cloud.Api;
  name: str;
  pub clientId: str;
  pub userPoolId: str;
  pub identityPoolId: str;

  new(api: cloud.Api, props: types.CognitoProps?) {
    this.api = api;
    this.name = props?.name ?? nodeof(this).app.makeId(this, "cognito");

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

    let identityPool = new aws.cognitoIdentityPool.CognitoIdentityPool(
      identityPoolName: "{this.name}-identity-pool",
      allowUnauthenticatedIdentities: false,
      cognitoIdentityProviders: {
        client_id: client.id,
        provider_name: userPool.endpoint,
      },
    );

    let authenticatedPolicyDocument = new aws.dataAwsIamPolicyDocument.DataAwsIamPolicyDocument(
      statement: {
        principals: {
          type: "Federated",
          identifiers: ["cognito-identity.amazonaws.com"]
        },
        actions: ["sts:AssumeRoleWithWebIdentity"],
        effect: "Allow",
        condition: [{
          test: "StringEquals",
          variable: "cognito-identity.amazonaws.com:aud",
          values: [identityPool.id],
        }, {
          test: "ForAnyValue:StringLike",
          variable: "cognito-identity.amazonaws.com:amr",
          values: ["authenticated"],
        }],
      },
    ) as "authenticated policy document";

    let executionArn = unsafeCast(this.api)?.api?.api?.executionArn;
    let executionArnResource: str = cdktf.Fn.format("%s/*", [executionArn]);
    let authenticatedCognitoPolicyDocument = new aws.dataAwsIamPolicyDocument.DataAwsIamPolicyDocument(
      statement: [{
        actions: [
          "mobileanalytics:PutEvents",
          "cognito-sync:*",
          "cognito-identity:*",
        ],
        effect: "Allow",
        resources: ["*"],
      }, {
        actions: ["execute-api:Invoke"],
        effect: "Allow",
        resources: [executionArnResource],
      }],
    ) as "authenticated cognito policy document";

    let role = new aws.iamRole.IamRole(
      name: "{this.name}-identity-pool-role",
      assumeRolePolicy: authenticatedPolicyDocument.json,
    );

    new aws.iamRolePolicy.IamRolePolicy(
      name: "{this.name}-identity-pool-role-policy",
      role: role.id,
      policy: authenticatedCognitoPolicyDocument.json,
    );

    new aws.cognitoIdentityPoolRolesAttachment.CognitoIdentityPoolRolesAttachment(
      identityPoolId: identityPool.id,
      roles: {
        authenticated: role.arn,
      },
    );

    let apiSpec: MutJson = unsafeCast(this.api)?.apiSpec;
    let var cognitoDefinition = MutJson{};
    if props == nil || props?.authenticationType == nil || props?.authenticationType == types.AuthenticationType.COGNITO_USER_POOLS {
      cognitoDefinition = {
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
    } elif props?.authenticationType == types.AuthenticationType.AWS_IAM {
      cognitoDefinition = {
        "type": "apiKey",
        "name": "Authorization",
        "in": "header",
        "x-amazon-apigateway-authtype": "awsSigv4"
      };
    }

    let securityScheme = MutJson{};
    securityScheme.set(this.name, cognitoDefinition);
    apiSpec.set("components", {
      "securitySchemes": Json.deepCopy(securityScheme),
    });

    this.clientId = client.id;
    this.userPoolId = userPool.id;
    this.identityPoolId = identityPool.id;
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
    if paths.tryGet(path) == nil {
      throw "Path {path} not found. `cloud.Api.{method}({path}) must be called before.`";
    }
    let methods = paths.get(path);
    if methods.tryGet(method) == nil {
      throw "Method {method} not found. `cloud.Api.{method}({path}) must be called before.`";
    }
    let spec = methods.get(method);
    let security = MutJson{};
    security.set(this.name, []);
    spec.set("security", [security]);

    let template = "
    \{
      \"httpMethod\": \"$context.httpMethod\",
      \"path\": \"$context.resourcePath\",
      \"body\" : \"$input.body\",
      \"headers\": \{
        \"x-wing-cognitoIdentityId\": \"$context.identity.cognitoIdentityId\",
        \"x-wing-cognitoAuthenticationProvider\": \"$context.identity.cognitoAuthenticationProvider\",
        #foreach($param in $input.params().header.keySet())
        \"$param\": \"$util.escapeJavaScript($input.params().header.get($param))\"
        #if($foreach.hasNext),#end
        #end
      },
      \"queryStringParameters\": \{
        #foreach($param in $input.params().querystring.keySet())
        \"$param\": \"$util.escapeJavaScript($input.params().querystring.get($param))\"
        #if($foreach.hasNext),#end
        #end
      },
      \"pathParameters\": \{
        #foreach($param in $input.params().path.keySet())
        \"$param\": \"$util.escapeJavaScript($input.params().path.get($param))\"
        #if($foreach.hasNext),#end
        #end
      }
    }
        ";
    let extensionSpec = spec.get("x-amazon-apigateway-integration");
    extensionSpec.set("type", "aws");
    extensionSpec.set("requestTemplates", {
      "application/json": template,
    });
  }

  pub inflight signUp(email: str, password: str): void {
    Cognito_tfaws._signUp(this.clientId, email, password);
  }

  pub inflight adminConfirmUser(email: str): void {
    Cognito_tfaws._adminConfirmUser(this.userPoolId, email);
  }

  pub inflight initiateAuth(email: str, password: str): str {
    return Cognito_tfaws._initiateAuth(this.clientId, email, password);
  }

  pub inflight getId(poolId: str, identityPoolId: str, token: str): str {
    return Cognito_tfaws._getId(this.userPoolId, this.identityPoolId, token);
  }

  pub inflight getCredentialsForIdentity(token: str, identityId: str): Json {
    return Cognito_tfaws._getCredentialsForIdentity(this.userPoolId, token, identityId);
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

  extern "./aws-utils.js" static pub inflight _signUp(clientId: str, email: str, password: str): void;
  extern "./aws-utils.js" static pub inflight _adminConfirmUser(poolId: str, email: str): void;
  extern "./aws-utils.js" static pub inflight _initiateAuth(clientId: str, email: str, password: str): str;
  extern "./aws-utils.js" static pub inflight _getId(poolId: str, identityPoolId: str, token: str): str;
  extern "./aws-utils.js" static pub inflight _getCredentialsForIdentity(poolId: str, token: str, identityPoolId: str): Json;
}
