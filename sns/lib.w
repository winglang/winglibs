bring util;
bring "./types.w" as types;
bring "./sim.w" as sim;
bring "./tfaws.w" as tfaws;

/// MobileClient is a client for interacting with SNS mobile service.
/// When running the simulator in a non test environment, it will use the
/// actual cloud implementation.
pub class MobileClient impl types.IMobileClient {
  inner: types.IMobileClient;
  new() {
    let target = util.env("WING_TARGET");
    if target == "sim" {
      if std.Node.of(this).app.isTestEnvironment {
        this.inner = new sim.MobileClient();
      } else {
        this.inner = new tfaws.MobileClient();  
      }
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
