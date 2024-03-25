bring "../../types.w" as types;

pub struct PutEventCommandEntry {
  Source: str;
  DetailType: str;
  Detail: str;
  EventBusName: str;
  Resources: Array<str>;
}

pub struct PutEventCommandInput {
  Entries: Array<PutEventCommandEntry>;
}

pub class Util {
  pub static inflight putEvent(name: str, events: Array<types.PublishEvent>): void {
    let entries = MutArray<PutEventCommandEntry>[];
    for event in events {
      entries.push(PutEventCommandEntry{
        Source: event.source,
        DetailType: event.detailType,
        Detail: Json.stringify(event.detail),
        EventBusName: name,
        Resources: event.resources,
      });
    }
    let input = {
      Entries: entries.copy(),
    };
    Util._putEvent(name, input);
  }

  extern "./publish.js" pub static inflight _putEvent(name: str, event: PutEventCommandInput): void;
}
