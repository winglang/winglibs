bring cloud;

pub struct BusProps {
  name: str;
  debug: bool?;
}

pub struct Event {
  id: str;
  version: str;
  time: str;
  account: str;
  region: str;
  resources: Array<str>;
  source: str;
  detailType: str;
  detail: Json;
}

pub struct PublishEvent {
  version: str;
  resources: Array<str>;
  source: str;
  detailType: str;
  detail: Json;
}

pub interface IBus extends std.IResource {
  inflight publish(event: PublishEvent): void;
  subscribeFunction(name: str, handler: inflight (Event): void, pattern: Json): void;
  subscribeQueue(name: str, queue: cloud.Queue, pattern: Json): void;
}
