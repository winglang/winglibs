bring cloud;
bring util;
bring "./types.w" as types;
bring "./platform/sim" as sim;
bring "./platform/tf-aws" as aws;

pub class EventBridgeInstance impl types.IEventBridgeInstance {
  inner: types.IEventBridgeInstance;

  new(props: types.EventBridgeProps) {
    let target = util.env("WING_TARGET");
    if target == "sim" {
      this.inner = new sim.EventBridgeInstance(props) as "sim";
    } elif target == "tf-aws" {
      this.inner = new aws.EventBridgeInstance(props) as "tf-aws";
    } else {
      throw "Unsupported target {target}";
    }
  }
}

pub class EventBridge impl types.IEventBridge {
  inner: types.IEventBridge;

  new() {
    let target = util.env("WING_TARGET");
    if target == "sim" {
      this.inner = new sim.EventBridge() as "sim";
    } elif target == "tf-aws" {
      this.inner = new aws.EventBridge() as "tf-aws";
    } else {
      throw "Unsupported target {target}";
    }
  }

  pub inflight publish(event: types.PublishEvent): void {
    this.inner.publish(event);
  }

  pub subscribeFunction(name: str, handler: cloud.Function, pattern: Json): void {
    this.inner.subscribeFunction(name, handler, pattern);
  }
  pub subscribeQueue(name: str, queue: cloud.Queue, pattern: Json): void {
    this.inner.subscribeQueue(name, queue, pattern);
  }
}