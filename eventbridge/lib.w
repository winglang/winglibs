bring cloud;
bring "./types.w" as types;
bring "./platform/sim" as sim;

pub class EventBridgeInstance impl types.IEventBridgeInstance {
  inner: types.IEventBridgeInstance;

  new(props: types.EventBridgeProps) {
    this.inner = new sim.EventBridgeInstance(props);
    let node = std.Node.of(this);
    node.hidden = true;
  }
}

pub class EventBridge impl types.IEventBridge {
  inner: types.IEventBridge;

  new() {
    this.inner = new sim.EventBridge();
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