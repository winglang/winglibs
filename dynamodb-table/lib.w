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

class Util {
	extern "./lib.mjs" pub static inflight getPort(): num;
	extern "./lib.mjs" pub static inflight spawn(options: SpawnOptions): Process;
	extern "./lib.mjs" pub static inflight createClient(endpoint: str): Client;
	extern "./lib.mjs" pub static inflight createDocumentClient(endpoint: str): DocumentClient;
	extern "./lib.mjs" pub static inflight processRecordsAsync(endpoint: str, tableName: str, handler: inflight (Json): void): void;
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
  }

  pub static of(scope: std.IResource): Host {
    let uid = "DynamodbHost-7JOQ92VWh6OavMXYpWx9O";
    let root = std.Node.of(scope).root;
    let rootNode = std.Node.of(root);
    // return unsafeCast(rootNode.tryFindChild(uid)) ?? new Host() as uid in root;
    let def = unsafeCast(rootNode.tryFindChild("Default"));
    let defNode = std.Node.of(def);
    return unsafeCast(defNode.tryFindChild(uid)) ?? new Host() as uid in def;
  }
}

struct GetOptions {
  key: Json;
}

struct PutOptions {
  item: Json;
}

struct TransactWriteItemConditionCheck {
  key: Json;
  conditionExpression: str?;
  expressionAttributeNames: Json?;
  expressionAttributeValues: Json?;
  returnValuesOnConditionCheckFailure: bool?;
}

struct TransactWriteItemPut {
  item: Json;
  conditionExpression: str?;
  expressionAttributeNames: Json?;
  expressionAttributeValues: Json?;
  returnValuesOnConditionCheckFailure: bool?;
}

struct TransactWriteItemDelete {
  key: Json;
  conditionExpression: str?;
  expressionAttributeNames: Json?;
  expressionAttributeValues: Json?;
  returnValuesOnConditionCheckFailure: bool?;
}

struct TransactWriteItemUpdate {
  key: Json;
  conditionExpression: str?;
  expressionAttributeNames: Json?;
  expressionAttributeValues: Json?;
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
}

pub class Table {
  host: Host;

  tableName: str;

  new(props: TableProps) {
    this.host = Host.of(this);

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
              StreamViewType: "NEW_IMAGE",
            },
          });
          state.set("tableName", tableName);
          return true;
        } catch error {
          return false;
        }
      });

      return () => {
        try {
          client.deleteTable({
            TableName: tableName,
          });
        } catch {}
      };
    });
  }

  pub onStream(handler: inflight (Json): void) {
    new cloud.Service(inflight () => {
      Util.processRecordsAsync(this.host.endpoint, this.tableName, handler);
    }) as "OnStreamHandler";
  }

  inflight client: DocumentClient;

  inflight new() {
    this.client = Util.createDocumentClient(this.host.endpoint);
  }

  pub inflight get(options: GetOptions): Json {
    return this.client.get({
      TableName: this.tableName,
      Key: options.key,
    });
  }

  pub inflight put(options: PutOptions): Json {
    return this.client.put({
      TableName: this.tableName,
      Item: options.item,
    });
  }

  pub inflight transactWrite(options: TransactWriteOptions): Json {
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
    return this.client.transactWrite({
      TransactItems: transactItems.copy(),
    });
  }
}
