bring util;
bring "./types.w" as types;
bring "./sim.w" as sim;
bring "./aws.w" as aws;

/// MobileNotifications is a client for interacting with SNS mobile service.
/// No cloud resources are created when using this class.
/// When running the simulator in a non test environment, it will use the
/// actual cloud implementation.
pub class MobileNotifications impl types.IMobileNotifications {
  inner: types.IMobileNotifications;
  new() {
    let target = util.env("WING_TARGET");
    if target == "sim" {
      if nodeof(this).app.isTestEnvironment {
        this.inner = new sim.MobileNotifications_sim();
      } else {
        this.inner = new aws.MobileNotifications_aws();  
      }
    } elif target == "tf-aws" {
      this.inner = new aws.MobileNotifications_aws();
    } elif target == "awscdk" {
      this.inner = new aws.MobileNotifications_aws();
    } else {
      throw "Unsupported target {target}";
    }

    nodeof(this.inner).hidden = true;
    nodeof(this).icon = "chat-bubble-left";
    nodeof(this).color = "sky";
  }

  pub inflight publish(options: types.PublishOptions): types.PublishResult {
    return this.inner.publish(options);
  }

  pub onLift(host: std.IInflightHost, ops: Array<str>) {
    this.inner.onLift(host, ops);
  }
}
