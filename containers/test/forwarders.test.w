bring cloud;
bring util;
bring http;
bring expect;
bring "../" as containers;

let workload = new containers.Workload(
  image: "{@dirname}/forwarders",
  name: "forwarders",
  port: 3000,
  public: true,
);

let requests = inflight (): Array<Json> => {
  let response = http.get("{workload.publicUrl!}/requests");
  assert(response.ok);
  return Json.values(Json.parse(response.body));
};

let api = new cloud.Api();
api.get("/get-api", workload.forward().fromApi());
api.post("/post-api", workload.forward().fromApi());

api.get("/foof", workload.forward(route: "/foo").fromApi());

test "api forwarding" {
  http.get("{api.url}/get-api?hello=world");

  expect.equal(requests(), [
    { method: "GET", url: "/get-api" }
  ]);

  http.post("{api.url}/post-api", body: "hello, body!");

  expect.equal(requests(), [
    { method: "GET", url: "/get-api" },
    { method: "POST", url: "/post-api", body: "hello, body!" }
  ]);
}

let queue1 = new cloud.Queue() as "queue1";
let queue2 = new cloud.Queue() as "queue2";
queue1.setConsumer(workload.forward(route: "/queue_message", method: cloud.HttpMethod.PUT).fromQueue());
queue2.setConsumer(workload.forward().fromQueue());

test "queue forwarding" {
  queue1.push("message1");
  util.waitUntil(() => { return requests().length == 1; });

  queue1.push("message2");
  util.waitUntil(() => { return requests().length == 2; });

  expect.equal(requests(), [
    { method: "PUT", url: "/queue_message", body: "message1" },
    { method: "PUT", url: "/queue_message", body: "message2" },
  ]);

  queue2.push("message3");
  util.waitUntil(() => { return requests().length == 3; });

  expect.equal(requests(), [
    { method: "PUT", url: "/queue_message", body: "message1" },
    { method: "PUT", url: "/queue_message", body: "message2" },
    { method: "POST", url: "/", body: "message3" },
  ]);
}

let topic = new cloud.Topic();
topic.onMessage(workload.forward(route: "/my_topic").fromTopic());

test "subscribe to topic" {
  topic.publish("message from topic!");
  util.waitUntil(() => { return requests().length == 1; });

  expect.equal(requests(), [
    { method: "POST", url: "/my_topic", body: "message from topic!" },
  ]);
}

let bucket = new cloud.Bucket();
bucket.onCreate(workload.forward(route: "/object-created").fromBucketEvent());

test "forward bucket events" {
  bucket.put("object1", "content1");
  util.waitUntil(() => { return requests().length == 1; });

  expect.equal(requests(), [
    { method: "POST", url: "/object-created", body: Json.stringify({"key":"object1","type":"create"}), },
  ]);
}

let schedule = new cloud.Schedule(rate: 1m);
schedule.onTick(workload.forward(route: "/tick", method: cloud.HttpMethod.GET).fromSchedule());

test "forward schedule events" {
  util.waitUntil(() => { return requests().length >= 1; });
  
  expect.equal(requests()[0], { method: "GET", url: "/tick" });
}
