bring cloud;
bring "./inflight.w" as inflyght;
bring "../types.w" as types;

pub class InflightApiEndpointHandler extends inflyght.Inflight impl cloud.IApiEndpointHandler {
  new(props: types.InflightProps) {
    super(props);
  }

  pub inflight handle(req: cloud.ApiRequest): cloud.ApiResponse? {
    let response = this._handle(Json.stringify(req));
    if let res = Json.tryParse(response) {
      let headers = MutMap<str>{};
      for entry in Json.entries(res["headers"]) {
        headers.set(entry.key, entry.value.asStr());
      }
      return {
        status: res["statusCode"].asNum(),
        headers: headers.copy(),
        body: res["body"].tryAsStr(),
      };
    } else {
      return nil;
    }
  }
}
