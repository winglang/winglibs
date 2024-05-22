bring cloud;
bring util;
bring "../types.w" as types;
bring "./inflight.w" as inflyght;

pub class InflightApiEndpointHandler_aws extends inflyght.Inflight_tfaws impl types.IApiOnRequest {
  new(props: types.InflightProps) {
    super(props);
  }

  pub inflight handle(req: cloud.ApiRequest): cloud.ApiResponse? {

  }

  pub lift(obj: std.Resource, options: types.LiftOptions): cloud.IApiEndpointHandler {
    this.lifts.set(options.id, { client: obj, options: options });
    return this;
  }
}
