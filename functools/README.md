# functools

## Prerequisites

* [winglang](https://winglang.io).

## Installation

```sh
npm i @winglibs/functools
```

## Usage

### `IdempotentFunction`

The `IdempotentFunction` class, inspired by [Powertools for AWS
Lambda](https://docs.powertools.aws.dev/lambda/typescript/latest/utilities/idempotency/),
provides a simple solution to convert your inflight functions into idempotent
operations which are safe to retry. Under the hood, it extends `cloud.Function` to communicate with a persistence layer to prevent handlers from executing
more than once on the same event payload, and it ensures handlers returns the
same result when called with the same payload.

```js
bring functools;

let submitOrder = new functools.IdempotentFunction(inflight (order: Json) => {
  // Do some work, then return a value
  return {
    orderId: order.get("orderId"),
    shippingId: util.uuidv4(),
  };
});

test "IdempotentFunction does not rerun the handler for identical payloads" {
  // Make an order
  let result1 = submitOrder.invoke("order1");
  expect.equal(result1.get("orderId"), "order1");

  // Make the same order again
  let result2 = submitOrder.invoke("order1");
  expect.equal(result2.get("orderId"), "order1");
  expect.equal(result2.get("shippingId"), result1.get("shippingId"));

  // Make a different order
  let result3 = submitOrder.invoke("order2");
  expect.equal(result3.get("orderId"), "order2");
  expect.notEqual(result3.get("shippingId"), result1.get("shippingId"));
}

```

#### Future improvements

- [ ] Hash the input to avoid storing large payloads in the cache
- [ ] Support custom idempotency keys (currently the entire input is used as the key)
- [ ] Support in-memory caching
- [ ] Support custom persistence layers (currently uses a DynamoDB table)
- [ ] Support TTLs for cache entries

## License

This library is licensed under the [MIT License](./LICENSE).
