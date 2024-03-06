# lock

## Prerequisites

* [winglang](https://winglang.io).

## Installation

`sh
npm i @winglibs/lock
`

## Usage

```js
bring lock;
bring cloud;
bring util;

let l = new lock.Lock();
let withoutExpiry = new cloud.Queue() as "without expiry";
let withExpiry = new cloud.Queue() as "with expiry";
withExpiry.setConsumer(inflight (m: str) => {
  let id = util.uuidv4();
  l.acquire("my-lock", timeout: 20s, expiry: 10ms);
  log("{id}:start");
  util.sleep(1s);
  log("{id}:end");
  l.release("my-lock");
});

withoutExpiry.setConsumer(inflight (m: str) => {
  let id = util.uuidv4();
  l.acquire("my-lock", timeout: 20s);
  log("{id}:start");
  util.sleep(1s);
  log("{id}:end");
  l.release("my-lock");
});

/**
Output without the lock
     │ 158e4f79-56e7-48ea-9469-4838741a255f:start
     │ e6a01372-4761-4365-b909-e32fa7dad605:start
     │ 158e4f79-56e7-48ea-9469-4838741a255f:end
     │ e6a01372-4761-4365-b909-e32fa7dad605:end
Output with the lock:
     │ 01da31df-4130-47f0-86f7-7173421a2676:start
     │ 01da31df-4130-47f0-86f7-7173421a2676:end
     │ a24e59d3-d088-4e4e-b134-d1c3a6dfe278:start
     │ a24e59d3-d088-4e4e-b134-d1c3a6dfe278:end
Output with an expiry:
     | dfac7a32-65f2-4267-bb91-e4041a22cc5f:start
     | 0ccee5ac-feb3-444e-9470-c660a06c7383:start
     | dfac7a32-65f2-4267-bb91-e4041a22cc5f:end
     | 0ccee5ac-feb3-444e-9470-c660a06c7383:end
*/
test "count without expiry" {
  withoutExpiry.push("1", "2");
  util.sleep(5s);
}

test "count with expiry" {
  withExpiry.push("1", "2");
  util.sleep(5s);
}

```

## Maintainers

[@ekeren](https://github.com/ekeren)


## License

This library is licensed under the [MIT License](./LICENSE).
