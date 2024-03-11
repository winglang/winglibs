bring cloud;
bring "../lib.w" as lib;

let table = new lib.Table(
  attributeDefinitions: [
    {
      attributeName: "id",
      attributeType: "S",
    },
  ],
  keySchema: [
    {
      attributeName: "id",
      keyType: "HASH",
    },
  ],
);

test "transactWrite (put)" {
  table.transactWrite(
    transactItems: [
      {
        put: {
          item: {
            id: "1",
            body: "hello",
          },
        },
      },
    ],
  );

  let response = table.scan();
  assert(response.count == 1);
  assert(response.items.at(0).get("id").asStr() == "1");
  assert(response.items.at(0).get("body").asStr() == "hello");
}

test "transactWrite (delete)" {
  table.transactWrite(
    transactItems: [
      {
        put: {
          item: {
            id: "1",
            body: "hello",
          },
        },
      },
    ],
  );

  table.transactWrite(
    transactItems: [
      {
        delete: {
          key: {
            id: "1",
          },
        },
      },
    ],
  );

  let response = table.scan();
  assert(response.count == 0);
}

test "transactWrite (update)" {
  table.transactWrite(
    transactItems: [
      {
        put: {
          item: {
            id: "1",
            body: "hello",
          },
        },
      },
    ],
  );

  table.transactWrite(
    transactItems: [
      {
        update: {
          key: {
            id: "1",
          },
          updateExpression: "SET body = :body",
          expressionAttributeValues: {
            ":body": "world",
          },
        },
      },
    ],
  );

  let response = table.scan();
  assert(response.count == 1);
  assert(response.items.at(0).get("id").asStr() == "1");
  assert(response.items.at(0).get("body").asStr() == "world");
}

test "transactWrite (conditionCheck)" {
  table.transactWrite(
    transactItems: [
      {
        put: {
          item: {
            id: "1",
            body: "hello",
          },
        },
      },
    ],
  );

  try {
    table.transactWrite(
      transactItems: [
        {
          conditionCheck: {
            key: {
              id: "1",
            },
            conditionExpression: "attribute_not_exists(id)",
          },
        },
      ],
    );
  } catch error {
    assert(error == "Transaction cancelled, please refer cancellation reasons for specific reasons [ConditionalCheckFailed]");
  }
}