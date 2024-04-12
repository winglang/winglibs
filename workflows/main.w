bring "./workflow.w" as w;
bring "./api.w" as api;

bring cloud;

let b = new cloud.Bucket();

new w.Workflow([
  api.steps.check("has name?", 
    inflight (input) => {
      return input.tryGet("name") != nil;
    },
    ifTrue: [
      api.steps.execute("put name in bucket", inflight (input) => {
        let s = "hello, {input.get("name")}!";
        b.putJson("state.json", input);
        log(s);
        return {
          updated: s
        };
      })
    ],
    ifFalse: [
      api.steps.execute("get name from bucket", inflight (input) => {
        let s = b.getJson("state.json");
        log("{s}");
        return {
          retrieved: s
        };
      })
    ]
  ),
]);