bring "./workflow.w" as w;
bring "./api.w" as api;

bring cloud;

let b = new cloud.Bucket();
let name = "name.txt";

let workflow = new w.Workflow([
  api.steps.check("has name?", 
    inflight (input) => {
      return input.tryGet("name") != nil;
    },
    ifTrue: [
      api.steps.execute("put name in bucket", inflight (input) => {
        let s = "hello, {input.get("name")}!";
        b.putJson(name, input);
        log(s);
        return {
          updated: s
        };
      })
    ],
    ifFalse: [
      api.steps.execute("get name from bucket", inflight (input) => {
        let s = b.getJson(name);
        log("{s}");
        return {
          retrieved: s
        };
      })
    ]
  ),
]);

bring expect;

test "if 'name' is provided, it is stored in the bucket" {
  workflow.start({ name: "new name" });
  workflow.join();
  expect.equal(b.getJson(name), { name: "new name" });
}

test "if 'name' is not provided, it is retrieved from the bucket" {
  b.putJson(name, { name: "old name" });
  workflow.start();
  let result = workflow.join();
  expect.equal(result, {
    retrieved: {
      name: "old name"
    }
  });
}