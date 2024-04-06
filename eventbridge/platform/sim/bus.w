bring cloud;
bring util;
bring "./../../types.w" as types;

pub class EventBridgeBus {
  extern "./match.js" inflight static matchesPattern(obj: Json, pattern: Json): bool;
  topic: cloud.Topic;
  var handlerCount: num;

  new(props: types.BusProps?) {
    this.topic = new cloud.Topic() as "EventBridge";

    this.handlerCount = 0;
  }

  pub subscribe(callback: inflight (types.Event): void, pattern: Json): std.Resource {
    class MyHandler {
      pub onMessageHandler: std.Resource;

      new(topic: cloud.Topic) {
        this.onMessageHandler = topic.onMessage(inflight(event: str) => {
          log("EventBridge: received raw event: " + event);
          try {
            let parsedEventRaw = Json.parse(event);
            let jsonEvent = MutJson {
              "detailType": parsedEventRaw.get("detail-type").asStr(),
            };

            for e in Json.entries(parsedEventRaw) {
              if (e.key == "detail-type") {
                continue;
              }
              jsonEvent.set(e.key, e.value);
            }

            let baseEvent = types.Event.fromJson(jsonEvent);

            if (EventBridgeBus.matchesPattern(parsedEventRaw, pattern)) {
              log("EventBridge: received event: " + event);
              callback(baseEvent);
            } else {
              log("EventBridge: ignoring event: " + event);
            }
          } catch e {
            log("EventBridge: ignoring event due to error: {event} - {e}");
          }
        });
      }
    }

    let handler = new MyHandler(this.topic) as "EventBridgeOnMessageHandler{this.handlerCount}";
    let node = std.Node.of(handler);

    let handlerNode = std.Node.of(handler.onMessageHandler);
    this.handlerCount += 1;

    return handler.onMessageHandler;
  }

  pub inflight putEvents(events: Array<types.PublishEvent>): void {
    for event in events {
      let fullEvent = Json {
        id: util.uuidv4(),
        time: "{datetime.utcNow().toIso()}",
        region: "local",
        account: "local",
        resources: event.resources,
        version: event.version,
        source: event.source,
        "detail-type": event.detailType,
        detail: event.detail,
      };
  
      let stringified = Json.stringify(fullEvent);
      log("EventBridge: published event: " + stringified);
      this.topic.publish(stringified);
    }
  }
}