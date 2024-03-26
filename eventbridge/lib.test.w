bring cloud;
bring expect;
bring util;
bring "./lib.w" as lib;
bring "./types.w" as types;

let eventBridge = new lib.Bus(name: "test");

class InboundGithubEvents {
  pub bucket: cloud.Bucket;

  new() {
    this.bucket = new cloud.Bucket();
    let counter = new cloud.Counter();

    eventBridge.onEvent("github.pull-request.created", inflight (event) => {
      log("subscribed event received {Json.stringify(event)}");
      this.bucket.put("test-{counter.inc()}", Json.stringify(event));
    }, {
      "detail-type": [{"prefix": "pull-request."}],
      "source": ["github.com"],
    });
  }
}

class Environments {
  pub bucket: cloud.Bucket;
  new() {
    let queue = new cloud.Queue();
    this.bucket = new cloud.Bucket();

    queue.setConsumer(inflight (event) => {
      log("subscribed event {event} received {Json.stringify(event)}");
      this.bucket.put("environment", event);
    });

    eventBridge.subscribeQueue("environments.created", queue, {
      "detail-type": [{"prefix": "myTest"}],
      source: ["myTest"],
    });
  }
}

let github = new InboundGithubEvents();
let env = new Environments();

test "publish to eventbridge" {
  log("publishing to eventbridge");
  eventBridge.putEvents({
    detailType: "pull-request.created",
    resources: ["test"],
    source: "github.com",
    version: "0",
    detail: {
      "test": "test",
    },
  });

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

  expect.equal(0, env.bucket.list().length);

  eventBridge.putEvents({
    detailType: "myTest.check",
    resources: ["test"],
    source: "myTest",
    version: "0",
    detail: {
      "fake": "env",
    },
  });

  log("published 2nd event");

  util.waitUntil(inflight () => {
    log("checking environment bucket for event");
    return env.bucket.exists("environment");
  }, {
    timeout: 60s,
  });

  // cant deserialize events coming from queue (see https://github.com/winglang/wing/issues/3686)
  let published2 = env.bucket.getJson("environment");
  expect.equal("myTest.check", published2.get("detail-type"));
  expect.equal("test", published2.get("resources").getAt(0));
  expect.equal("myTest", published2.get("source"));
}
