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
      if let h = res.tryGet("headers") {
        for entry in Json.entries(h) {
          headers.set(entry.key, entry.value.asStr());
        }
      }
      return {
        status: res.tryGet("statusCode")?.tryAsNum(),
        headers: headers.copy(),
        body: res.tryGet("body")?.tryAsStr(),
      };
    } else {
      return nil;
    }
  }
}
