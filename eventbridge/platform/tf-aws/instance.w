bring "./../../types.w" as types;
bring "./bus.w" as bus;

pub class EventBridgeInstance impl types.IEventBridgeInstance{
  pub bus: bus.EventBridgeBus;

  new(props: types.EventBridgeProps) {
    this.bus = bus.EventBridgeBus.exists(this) ?? bus.EventBridgeBus.create(this, props);
  }
}

