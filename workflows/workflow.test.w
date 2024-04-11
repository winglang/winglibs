bring cloud;
bring expect;
bring util;
bring "./workflow.w" as workflows;
bring "./seq.w" as seq;

// -- simple sequence

let c = new cloud.Counter() as "c1";

let w = new workflows.Workflow([
  workflows.steps.execute("step1", inflight (input) => { 
    c.inc();
    log("step1 input: {input}");
    util.sleep(1s);
    return {
      Step1: {
        Message: "hello from step1",
      }
    };
  }),

  workflows.steps.execute("step2", inflight (input) => { 
    c.inc();
    log("step2 input: {input}");
    return {
      Step2: {
        Message: "world from step2",
      }
    };
  }),
]);

test "initial state is NOT_STARTED" {
  expect.equal(w.status(), seq.Status.NOT_STARTED);
}

test "moves to RUNNING after start" {
  w.start();
  util.waitUntil(() => { return c.peek() > 0; });
  expect.equal(w.status(), seq.Status.IN_PROGRESS);
}

test "full sequence with state merge" {
  w.start();
  util.waitUntil(() => { return c.peek() == 2; });
  expect.equal(w.status(), seq.Status.DONE);
  expect.equal(w.ctx(), {
    Step1: { Message: "hello from step1" },
    Step2: { Message: "world from step2" }
  });
}

// -- error handling

let w3 = new workflows.Workflow([
  workflows.steps.execute("step1", inflight () => { 
    throw "step1 failed";
  }),
]) as "w3";

let s3Bucket = new cloud.Bucket();

w3.onError(inflight (err) => {
  log("ERROR: {err.message}");
  s3Bucket.put("error.txt", err.message);
});

test "onError is called when a step fails" {
  w3.start();
  util.waitUntil(() => { return s3Bucket.exists("error.txt"); });
  expect.equal(s3Bucket.get("error.txt"), "step1 failed");
  expect.equal(w3.error(), { message: "step1 failed", stack: [] });
}

// -- check step

let c1 = new cloud.Counter() as "c2";
let c2 = new cloud.Counter() as "c3";

let w2 = new workflows.Workflow([
  workflows.steps.check("is X = true", 
    inflight (ctx) => { 
      return ctx.get("X").asBool();
    }, 
    ifTrue:  [ 
      workflows.steps.execute("inc c1", inflight () => { c1.inc(); })
    ],
    ifFalse: [
      workflows.steps.execute("inc c1", inflight () => { c2.inc(); })
    ]
  )
]) as "w2";

test "branch step" {
  // "true branch"
  c1.set(0);
  c2.set(0);
  w2.start({ X: true });
  w2.join();
  expect.equal(c1.peek(), 1);
  expect.equal(c2.peek(), 0);

  // "false branch"
  c1.set(0);
  c2.set(0);
  w2.start({ X: false });
  w2.join();
  expect.equal(c2.peek(), 1);
  expect.equal(c1.peek(), 0);
}


// -- join with success flow

let w4 = new workflows.Workflow([
  workflows.steps.execute("say hello", inflight (ctx) => {
    log("hello, {ctx.get("name").asStr()}!");
    return {
      more_context: 1234,
    };
  })
]) as "w4";

test "join with success flow" {
  w4.start({ name: "world" });
  let result = w4.join();
  log("result is: {result}");
  expect.equal(result, { more_context: 1234, name: "world" });
}

// -- join with failure flow

// TODO: not working yet!

// let w5 = new workflows.Workflow([
//   workflows.steps.execute("throw an error", inflight () => {
//     throw "I am an error";
//   })
// ]) as "w5ç";

// test "join with failure flow" {
//   w5.start();
//   let var err: str? = nil;
//   try {
//     w5.join();
//   } catch e {
//     err = e;
//   }

//   expect.equal(err, "hello");
// }