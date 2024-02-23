bring sim;
bring util;
bring cloud;
bring ui;

interface Process {
	inflight kill(): void;
}

struct SpawnOptions {
	command: str;
  arguments: Array<str>;
  onData: inflight (str): void;
}

interface Client {
  inflight createTable(input: Json): Json;
  inflight deleteTable(input: Json): Json;
  inflight updateTimeToLive(input: Json): Json;
}

interface DocumentClient {
  inflight batchExecuteStatement(input: Json): Json;
  inflight batchGet(input: Json): Json;
  inflight batchWrite(input: Json): Json;
  inflight delete(input: Json): Json;
  inflight executeStatement(input: Json): Json;
  inflight executeTransaction(input: Json): Json;
  inflight get(input: Json): Json;
  inflight put(input: Json): Json;
  inflight query(input: Json): Json;
  inflight scan(input: Json): Json;
  inflight transactGet(input: Json): Json;
  inflight transactWrite(input: Json): Json;
  inflight update(input: Json): Json;
}

struct StreamRecordDynamodb {
  ApproximateCreationDateTime: str;
  Keys: Json;
  NewImage: Json?;
  OldImage: Json?;
  SequenceNumber: str;
  SizeBytes: num;
  StreamViewType: str;
}

struct StreamRecord {
  dynamodb: StreamRecordDynamodb;
  eventName: str;
  eventID: str;
}

class Util {
	extern "./lib.mjs" pub static inflight getPort(): num;
	extern "./lib.mjs" pub static inflight spawn(options: SpawnOptions): Process;
	extern "./lib.mjs" pub static inflight createClient(endpoint: str): Client;
	extern "./lib.mjs" pub static inflight createDocumentClient(endpoint: str): DocumentClient;
	extern "./lib.mjs" pub static inflight processRecordsAsync(endpoint: str, tableName: str, handler: inflight (StreamRecord): void): void;
}

class Host {
  pub endpoint: str;

  new() {
    let containerName = "winglibs-dynamodb-{util.uuidv4()}";

    let state = new sim.State();
    this.endpoint = state.token("endpoint");

    new cloud.Service(inflight () => {
      let port = Util.getPort();

      let docker = Util.spawn(
				command: "docker",
        arguments: [
          "run",
          "--rm",
          "--name",
          containerName,
          "-p",
          "{port}:8000",
          "amazon/dynamodb-local",
        ],
        onData: (data) => {
          if data.contains("Initializing DynamoDB Local with the following configuration") {
            state.set("endpoint", "http://0.0.0.0:{port}");
          }
        },
			);

			return () => {
				docker.kill();
			};
    });

    // The host will be ready when the endpoint is set.
    new cloud.Service(inflight () => {
      util.waitUntil(() => {
        return state.tryGet("endpoint")?;
      });
    }) as "Wait Until";

    // std.Node.of(this).hidden = true;
  }

  pub static of(scope: std.IResource): Host {
    let uid = "DynamodbHost-7JOQ92VWh6OavMXYpWx9O";
    let root = std.Node.of(scope).root;
    let rootNode = std.Node.of(root);
    return unsafeCast(rootNode.tryFindChild(uid)) ?? new Host() as uid in root;
  }
}

struct GetOptions {
  key: Json;
}

struct GetOutput {
  item: Json?;
}

struct PutOptions {
  item: Json;
  conditionExpression: str?;
  expressionAttributeNames: Map<str>?;
  expressionAttributeValues: Map<Json>?;
  // returnValues: str?;
  // returnValuesOnConditionCheckFailure: str?;
}

struct PutOutput {
  // attributes: Json?;
}

struct TransactWriteItemConditionCheck {
  key: Json;
  conditionExpression: str?;
  expressionAttributeNames: Map<str>?;
  expressionAttributeValues: Map<Json>?;
  returnValuesOnConditionCheckFailure: bool?;
}

struct TransactWriteItemPut {
  item: Json;
  conditionExpression: str?;
  expressionAttributeNames: Map<str>?;
  expressionAttributeValues: Map<Json>?;
  returnValuesOnConditionCheckFailure: bool?;
}

struct TransactWriteItemDelete {
  key: Json;
  conditionExpression: str?;
  expressionAttributeNames: Map<str>?;
  expressionAttributeValues: Map<Json>?;
  returnValuesOnConditionCheckFailure: bool?;
}

struct TransactWriteItemUpdate {
  key: Json;
  conditionExpression: str?;
  updateExpression: str?;
  expressionAttributeNames: Map<str>?;
  expressionAttributeValues: Map<Json>?;
  returnValuesOnConditionCheckFailure: bool?;
}

