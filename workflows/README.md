# Workflows

> MATURITY: experimental and not finished yet

A durable workflows library for Wing.

## Prerequisites

* [winglang](https://winglang.io).

## Installation

```sh
npm i @winglibs/workflows
```

## Usage

```js
bring workflows;

let wf = new workflows.Workflow([
  // steps... 
]);'
```

We currently support two types of steps:

1. `workflow.steps.execute()` - runs an inflight closure sequentially
2. `workflow.steps.check()` - runs an inflight predicate and branches based on the result (true/false)

## Preflight API

* `onSuccess(cb: inflight (Json?): void)` - calls `cb` when the workflow finishes successfully.
* `onError(cb: inflight (Json?): void)` - calls `cb` when one of the workflow steps throws an error.

## Inflight API

* `inflight start(ctx: Json?)` - starts the workflow with an initial context.
* `inflight join(opts: util.WaitUntilProps?)` - waits until the workflow is complete. If an error is thrown, this method will throw.
* `inflight status(): Status` - returns the current status of the workflow.
* `inflight ctx(): Json` - returns the current context value.
* `inflight error(): Error?` - returns the last error (or `nil`).

## `execute` Step

The `execute` step executes an inflight closure in a sequence.

```js
bring workflows;

let w = new workflows.Workflow([
  workflows.steps.execute("say hello", inflight (ctx) => {
    log("hello, {ctx.get("name").asStr()}!");
    return {
      boom: 1234,
    }
  });
]);

test "main" {
  w.start({ name: "world" });
  let result = w.join();
  log("result is: {result}");
  // prints: { name: "world", boom: 1234 }
}
```

The `ctx` argument is a `Json` object which is propagated throughout the workflow. Each execute step
accepts the last context as input and returns a new JSON object that is *merged* with the input.

## `check` Step

TODO DOCS

## License

This library is licensed under the [MIT License](./LICENSE).
