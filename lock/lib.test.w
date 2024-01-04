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
    l.acquire("l1", 1s);
    util.sleep(sleepTime);
    l.release("l1");
});

test "acquire within the time frame" {
  l.acquire("consumer", 1s);
  q.push("1"); //  acquire lock for 1 second
  l.acquire("consumer", 20s);
  l.acquire("l1", 2s);
}

test "acquire outside the time frame should trow" {
  l.acquire("consumer", 1s);
  q.push("10"); // acquire lock for 10 seconds 
  l.acquire("consumer", 20s);
  try {
    l.acquire("l1", 2s);
    assert(false);
  } catch {

  }
}

test "lock" {
  l.acquire("l1",1ms);
  try {
    l.acquire("l1",1ms);
    assert(false);
  } catch {
    assert(true);
  }
}

test "tryLock" {
  assert(l.tryAcquire("l1", 1ms));
  assert(!l.tryAcquire("l1", 1ms));
}

test "release should throw if there is nothing to release" {
  l.acquire("l1",1ms);
  l.release("l1");
  try {
    l.release("l1");
    assert(false);
  } catch { }
}

test "tryRelease" {
  l.acquire("l1",1ms);
  expect.equal(true, l.tryRelease("l1"));
  expect.equal(false, l.tryRelease("l1"));
}
