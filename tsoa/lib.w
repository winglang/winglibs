bring cloud;
bring ui;
bring util;
bring "./types.w" as types;
bring "./sim.w" as sim;
bring "./tfaws.w" as tfaws;

/**
 * Starts a new TSOA service.
 */
pub class Service impl types.IService {
  inner: types.IService;
  pub url: str;

  new(props: types.ServiceProps) {
    let target = util.env("WING_TARGET");
    if target == "sim" {
      let service = new sim.Service_sim(props);
      this.inner = service;
      this.url = service.url;
    } elif target == "tf-aws" {
      let service = new tfaws.Service_tfaws(props);
      this.inner = service;
      this.url = service.url;
    } else {
      throw "Unknown target: {target}";
    }

    new cloud.Endpoint(this.url);
  }

  pub liftClient(id: str, client: std.Resource, ops: Array<str>) {
    this.inner.liftClient(id, client, ops);
  }
}
