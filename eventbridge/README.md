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
bring eventbridge;

let bus = new eventbridge.Bus();

bus.subscribeFunction("github.pull-request.created", inflight (event) => {
  log("subscribed event received {Json.stringify(event)}");
}, {
  "detail-type": [{"prefix": "pull-request."}],
  "source": ["github.com"],
});

new cloud.Function(inflight () => {
  bus.putEvents([{
    detailType: "pull-request.created",
    resources: ["test"],
    source: "github.com",
    version: "0",
    detail: {
      "test": "test",
    },
  }]);
});

```

## License

This library is licensed under the [MIT License](./LICENSE).
