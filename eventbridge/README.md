# eventbridge

A Wing library for working with [Amazon EventBridge](https://aws.amazon.com/eventbridge/).

## Prerequisites

* [winglang](https://winglang.io)

## Installation

```sh
npm i @winglibs/eventbridge
```

## Usage

```js
bring cloud;
bring eventbridge;

let bus = new eventbridge.Bus(name: "my-bus");

bus.onEvent("github.pull-request.created", inflight (event) => {
  log("subscribed event received {Json.stringify(event)}");
}, {
  "detail-type": [{"prefix": "pull-request."}],
  "source": ["github.com"],
});

new cloud.Function(inflight () => {
  bus.putEvents({
    detailType: "pull-request.created",
    resources: ["test"],
    source: "github.com",
    version: "0",
    detail: {
      "test": "test",
    },
  });
});
```

## Parameters

* eventBridgeName - `str` - Optional. Name of an existing EventBridge to reference.

#### Usage

```sh
wing compile -t @winglang/platform-awscdk -v eventBridgeName="my-bus" main.w
```

## License

This library is licensed under the [MIT License](./LICENSE).
