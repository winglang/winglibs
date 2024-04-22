bring cloud;
bring ui;
bring util;
bring fs;
bring "./types.w" as types;
bring "./sim.w" as sim;
bring "./tfaws.w" as tfaws;

/**
 * Starts a new TSOA service.
 */
pub class Service impl types.IService {
  inner: types.IService;
  pub url: str;
  pub specFile: str;

  new(props: types.ServiceProps) {
    let target = util.env("WING_TARGET");
    if target == "sim" {
      let service = new sim.Service_sim(props);
      this.inner = service;
      this.url = service.url;
      this.specFile = service.specFile;
    } elif target == "tf-aws" {
      let service = new tfaws.Service_tfaws(props);
      this.inner = service;
      this.url = service.url;
      this.specFile = service.specFile;
    } else {
      throw "Unknown target: {target}";
    }

    new ui.HttpClient("Http Client", inflight () => {
      return this.url;
    }, inflight () => {
      return fs.readFile(this.specFile);
    });
    new cloud.Endpoint(this.url);
  }

  pub lift(client: std.Resource, ops: types.LiftOptions) {
    this.inner.lift(client, ops);
  }
}
