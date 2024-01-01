bring expect;
bring cloud;
bring util;
bring "./lib.w" as lock;

let l = new lock.Lock();
let q = new cloud.Queue();
let counter = new cloud.Counter();

q.setConsumer(inflight (m: str) => {
    l.release("consumer");
    let sleepTime = duration.fromSeconds(num.fromStr(m));
    l.acquire("l1", timeout: 1s);
    util.sleep(sleepTime);
    l.release("l1");
});

test "acquire within the time frame" {
  l.acquire("consumer", timeout: 1s);
  q.push("1"); //  acquire lock for 1 second
  l.acquire("consumer", timeout: 20s);
  l.acquire("l1", timeout: 2s);
}

test "acquire outside the time frame should trow" {
  l.acquire("consumer", timeout: 1s);
  q.push("10"); // acquire lock for 10 seconds 
  l.acquire("consumer", timeout: 20s);
  try {
    l.acquire("l1", timeout: 2s);
    assert(false);
  } catch {

  }
}

test "lock" {
  l.acquire("l1", timeout: 1ms);
  try {
    l.acquire("l1", timeout: 1ms);
    assert(false);
  } catch {
    assert(true);
  }
}

test "tryLock" {
  assert(l.tryAcquire("l1", timeout: 1ms));
  assert(!l.tryAcquire("l1", timeout: 1ms));
}

test "release should throw if there is nothing to release" {
  l.acquire("l1",timeout: 1ms);
  l.release("l1");
  try {
    l.release("l1");
    assert(false);
  } catch { }
}

test "tryRelease" {
  l.acquire("l1",timeout: 1ms);
  expect.equal(true, l.tryRelease("l1"));
  expect.equal(false, l.tryRelease("l1"));
}

test "lock Expires" {
  l.acquire("l1", timeout: 1ms, expiry: 200ms);
  expect.equal(false, l.tryAcquire("l1", timeout: 10ms)); // should fail to acquire
  log("test: sleep 1s");
  util.sleep(1s);
  log("test: done sleeping");
  expect.equal(true, l.tryAcquire("l1", timeout: 1s)); // should acquire
}

test "lock doesn't Expires" {
  l.acquire("l1", timeout: 1ms, expiry: 3s);
  expect.equal(false, l.tryAcquire("l1", timeout: 10ms)); // should fail to acquire
  util.sleep(1s);
  expect.equal(false, l.tryAcquire("l1", timeout: 10ms)); // should acquire
}


let q2 = new cloud.Queue() as "q2";
q2.setConsumer(inflight () => {
  util.sleep(1ms);
  try {
    l.acquire("l1", timeout: 1s);
  } catch {
    assert(false);
  }
});


