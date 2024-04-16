bring "./workflow.w" as w;
bring "./api.w" as api;

bring cloud;

let b = new cloud.Bucket();
let name = "name.json";

new cloud.Function(inflight () => {
  b.putJson(name, {name: "elad"});
}) as "put name";

let x = new w.Workflow([
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
      api.steps.check("has name in bucket?", 
        inflight (input) => {
          return b.exists(name);
        },
        ifTrue: [
          api.steps.execute("get name from bucket", inflight (input) => {
            let s = b.getJson(name);
            log("{s}");
            return {
              retrieved: s
            };
          })
        ],
        ifFalse: [
          api.steps.execute("emit error", inflight (input) => {
            log("no name found");
          })
        ]
      ),

    ]
  ),
]);


new cloud.Function(inflight () => {
  x.start({name: "eyal"});
}) as "put name through workflow";

bring expect;

test "put name through workflow" {
  let thename = "thename";
  x.start({name: thename});
  let output = x.join();

  expect.equal(output.get("updated"), "hello, {thename}!");
}