struct TransactWriteItem {
  conditionCheck: TransactWriteItemConditionCheck?;
  put: TransactWriteItemPut?;
  delete: TransactWriteItemDelete?;
  update: TransactWriteItemUpdate?;
}

struct TransactWriteOptions {
  transactItems: Array<TransactWriteItem>;
}

struct TransactWriteOutput {}

struct ScanOptions {
  consistentRead: bool?;
  exclusiveStartKey: Json?;
  expressionAttributeNames: Map<str>?;
  expressionAttributeValues: Map<Json>?;
  filterExpression: str?;
  indexName: str?;
  limit: num?;
  projectionExpression: str?;
  returnConsumedCapacity: str?;
  select: str?;
  segment: num?;
  totalSegments: num?;
}

struct ScanOutput {
  items: Array<Json>;
  count: num;
  scannedCount: num;
  lastEvaluatedKey: Json?;
  consumedCapacity: Json?;
}

struct QueryOptions {
  consistentRead: bool?;
  exclusiveStartKey: Json?;
  expressionAttributeNames: Map<str>?;
  expressionAttributeValues: Map<Json>?;
  filterExpression: str?;
  indexName: str?;
  keyConditionExpression: str;
  limit: num?;
  projectionExpression: str?;
  returnConsumedCapacity: str?;
  scanIndexForward: bool?;
  select: str?;
}

struct QueryOutput {
  items: Array<Json>;
  count: num;
  scannedCount: num;
  lastEvaluatedKey: Json?;
  consumedCapacity: Json?;
}

struct AttributeDefinition {
  attributeName: str;
  attributeType: str;
}

struct KeySchema {
  attributeName: str;
  keyType: str;
}

struct TableProps {
  attributeDefinitions: Array<AttributeDefinition>;
  keySchema: Array<KeySchema>;
  timeToLiveAttribute: str?;
}

pub class Table {
  host: Host;
  // var usesStreams: bool;

  tableName: str;

  new(props: TableProps) {
    this.host = Host.of(this);
    // this.usesStreams = false;

    let tableName = this.node.addr;
    let state = new sim.State();
    this.tableName = state.token("tableName");

    new ui.Field(
      "Key Schema",
      inflight () => {
        return Json.stringify(props.keySchema, indent: 2);
      },
    );

    new cloud.Service(inflight () => {
      let client = Util.createClient(this.host.endpoint);

      let attributeDefinitions = MutArray<Json> [];
      for attributeDefinition in props.attributeDefinitions {
        attributeDefinitions.push({
          AttributeName: attributeDefinition.attributeName,
          AttributeType: attributeDefinition.attributeType,
        });
      }

      let keySchemas = MutArray<Json> [];
      for keySchema in props.keySchema {
        keySchemas.push({
          AttributeName: keySchema.attributeName,
          KeyType: keySchema.keyType,
        });
      }

      util.waitUntil(() => {
        try {
          client.createTable({
            TableName: tableName,
            AttributeDefinitions: attributeDefinitions.copy(),
            KeySchema: keySchemas.copy(),
            BillingMode: "PAY_PER_REQUEST",
            StreamSpecification: {
              StreamEnabled: true,
              StreamViewType: "NEW_AND_OLD_IMAGES",
            },
          });

          if let timeToLiveAttribute = props.timeToLiveAttribute {
            client.updateTimeToLive({
              TableName: tableName,
              TimeToLiveSpecification: {
                AttributeName: timeToLiveAttribute,
                Enabled: true,
              },
            });
          }

          state.set("tableName", tableName);
          return true;
        } catch error {
          return false;
        }
      });

      // return () => {
      //   try {
      //     client.deleteTable({
      //       TableName: tableName,
      //     });
      //   } catch {}
      // };
    });
  }

  pub setStreamConsumer(handler: inflight (StreamRecord): void) {
    // if this.usesStreams {
    //   throw "Table.onStream can only be called once";
    // }
    // this.usesStreams = true;
    new cloud.Service(inflight () => {
      Util.processRecordsAsync(this.host.endpoint, this.tableName, handler);
    }) as "StreamConsumer";
  }

  inflight client: DocumentClient;

  inflight new() {
    this.client = Util.createDocumentClient(this.host.endpoint);
  }

  pub inflight get(options: GetOptions): GetOutput {
    let response = this.client.get({
      TableName: this.tableName,
      Key: options.key,
    });
    return {
      item: unsafeCast(response)?.Item,
    };
  }

