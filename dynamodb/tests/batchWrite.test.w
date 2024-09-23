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

test "batchWrite - put" {
  let batchResponse = table.batchWrite(
    PutRequests: [
      { Item: { id: "1", body: "hello" } },
      { Item: { id: "2", body: "wing" } },
      { Item: { id: "3", body: "world" } }
    ]
  );

  assert(batchResponse.UnprocessedItems?.size() == 0);

  let scanResponse = table.scan();
  assert(scanResponse.Count == 3);
  scanResponse.Items.contains({id: "1", body: "hello"});
  scanResponse.Items.contains({id: "2", body: "wing"});
  scanResponse.Items.contains({id: "3", body: "world"});
}

test "batchWrite - delete" {
  let batchPutResponse = table.batchWrite(
    PutRequests: [
      { Item: { id: "1", body: "hello" } },
      { Item: { id: "2", body: "wing" } },
      { Item: { id: "3", body: "world" } }
    ]
  );

  assert(batchPutResponse.UnprocessedItems?.size() == 0);

  let var scanResponse = table.scan();
  assert(scanResponse.Count == 3);

  let batchDeleteResponse = table.batchWrite(
    DeleteRequests: [
      { Key: { id: "2" } },
      { Key: { id: "3" } },
    ]
  );

  scanResponse = table.scan();
  assert(scanResponse.Count == 1);
  scanResponse.Items.contains({id: "1", body: "hello"});
}
