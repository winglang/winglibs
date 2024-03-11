# fifoqueue

A wing library to work with FIFO (first-in first-out) Queues.

To use the queue, set `groupId` to group messages and process them in an ordered fashion.

## Prerequisites

* [winglang](https://winglang.io).

## Installation

```sh
npm i @winglibs/fifoqueue
```

## Usage

```js
bring fifoqueue;

let queue = new fifoqueue.FifoQueue();

queue.setConsumer(inflight (message: str) => {
  log("recieved message {message}");
});

test "will push to queue" {
  queue.push("a new message", groupId: "myGroup");
}
```

## License

This library is licensed under the [MIT License](./LICENSE).
