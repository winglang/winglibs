bring util;
bring "./commons/api.w" as api;
bring "./platform/tf-aws.w" as tf_aws;
bring "./platform/sim.w" as sim;

pub class MessageFanout impl api.IMessageFanout {
  inner: api.IMessageFanout;

  new() {
    let target = util.env("WING_TARGET");

    if target == "tf-aws" {
      this.inner = new tf_aws.MessageFanout_tfaws();
    } elif target == "sim" {
      this.inner = new sim.MessageFanout_sim();
    } else {
      throw "unsupported target {target}";
    }
  }

  pub addConsumer(handler: inflight(str): void, props: api.MessageFanoutProps): void {
    this.inner.addConsumer(handler, props);
  }

  pub inflight publish(message: str): void {
    this.inner.publish(message);
  }
}
