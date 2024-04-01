bring dynamodb;
bring cloud;

pub class IdempotentFunction {
  handler: inflight (Json): Json;
  table: dynamodb.Table;
  func: cloud.Function;

  new(handler: inflight (Json): Json) {
    this.handler = handler;

    // create a table to store the idempotency keys
    this.table = new dynamodb.Table({
      attributes: [{
        name: "IdempotencyKey",
        type: "S",
      }, {
        name: "Result",
        type: "S",
      }],
      hashKey: "IdempotencyKey",
    }) as "IdempotencyTable";

    this.func = new cloud.Function(inflight (input: str?) => {
      if input == nil {
        throw "payload is required";
      }

      let hash = Json.stringify(input);
      let cached = this.table.get({
        Key: {
          IdempotencyKey: hash,
        },
        ConsistentRead: true,
      });
      if let item = cached.Item {
        return str.fromJson(item);
      }

      let result = handler(input);
      let resultStr = Json.stringify(result);
      this.table.put({
        Item: {
          IdempotencyKey: hash,
          Result: resultStr,
        },
      });
      return resultStr;
    });
  }

  pub inflight invoke(input: Json): Json {
    let res = this.func.invoke(Json.stringify(input))!;
    return Json.parse(res);
  }

  pub inflight invokeAsync(input: Json): void {
    this.func.invokeAsync(Json.stringify(input));
  }
}