  pub inflight put(options: PutOptions): PutOutput {
    let response = this.client.put({
      TableName: this.tableName,
      Item: options.item,
      ConditionExpression: options.conditionExpression,
      ExpressionAttributeNames: options.expressionAttributeNames,
      ExpressionAttributeValues: options.expressionAttributeValues,
    });
    return {};
  }

  pub inflight transactWrite(options: TransactWriteOptions): TransactWriteOutput {
    let transactItems = MutArray<Json> [];
    for item in options.transactItems {
      if let operation = item.conditionCheck {
        transactItems.push({
          ConditionCheck: {
            TableName: this.tableName,
            Key: operation.key,
            ConditionExpression: operation.conditionExpression,
            ExpressionAttributeNames: operation.expressionAttributeNames,
            ExpressionAttributeValues: operation.expressionAttributeValues,
            ReturnValuesOnConditionCheckFailure: operation.returnValuesOnConditionCheckFailure,
          },
        });
      } elif let operation = item.delete {
        transactItems.push({
          Delete: {
            TableName: this.tableName,
            Key: operation.key,
            ConditionExpression: operation.conditionExpression,
            ExpressionAttributeNames: operation.expressionAttributeNames,
            ExpressionAttributeValues: operation.expressionAttributeValues,
            ReturnValuesOnConditionCheckFailure: operation.returnValuesOnConditionCheckFailure,
          },
        });
      } elif let operation = item.put {
        transactItems.push({
          Put: {
            TableName: this.tableName,
            Item: operation.item,
            ConditionExpression: operation.conditionExpression,
            ExpressionAttributeNames: operation.expressionAttributeNames,
            ExpressionAttributeValues: operation.expressionAttributeValues,
            ReturnValuesOnConditionCheckFailure: operation.returnValuesOnConditionCheckFailure,
          },
        });
      } elif let operation = item.update {
        transactItems.push({
          Update: {
            TableName: this.tableName,
            Key: operation.key,
            ConditionExpression: operation.conditionExpression,
            ExpressionAttributeNames: operation.expressionAttributeNames,
            ExpressionAttributeValues: operation.expressionAttributeValues,
            ReturnValuesOnConditionCheckFailure: operation.returnValuesOnConditionCheckFailure,
          },
        });
      } else {
        throw "Invalid transact item";
      }
    }
    this.client.transactWrite({
      TransactItems: transactItems.copy(),
    });
    return {};
  }

  pub inflight scan(options: ScanOptions?): ScanOutput {
    let response = this.client.scan({
      TableName: this.tableName,
      ConsistentRead: options?.consistentRead,
      ExclusiveStartKey: options?.exclusiveStartKey,
      ExpressionAttributeNames: options?.expressionAttributeNames,
      ExpressionAttributeValues: options?.expressionAttributeValues,
      FilterExpression: options?.filterExpression,
      IndexName: options?.indexName,
      Limit: options?.limit,
      ProjectionExpression: options?.projectionExpression,
      ReturnConsumedCapacity: options?.returnConsumedCapacity,
      Select: options?.select,
      Segment: options?.segment,
      TotalSegments: options?.totalSegments,
    });
    return {
      items: unsafeCast(response)?.Items,
      count: unsafeCast(response)?.Count,
      scannedCount: unsafeCast(response)?.ScannedCount,
      lastEvaluatedKey: unsafeCast(response)?.LastEvaluatedKey,
      consumedCapacity: unsafeCast(response)?.ConsumedCapacity,
    };
  }

  pub inflight query(options: QueryOptions): QueryOutput {
    let response = this.client.query({
      TableName: this.tableName,
      ConsistentRead: options.consistentRead,
      ExclusiveStartKey: options.exclusiveStartKey,
      ExpressionAttributeNames: options.expressionAttributeNames,
      ExpressionAttributeValues: options.expressionAttributeValues,
      FilterExpression: options.filterExpression,
      IndexName: options.indexName,
      KeyConditionExpression: options.keyConditionExpression,
      Limit: options.limit,
      ProjectionExpression: options.projectionExpression,
      ReturnConsumedCapacity: options.returnConsumedCapacity,
      ScanIndexForward: options.scanIndexForward,
      Select: options.select,
    });
    return {
      items: unsafeCast(response)?.Items,
      count: unsafeCast(response)?.Count,
      scannedCount: unsafeCast(response)?.ScannedCount,
      lastEvaluatedKey: unsafeCast(response)?.LastEvaluatedKey,
      consumedCapacity: unsafeCast(response)?.ConsumedCapacity,
    };
  }
}
