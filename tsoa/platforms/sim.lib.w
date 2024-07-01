bring cloud;
bring fs;
bring ui;
bring "../builder" as builder;

pub class SimService {
  pub function: cloud.Function;
  pub api: cloud.Api;

  new(handler: inflight (Json): Json) {
    let b = builder.TSOABuilder.singleton(nodeof(this));
    let specFile = b.specPath;
    this.api = new cloud.Api();
    
    let apiHandler = inflight (req: cloud.ApiRequest): cloud.ApiResponse => {
      let var body: Json? = nil;
      if req.body != nil && req.body != "" {
        body = Json.parse(req.body!);
      }
      let res = handler(
        {
          httpMethod: "{req.method}",
          path: req.path,
          headers: req.headers,
          queryStringParameters: req.query,
          body: body,
        }
      );
      let headers: MutJson = unsafeCast(res["headers"]);
      headers.set("Content-Type", "application/json");

      return {
        status: res["statusCode"].tryAsNum(),
        body: res["body"].tryAsStr(),
        headers: unsafeCast(headers),
      };
    };

    // TODO: Hack to allow * in paths
    let _api = unsafeCast(this.api);
    _api["_validatePath"] = () => { return true; };

    this.api.get("*", apiHandler);
    this.api.post("*", apiHandler);
    this.api.put("*", apiHandler);
    this.api.delete("*", apiHandler);
    nodeof(this.api).hidden = true;

    // Relies on internals of sim impl of cloud.Api
    this.function = _api?.handlers["{unsafeCast(apiHandler)?._id}"]?.func;

    new ui.HttpClient("Http Client",
      inflight () => {
        return this.api.url;
      },
      inflight () => {
        return fs.readFile(specFile);
      }
    );
  }
}