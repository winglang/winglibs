bring util;
bring "./types.w" as types;
bring "./sim.w" as sim;
bring "./tfaws.w" as tfaws;

pub class MobileClient impl types.IMobileClient {
  inner: types.IMobileClient;
  new() {
    let target = util.env("WING_TARGET");
    if target == "sim" {
      this.inner = new sim.MobileClient();
    } elif target == "tf-aws" {
      this.inner = new tfaws.MobileClient();
    } else {
      throw "Unsupported target {target}";
    }
  }

  pub inflight publish(options: types.PublishOptions): types.PublishResult {
    return this.inner.publish(options);
  }
}
