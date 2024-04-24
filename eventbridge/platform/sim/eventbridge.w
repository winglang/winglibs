bring cloud;
bring "./../../types.w" as types;
bring "./bus.w" as bus;

pub class Bus impl types.IBus {
  bus: bus.EventBridgeBus;

  new(props: types.BusProps?) {
    this.bus = new bus.EventBridgeBus(props);
  }

  pub onEvent(name: str, handler: inflight (types.Event): void, pattern: Json): void {
    class FnRule {
      new(bus: bus.EventBridgeBus) {
        let onMessageHandler = bus.subscribe(inflight (event) => {
          handler(event);
        }, pattern);

        let node = std.Node.of(this);
      }
    }

    let rule = new FnRule(this.bus) as "Rule \"{name}\"";
  }

  pub subscribeQueue(name: str, queue: cloud.Queue, pattern: Json): void {
    class Rule {
      new(bus: bus.EventBridgeBus) {
        let onMessageHandler = bus.subscribe(inflight (event) => {
          let json: MutJson = event;
          // make it look like it came from AWS
          json.set("detail-type", json["detailType"]);
          json.set("detailType", unsafeCast(nil));
          queue.push(Json.stringify(json));
        }, pattern);

        let node = std.Node.of(this);

        node.addConnection(
          name: "event rule",
          source: this,
          target: queue,
        );
      }
    }

    let rule = new Rule(this.bus) as "Rule \"{name}\"";
  }

  pub inflight putEvents(events: Array<types.PublishEvent>): void {
    this.bus.putEvents(events);
  }
}
