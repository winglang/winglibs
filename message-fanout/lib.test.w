bring cloud;
bring util;
bring ex;
bring "./lib.w" as msgfanout;

let fanout = new msgfanout.MessageFanout();

let table = new ex.Table(
  name: "users",
  primaryKey: "msgId",
  columns: {
    "message" => ex.ColumnType.STRING
  }
);

fanout.addConsumer("first", inflight (event: str) => {
  let obj = Json.parse(event);
  let msg = "first_publisher_" + obj.get("Message").asStr();
  table.insert("first", { message: msg });
});

fanout.addConsumer("second", inflight (event: str) => {
  let obj = Json.parse(event);
  let msg = "second_publisher_" + obj.get("Message").asStr();
  table.insert("second", { message: msg });
});

let target = util.env("WING_TARGET");
if target == "tf-aws" {
  test "message fanout" {
    fanout.publish("hello");
    
    util.sleep(30s);
    
    assert(table.get("first").get("message") == "first_publisher_hello");  
    assert(table.get("second").get("message") == "second_publisher_hello");
  }
}
