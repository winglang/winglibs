bring cloud;
bring util;
bring "./types.w" as types;
bring "./platform/sim" as sim;
bring "./platform/tf-aws" as aws;
bring "./platform/awscdk" as awscdk;

pub class EventBridge impl types.IEventBridge {
  inner: types.IEventBridge;

  new(props: types.EventBridgeProps) {
    let target = util.env("WING_TARGET");
    if target == "sim" {
      this.inner = new sim.EventBridge(props) as "sim";
    } elif target == "tf-aws" {
      this.inner = new aws.EventBridge(props) as "tf-aws";
    } elif target == "awscdk" {
      this.inner = new awscdk.EventBridge(props) as "awscdk";
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