bring expect;
bring cloud;
bring util;
bring "./lib.w" as lock;

let ACQUIRE_TIMEOUT = 1m;

class TestStats {
  c: cloud.Counter;
  new() {
    this.c = new cloud.Counter() as "{util.nanoid()}"; // every test should have it's own unique counter

  }
  
  pub inflight report() {
    let j = MutJson {};
    for s in ["started", "ableToAcquire", "check", "completed", "failedToAcquire", "completed"] {
      j.set(s, this.c.peek());
    }
    log("{j}");
  }
  pub inflight inc(key: str):num {
    return this.c.inc(1,key);
  }
  
  pub inflight dec(key: str):num {
    return this.c.dec(1,key);
  }

  pub inflight peek(key: str):num {
    return this.c.peek(key);
  }
}


let l = new lock.Lock() as "myLock-1";
let q = new cloud.Queue(timeout: duration.fromMilliseconds(ACQUIRE_TIMEOUT.milliseconds * 2) ) as "myQueue";
let c = new TestStats();

let NUMBER_OF_EVENTS = 10;

q.setConsumer(inflight ()=> {
  c.inc("started");
  let success = l.tryAcquire("l", timeout: 10s);
  if success  {
    c.inc("ableToAcquire");
    let v = c.inc("check");
    if v != 0 {
      c.inc("bad");
    }
    util.sleep(1ms);
    c.dec("check");
    l.release("l");
    c.inc("completed");
  } else {
    c.inc("failedToAcquire");
    c.dec("completed");
  }

}, timeout: duration.fromMilliseconds(ACQUIRE_TIMEOUT.milliseconds * 2));


new cloud.Function( inflight () => {
  log("starting test with NUMBER_OF_EVENTS={NUMBER_OF_EVENTS}");

  c.report();
  for i in 1..NUMBER_OF_EVENTS {
    q.push("{i}");
    log("event ${i} sent");
    c.report();
  }

  log("done sending events");
  util.waitUntil(() => {
  c.report();
  return c.peek("completed") == NUMBER_OF_EVENTS-1;
  }, timeout: 10m, interval: 5s);
  expect.equal(NUMBER_OF_EVENTS-1, c.peek("completed"));
  expect.equal(0, c.peek("bad"));
}, timeout: duration.fromMilliseconds(ACQUIRE_TIMEOUT.milliseconds * 4)) as "stress-test";