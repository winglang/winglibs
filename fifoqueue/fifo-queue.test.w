bring expect;
bring util;
bring cloud;
bring "./fifo-queue.w" as fifo_queue;

let queue = new fifo_queue.FifoQueue();
let counter = new cloud.Counter();

queue.setConsumer(inflight (message: str) => {
  log("start {message}");
  util.sleep(10s);
  counter.inc();
  log("end {message}");
});

test "sequentially consume messages with the same group id " {
  queue.push("msg1", groupId: "123");
  queue.push("msg2", groupId: "123");
  util.sleep(15s);
  expect.equal(counter.peek(), 1);
  util.sleep(15s);
  expect.equal(counter.peek(), 2);
}

test "parallelly consume messages with different group ids" {
  queue.push("msg1", groupId: "123");
  queue.push("msg2", groupId: "456");
  util.sleep(15s);
  expect.equal(counter.peek(), 2);
}
