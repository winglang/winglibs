bring cloud;
bring ui;
bring util;
bring fs;
bring "./builder" as builder;
bring "./types" as types;
bring "./platforms" as platforms;

/// Properties for a new TSOA service.
pub struct ServiceProps {
  /// An array of path globs that point to your route controllers that you would like to have tsoa include.
  controllers: Array<str>?;
}

pub struct InvokeServiceRequest {
  method: str;
  path: str;
  headers: Map<str>?;
  query: Map<str>?;
  body: str?;
}

/// TSOA Service
pub class Service {
  pub url: str;
  pub function: cloud.Function;

  handler: inflight (Json): Json;

  pub inflight invoke(req: InvokeServiceRequest): cloud.ApiResponse {
    return cloud.ApiResponse.fromJson(Json.parse(this.function.invoke(Json.stringify(req))!));
  }

  new(props: ServiceProps) {
    let b = builder.TSOABuilder.singleton(nodeof(this));
    for controller in props.controllers ?? [] {
      b.controllers.push(controller);
    }

    let target = util.env("WING_TARGET");
    this.handler = b.makeHandler();

    if target == "sim" {
      let service = new platforms.SimService(this.handler);
      this.function = service.function;
      this.url = service.api.url;
    } elif target == "tf-aws" {
      let service = new platforms.AWSService(this.handler);
      this.function = service.function;
      this.url = service.url;
    } else {
      throw "Unknown target: {target}";
    }

    if let builderService = b.service {
      nodeof(this.function).addDependency(builderService);
    }

    new cloud.Endpoint(this.url);
  }

  pub lift(data: types.LiftOptions) {
    unsafeCast(this.handler)?.lift(data);
  }    
}
