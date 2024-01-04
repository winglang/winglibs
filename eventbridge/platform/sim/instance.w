bring "./../../types.w" as types;
bring "./bus.w" as bus;

pub class EventBridgeInstance impl types.IEventBridgeInstance{
  pub bus: bus.EventBridgeBus;

  new(props: types.EventBridgeProps) {
    this.bus = bus.EventBridgeBus.exists(this) ?? bus.EventBridgeBus.create(this, props);

    // hide nodes in console. The connection is still there,
    // but the nodes are hidden for better console experience.
    let node = std.Node.of(this.bus);
    node.hidden = true;

    let thisNode = std.Node.of(this);
    thisNode.hidden = true;
  }
}
