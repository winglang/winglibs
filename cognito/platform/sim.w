bring cloud;
bring sim;
bring ui;
bring ex;
bring "@cdktf/provider-aws" as aws;
bring "../types.w" as types;

struct Route {
  pathPattern: str;
  method: str;
}

struct SubscriptionProps {
  routes: Array<Route>;
}

struct EventProps {
  subscriptionProps: SubscriptionProps;
}

struct Mapping {
  eventProps: EventProps;
  node: std.Node;
}

struct Handler {
  func: cloud.Function;
  mapping: Mapping;
}

struct Api {
  handlers: Map<Handler>;
  apiSpec: Json;
}

interface ICallable {
  call(api: cloud.Api, method: str, handler: inflight (cloud.ApiRequest): cloud.ApiResponse): void;
}

pub class Cognito_sim impl types.ICognito {
  api: cloud.Api;
  counter: cloud.Counter;
  table: ex.Table;
  props: types.CognitoProps?;

  new(api: cloud.Api, props: types.CognitoProps?) {
    this.api = api;
    this.props = props;
    this.counter = new cloud.Counter();
    nodeof(this.counter).hidden = true;

    this.setUi();

    this.table = new ex.Table(name: "users", primaryKey: "email", columns: {
      "email" => ex.ColumnType.STRING,
      "password" => ex.ColumnType.STRING,
      "confirmed" => ex.ColumnType.BOOLEAN,
    }) as "users";
    nodeof(this.table).hidden = true;
  }

  setUi() {
    new ui.Field("Status", inflight () => {
      if this.counter.peek() % 2 == 0 {
        return "Unauthorized";
      } else {
        return "Authorized";
      }
    }, refreshRate: 2s); 

    new ui.Button("Toggle Auth", inflight () => {
      this.counter.inc();
    });
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
    let api: Api = unsafeCast(this.api);
    for entry in api.handlers.entries() {
      let handler = entry.value;
      let func: cloud.Function = handler.func;
      let route = handler.mapping.eventProps.subscriptionProps.routes[0];
      if route.pathPattern == path && route.method == method.uppercase() {
        let pathJson = MutJson api.apiSpec["paths"][path];
        pathJson.set(method, unsafeCast(nil));

        let api2: Json = unsafeCast(this.api);
        let callable: ICallable = unsafeCast(api2?.get(method));
        callable.call(this.api, path, inflight (req: cloud.ApiRequest) => {
          let passAll = this.counter.peek() % 2 == 0;
          let authHeader = req.headers?.tryGet("authorization");
          let authType = this.props?.authenticationType ?? types.AuthenticationType.COGNITO_USER_POOLS;
          if !passAll {
            return {
              status: 401,
              body: "Unauthorized"
            };
          }

          if !authHeader? {
            return {
              status: () => {
                if authType == types.AuthenticationType.COGNITO_USER_POOLS {
                  return 401;
                } elif authType == types.AuthenticationType.AWS_IAM {
                  return 403;
                }
              }(),
              body: "Unauthorized"
            };
          }

          if authType == types.AuthenticationType.COGNITO_USER_POOLS {
            if req.headers?.tryGet("authorization") != "Bearer sim-auth-token" {
              return {
                status: 401,
                body: "Unauthorized"
              };
            }
          } elif authType == types.AuthenticationType.AWS_IAM {
            if !authHeader!.contains("AWS4-HMAC-SHA256 Credential=sim-access") {
              return {
                status: 403,
                body: "Unauthorized"
              };
            }
          }

          let res = func.invoke(Json.stringify(req));
          return cloud.ApiResponse.parseJson(res!);
        });

        nodeof(this.api).tryRemoveChild(handler.mapping.node.id);

        return;
      }
    }

    throw "Path {path} not found. `cloud.Api.{method}({path}) must be called before.`";
  }

  pub inflight signUp(email: str, password: str): void {
    this.table.upsert(email, {
      "email": email,
      "password": password,
      "confirmed": false,
    });
  }

  pub inflight adminConfirmUser(email: str): void {
    let row = this.table.tryGet(email);
    if !row? {
      throw "User not found";
    }

    this.table.update(email, {
      "email": email,
      "password": row!["password"].asStr(),
      "confirmed": true,
    });
  }

  pub inflight initiateAuth(email: str, password: str): str {
    let row = this.table.tryGet(email);
    if !row? {
      throw "User not found";
    }

    if row!["email"].asStr() != email || row!["password"].asStr() != password {
      throw "Invalid credentials";
    }

    if !row!["confirmed"].asBool() {
      throw "User not confirmed";
    }

    return "sim-auth-token";
  }

  pub inflight getId(poolId: str, identityPoolId: str, token: str): str {
    return token;
  }

  pub inflight getCredentialsForIdentity(token: str, identityId: str): Json {
    return {
      AccessKeyId: "sim-access",
      SecretKey: "sim-secret",
      SessionToken: "sim-session",
    };
  }
}
