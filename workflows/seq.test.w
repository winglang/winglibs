bring "./seq.w" as seq;
bring cloud;
bring expect;
bring util;

let s = new seq.Sequencer();
let c = new cloud.Counter();

s.push(new cloud.Function(inflight () => {
  log("one");
  c.inc();
}) as "f1");

s.push(new cloud.Function(inflight () => {
  log("two");
  c.inc();
}) as "f2");

test "index is -1 before we start" {
  expect.equal(s.index(), -1);
  expect.equal(s.status(), seq.Status.NOT_STARTED);
}

test "every next() call increments the index" {
  expect.equal(s.status(), seq.Status.NOT_STARTED);
  s.next();
  util.waitUntil(() => { return c.peek() == 1; });
  expect.equal(s.status(), seq.Status.IN_PROGRESS);
  expect.equal(s.index(), 0);
  s.next();
  util.waitUntil(() => { return c.peek() == 2; });
  expect.equal(s.index(), 1);
  expect.equal(s.status(), seq.Status.DONE);
}

test "reset() will move back to -1" {
  expect.equal(s.index(), -1);
  s.reset();
  expect.equal(s.index(), -1);
  s.next();
  util.waitUntil(() => { return c.peek() == 1; });
  expect.equal(s.index(), 0);
  s.reset();
  expect.equal(s.index(), -1);
}