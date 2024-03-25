# messagefanout

## Prerequisites

* [winglang](https://winglang.io).

## Installation

```sh
npm i @winglibs/messagefanout
```

## Usage

```js
bring messagefanout;

let fanout = new messagefanout.MessageFanout();

fanout.addConsumer(inflight (msg: str) => {
  log("Hello {msg}!!!");
});

test "push a message to fanout" {
  fanout.publish("world");
}
```

## License

This library is licensed under the [MIT License](./LICENSE).
