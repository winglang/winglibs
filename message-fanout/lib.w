bring util;
bring "./commons/api.w" as api;
bring "./platform/tf-aws.w" as tf_aws;

pub class MessageFanout impl api.IMessageFanout {
  inner: api.IMessageFanout;

  new() {
    let target = util.env("WING_TARGET");

    if target == "tf-aws" {
      this.inner = new tf_aws.MessageFanout_tfaws();
    }
  }

  pub addConsumer(handler: inflight(str): void, props: api.MessageFanoutProps): void {
    this.inner.addConsumer(handler, props);
  }

  pub inflight publish(message: str): void {
    this.inner.publish(message);
  }
}
