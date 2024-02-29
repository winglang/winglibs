bring "./../../types.w" as types;
bring "@cdktf/provider-aws" as aws;

pub class EventBridgeBus impl types.IEventBridgeBus {
  pub bus: aws.cloudwatchEventBus.CloudwatchEventBus;

  pub static create(scope: std.IResource, props: types.EventBridgeProps): EventBridgeBus {
    let var root = std.Node.of(scope).root;
    let rootNode = std.Node.of(root);

    let id = "winglibs:eventbridge";
    // log("EventBridgeBus: creating1 {id}");
    return new EventBridgeBus(props) as id in root;
  }

  pub static exists(scope: std.IResource): EventBridgeBus? {
    let var root = std.Node.of(scope).root;
    let rootNode = std.Node.of(root);

    let id = "winglibs:eventbridge";
    let exists: EventBridgeBus? = unsafeCast(std.Node.of(root).tryFindChild(id));
    return exists;
  }

  pub static of(scope: std.IResource): EventBridgeBus {
    let var root = std.Node.of(scope).root;
    let rootNode = std.Node.of(root);

    let id = "winglibs:eventbridge";
    let exists: EventBridgeBus? = unsafeCast(std.Node.of(root).tryFindChild(id));
    if let bus = exists {
      log("EventBridgeBus: found {bus}");
      return bus;
      } else {
      throw "EventBridgeBus not found";
    }
  }

  new(props: types.EventBridgeProps) {
    log("EventBridgeBus: new {props.name}");
    this.bus = new aws.cloudwatchEventBus.CloudwatchEventBus(name: props.name) as "EventBridge";
  }
}

