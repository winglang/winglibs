bring cloud;
bring "./../../types.w" as types;
bring "./bus.w" as bus;

pub class EventBridge impl types.IEventBridge {
  bus: bus.EventBridgeBus;

  new(props: types.EventBridgeProps) {
    this.bus = new bus.EventBridgeBus(props);
    log("EventBridge: created {this.bus}");
  }

  pub subscribeFunction(name: str, handler: inflight (types.Event): void, pattern: Json): void {
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
          queue.push(Json.stringify(event));
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

  pub inflight publish(event: types.PublishEvent): void {
    this.bus.publish(event);
  }
}