bring cloud;

pub struct EventBridgeProps {
  name: str;
  debug: bool?;
}

pub struct Event {
  id: str;
  version: num;
  time: str;
  account: str;
  region: str;
  resources: Array<str>;
  source: str;
  detailType: str;
  detail: Json;
}

pub struct PublishEvent {
  version: num;
  resources: Array<str>;
  source: str;
  detailType: str;
  detail: Json;
}

pub interface IEventBridgeBus extends std.IResource {
  // subscribe(callback: inflight (Event): void, pattern: Json): std.Resource;
  // inflight publish(event: PublishEvent): void;
}

pub interface IEventBridge extends std.IResource {
  inflight publish(event: PublishEvent): void;
  subscribeFunction(name: str, handler: cloud.Function, pattern: Json): void;
  subscribeQueue(name: str, queue: cloud.Queue, pattern: Json): void;
}

pub interface IEventBridgeInstance extends std.IResource {}