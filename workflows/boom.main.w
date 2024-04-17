bring "./workflow.w" as w;
bring "./api.w" as api;
bring cloud;

let m = new w.Workflow([
  api.steps.execute("say hello", inflight (ctx) => {
    log("hello {ctx.get("name")}!");
  }),

  api.steps.check("is name 5",
    inflight (ctx) => {
      return false;
    },
    ifTrue: [
    ],
    ifFalse: [
    ],
  )
]);

