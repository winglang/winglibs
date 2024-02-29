bring cloud;
bring expect;
bring util;
bring "./lib.w" as lib;
bring "./types.w" as types;

// this is the actual event bus, shouldn't be
// referenced directly, but rather through the
// EventBridge class for publishing or subscribing.
new lib.EventBridgeInstance(
  name: "test",
);

class InboundGithubEvents {
  pub bucket: cloud.Bucket;

  new() {
    let eventBridge = new lib.EventBridge();

    this.bucket = new cloud.Bucket();
    let counter = new cloud.Counter();

    let fn = new cloud.Function(inflight (event) => {
      log("subscribed event received {event}");
      this.bucket.put("test-{counter.inc()}", event!);
    });

    eventBridge.subscribeFunction("github.pull-request.created", fn, {
      "detail-type": [{"prefix": "pull-request."}],
      "source": ["github.com"],
    });
  }
}

class Environments {
  new() {
    let eventBridge = new lib.EventBridge();
    let queue = new cloud.Queue();

    eventBridge.subscribeQueue("environments.created", queue, {
      "detail-type": [{"prefix": "myTest"}],
      source: ["myTest"],
    });
  }
}

let github = new InboundGithubEvents();
new Environments();

// this is the client, which needs to be created
// preflight, so that the references are available
let eventBridge = new lib.EventBridge();

test "publish to eventbridge" {
  log("publishing to eventbridge");
  eventBridge.publish(
    detailType: "pull-request.created",
    resources: ["test"],
    source: "github.com",
    version: 0,
    detail: {
      "test": "test",
    },
  );

  log("published");

  util.waitUntil(inflight () => {
    log("checking bucket for event");
    return github.bucket.exists("test-0");
  }, {
    timeout: 60s,
  });

  log("after wait");
  let published = types.Event.fromJson(github.bucket.getJson("test-0"));
  expect.equal("pull-request.created", published.detailType);
  expect.equal("test", published.resources.at(0));
  expect.equal("github.com", published.source);
}
