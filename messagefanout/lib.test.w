bring cloud;
bring util;
bring "./lib.w" as msgfanout;

let fanout = new msgfanout.MessageFanout();

let data = new cloud.Bucket();

fanout.addConsumer(inflight (msg: str) => {
  data.putJson("first", { message: "first {msg}" });
}, name: "first");

fanout.addConsumer(inflight (msg: str) => {
  data.putJson("second", { message: "second {msg}" });
}, name: "second");

test "message fanout" {
  fanout.publish("hello 👋");
  
  util.sleep(10s);

  assert(data.getJson("first")["message"] == "first hello 👋");  
  assert(data.getJson("second")["message"] == "second hello 👋");
}
