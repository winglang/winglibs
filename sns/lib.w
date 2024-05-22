bring util;
bring "./types.w" as types;
bring "./sim.w" as sim;
bring "./aws.w" as aws;

/// MobileClient is a client for interacting with SNS mobile service.
/// No cloud resources are created when using this class.
/// When running the simulator in a non test environment, it will use the
/// actual cloud implementation.
pub class MobileClient impl types.IMobileClient {
  inner: types.IMobileClient;
  new() {
    let target = util.env("WING_TARGET");
    if target == "sim" {
      if std.Node.of(this).app.isTestEnvironment {
        this.inner = new sim.MobileClient_sim();
      } else {
        this.inner = new aws.MobileClient_aws();  
      }
    } elif target == "tf-aws" {
      this.inner = new aws.MobileClient_aws();
    } elif target == "awscdk" {
      this.inner = new aws.MobileClient_aws();
    } else {
      throw "Unsupported target {target}";
    }
  }

  pub inflight publish(options: types.PublishOptions): types.PublishResult {
    return this.inner.publish(options);
  }
}
