bring expect;
bring cloud;
bring util;
bring "./lib.w" as lock;

let l = new lock.Lock() as "myLock";
let q = new cloud.Queue() as "myQueue";
let c = new cloud.Counter() as "myCounter";


let NUMBER_OF_EVENTS = 100;
let TEST_TIMEOUT = 1m;

q.setConsumer(inflight ()=> {
  c.inc(1, "started");
  l.acquire("l", timeout: TEST_TIMEOUT);
  let v = c.inc(1, "check");
  if v != 0 {
    c.inc(1, "bad");
  }
  util.sleep(1ms);
  c.dec(1, "check");
  l.release("l");
  c.inc(1, "completed");
}, timeout: TEST_TIMEOUT);

new cloud.Function( inflight () => {
  for i in 1..NUMBER_OF_EVENTS {
    q.push("{i}");
  }
  util.waitUntil(() => {
    log("{{
      started: c.peek("started"),
      bad: c.peek("bad"),
      completed: c.peek("completed")
    }}");
    return c.peek("completed") == NUMBER_OF_EVENTS-1;
  }, timeout: 10m, interval: 5s);
  expect.equal(NUMBER_OF_EVENTS-1, c.peek("completed"));
  expect.equal(0, c.peek("bad"));
}, timeout: TEST_TIMEOUT) as "stress-test";