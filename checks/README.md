# Checks

The `Check` resource is a self-validation mechanism for cloud applications. Checks can be defined at
any level and can be used to check if the system is healthy at that level.

## Installation

```sh
npm i @winglibs/checks
```

## Usage

For example, a check can query the HTTP API of an app to verify it's operational:

```js
bring cloud;
bring http;
bring checks;

let api = new cloud.Api();

api.get("/", inflight (req) => {
  return { status: 200 };
});

new checks.Check(inflight () => { 
  assert(http.get(api.url).ok);
}) as "main route returns 200 ok";
```

The `main route returns 200 ok` check simply sends an HTTP GET to the url of the API and verifies that a success was
returned.

There's a higher level convenience class called `CheckHttp` which can be used to implement this
exact check:

```js
new checks.CheckHttp(api.url) as "main route returns 200 ok";
```

As mentioned above, checks can be defined at the application level, but they can also be defined
within user defined classes and shipped within Wing libraries. This turns them into a powerful
mechanism for continuously making sure the system is healthy at multiple levels.

## When do checks run?

Checks can be executed through any of these methods:

* By manually calling `check.run()`
* During deployment
* Periodically
* As a Wing test

Let's review each method.

### Running checks manually with `check.run()`

The `run()` method will execute the check and will return the check results. If the check fails,
`run()` will **not** throw an error, but the check result will have `ok` set to `false` and an
`error` field.

### Running checks during deployment

By default, all checks will run during deployment (using a `cloud.OnDeploy` resource). If a check
fails, the deployment will fail as well.

To disable this behavior set `deploy: false` when the check is defined:

```js
new Check(handler, deploy: false);
```

### Running checks periodically

If you wish to run the check at a specific rate (e.g. as a health check), simply set the `rate`
option to the desired rate:

```js
new Check(handler, rate: 5m);
```

### Running checks as tests

By default, all checks will also be executed as Wing tests.

For example, say we have `failing.main.w`:

```js
let handler = inflight () => { assert(false); };
new cloud.Check(handler);
```

And then:

```sh
wing test failing.main.w

fail ┌ failing.main.wsim » root/env0/c.Check/test
     │ Error: assertion failed: false
     │     at /var/folders/vm/cm444l3124j_vh_8rkhz6kqm0000gn/T/wing-bundles-Vo5LLf/index.js:21:23
     │     at $Closure1.handle (/var/folders/vm/cm444l3124j_vh_8rkhz6kqm0000gn/T/wing-bundles-Vo5LLf/index.js:22:15)
     └     at exports.handler (/var/folders/vm/cm444l3124j_vh_8rkhz6kqm0000gn/T/wing-bundles-Vo5LLf/index.js:40:9)
 
 
Tests 1 failed (1)
Test Files 1 failed (1)
Duration 0m1.11s
```

If a check fails, the test will fail. To disable this behavior set `testing` to `false`:

```js
let handler = inflight () => { assert(false); };
new cloud.Check(handler, testing: false);
```

## Results

When a check is run, the result of a check is stored and includes the following fields:

* `timestamp` in UTC
* `ok` status
* `error` message (only if the check failed)
* `checkid` the unique id of the check (non human readable)
* `checkpath` the node path of the check (human readable)

To obtain the result of the last run, use the `check.latest()` method, which returns an optional
`CheckResult`. If the test was never executed, `nil` is returned.

The check results of the entire app are stored in a shared bucket and can be obtained through this
api:

```js
bring checks;
let resultsBucket = checks.Results.getOrCreate(this).bucket;
let allResults = resultsBucket.list();
```

## Roadmap

- [ ] Centrally enable/disable checks either only in deploy-time or always.
- [ ] REST API for querying/executing checks
- [ ] Console UI

## Maintainers
- [Elad Ben-Israel](https://github.com/eladb) 
- [Subhodip Roy](https://github.com/subh-cs)

## License

Licensed under the [MIT License](./LICENSE).