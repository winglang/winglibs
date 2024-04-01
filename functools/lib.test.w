bring cloud;
bring expect;
bring "./lib.w" as l;
bring util;

let totalOrders = new cloud.Counter();

let submitOrder = new l.IdempotentFunction(inflight (order: Json) => {
  // Perform a side effect
  totalOrders.inc();

  // Return a result value
  return {
    orderId: order.get("orderId"),
    shippingId: util.uuidv4(),
  };
});

test "IdempotentFunction does not rerun the handler for identical payloads" {
  expect.equal(totalOrders.peek(), 0);

  // Make an order
  let result1 = submitOrder.invoke("order1");
  expect.equal(totalOrders.peek(), 1);
  expect.equal(result1.get("orderId"), "order1");

  // Make the same order again
  let result2 = submitOrder.invoke("order1");
  expect.equal(totalOrders.peek(), 1);
  expect.equal(result2.get("orderId"), "order1");
  expect.equal(result2.get("shippingId"), result1.get("shippingId"));

  // Make a different order
  let result3 = submitOrder.invoke("order2");
  expect.equal(totalOrders.peek(), 2);
  expect.equal(result3.get("orderId"), "order2");
  expect.notEqual(result3.get("shippingId"), result1.get("shippingId"));
}
