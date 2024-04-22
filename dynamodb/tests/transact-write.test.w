bring cloud;
bring "../dynamodb.w" as dynamodb;

let table = new dynamodb.Table(
  attributes: [
    {
      name: "id",
      type: "S",
    },
  ],
  hashKey: "id",
);

test "transactWrite (put)" {
  table.transactWrite(
    TransactItems: [
      {
        Put: {
          Item: {
            id: "1",
            body: "hello",
          },
        },
      },
    ],
  );

  let response = table.scan();
  assert(response.Count == 1);
  assert(response.Items[0]["id"].asStr() == "1");
  assert(response.Items[0]["body"].asStr() == "hello");
}

test "transactWrite (delete)" {
  table.transactWrite(
    TransactItems: [
      {
        Put: {
          Item: {
            id: "1",
            body: "hello",
          },
        },
      },
    ],
  );

  table.transactWrite(
    TransactItems: [
      {
        Delete: {
          Key: {
            id: "1",
          },
        },
      },
    ],
  );

  let response = table.scan();
  assert(response.Count == 0);
}

test "transactWrite (update)" {
  table.transactWrite(
    TransactItems: [
      {
        Put: {
          Item: {
            id: "1",
            body: "hello",
          },
        },
      },
    ],
  );

  table.transactWrite(
    TransactItems: [
      {
        Update: {
          Key: {
            id: "1",
          },
          UpdateExpression: "SET body = :body",
          ExpressionAttributeValues: {
            ":body": "world",
          },
        },
      },
    ],
  );

  let response = table.scan();
  assert(response.Count == 1);
  assert(response.Items[0]["id"].asStr() == "1");
  assert(response.Items[0]["body"].asStr() == "world");
}

test "transactWrite (conditionCheck)" {
  table.transactWrite(
    TransactItems: [
      {
        Put: {
          Item: {
            id: "1",
            body: "hello",
          },
        },
      },
    ],
  );

  try {
    table.transactWrite(
      TransactItems: [
        {
          ConditionCheck: {
            Key: {
              id: "1",
            },
            ConditionExpression: "attribute_not_exists(id)",
          },
        },
      ],
    );
  } catch error {
    assert(error == "Transaction cancelled, please refer cancellation reasons for specific reasons [ConditionalCheckFailed]");
  }
}
