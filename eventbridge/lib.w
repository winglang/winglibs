bring cloud;
bring util;
bring "./types.w" as types;
bring "./platform/sim" as sim;
bring "./platform/tfaws" as aws;
bring "./platform/awscdk" as awscdk;

/**
  Wing resource for Amazon EventBridge.
*/
pub class Bus impl types.IBus {
  inner: types.IBus;

  new(props: types.BusProps?) {
    let target = util.env("WING_TARGET");
    if target == "sim" {
      this.inner = new sim.Bus(props) as "sim";
    } else if target == "tf-aws" {
      this.inner = new aws.Bus(props) as "tf-aws";
    } else if target == "awscdk" {
      this.inner = new awscdk.Bus(props) as "awscdk";
    } else {
      throw "Unsupported target {target}";
    }

    nodeof(this).icon = "signal";
    nodeof(this).color = "red";
  }

  pub inflight putEvents(...events: Array<types.PublishEvent>): void {
    this.inner.putEvents(events);
  }

  pub onEvent(name: str, handler: inflight (types.Event): void, pattern: Json): void {
    this.inner.onEvent(name, handler, pattern);
  }
  pub subscribeQueue(name: str, queue: cloud.Queue, pattern: Json): void {
    this.inner.subscribeQueue(name, queue, pattern);
  }
}