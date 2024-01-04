bring cloud;
bring "./../../types.w" as types;
bring "./bus.w" as bus;

pub class EventBridge impl types.IEventBridge {
  bus: bus.EventBridgeBus;

  new() {
    this.bus = bus.EventBridgeBus.of(this);
    log("EventBridge: created {this.bus}");
  }

  pub subscribeFunction(name: str, handler: cloud.Function, pattern: Json): void {
    class FnRule {
      new(bus: bus.EventBridgeBus) {
        let onMessageHandler = bus.subscribe(inflight (event) => {
          handler.invoke(Json.stringify(event));
        }, pattern);

        let node = std.Node.of(this);

        node.addConnection(
          name: "event",
          source: this,
          target: handler,
        );
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