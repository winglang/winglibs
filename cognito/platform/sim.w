bring cloud;
bring sim;
bring ui;
bring ex;
bring "@cdktf/provider-aws" as aws;
bring "../types.w" as types;

struct Route {
  path: str;
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

pub class Cognito impl types.ICognito {
  api: cloud.Api;
  counter: cloud.Counter;
  table: ex.Table;

  new(api: cloud.Api, props: types.CognitoProps?) {
    this.api = api;
    this.counter = new cloud.Counter();
    nodeof(this.counter).hidden = true;

    this.setUi();

    this.table = new ex.Table(name: "users", primaryKey: "email", columns: {
      "email" => ex.ColumnType.STRING,
      "password" => ex.ColumnType.STRING,
      "confirmed" => ex.ColumnType.BOOLEAN,
    }) as "users";
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
      let route = handler.mapping.eventProps.subscriptionProps.routes.at(0);
      if route.path == path && route.method == method.uppercase() {
        let pathJson = MutJson api.apiSpec.get("paths").get(path);
        pathJson.set(method, unsafeCast(nil));

        let api2: Json = unsafeCast(this.api);
        let callable: ICallable = unsafeCast(api2?.get(method));
        callable.call(this.api, path, inflight (req: cloud.ApiRequest) => {
          if req.headers?.tryGet("authorization") != "Bearer sim-auth-token" {
            if this.counter.peek() % 2 == 0 {
              return {
                status: 401,
                body: "Unauthorized"
              };            
            }
          }

          let res = func.invoke(Json.stringify(req));
          return cloud.ApiResponse.parseJson(res!);
        });

        this.api.node.tryRemoveChild(handler.mapping.node.id);

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
      "password": row!.get("password").asStr(),
      "confirmed": true,
    });
  }

  pub inflight initiateAuth(email: str, password: str): str {
    let row = this.table.tryGet(email);
    if !row? {
      throw "User not found";
    }

    if row!.get("email").asStr() != email || row!.get("password").asStr() != password {
      throw "Invalid credentials";
    }

    if !row!.get("confirmed").asBool() {
      throw "User not confirmed";
    }

    return "sim-auth-token";
  }
}
