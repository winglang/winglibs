bring cloud;
bring util;
bring "./types.w" as types;
bring "./platform/sim" as sim;
bring "./platform/tfaws" as aws;
bring "./platform/awscdk" as awscdk;

/**
  Winglang resource for Amazon EventBridge.
*/
pub class Bus impl types.IBus {
  inner: types.IBus;

  new(props: types.BusProps) {
    let target = util.env("WING_TARGET");
    if target == "sim" {
      this.inner = new sim.Bus(props) as "sim";
    } elif target == "tf-aws" {
      this.inner = new aws.Bus(props) as "tf-aws";
    } elif target == "awscdk" {
      this.inner = new awscdk.Bus(props) as "awscdk";
    } else {
      throw "Unsupported target {target}";
    }
  }

  pub inflight publish(event: types.PublishEvent): void {
    this.inner.publish(event);
  }

  pub subscribeFunction(name: str, handler: inflight (types.Event): void, pattern: Json): void {
    this.inner.subscribeFunction(name, handler, pattern);
  }
  pub subscribeQueue(name: str, queue: cloud.Queue, pattern: Json): void {
    this.inner.subscribeQueue(name, queue, pattern);
  }
}