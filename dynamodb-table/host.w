bring sim;
bring util;
bring cloud;

interface Process {
	inflight kill(): void;
}

struct SpawnOptions {
	command: str;
  arguments: Array<str>;
  onData: inflight (str): void;
}

interface Client {
  inflight batchExecuteStatement(options: Json): Json;
  inflight batchGetItem(options: Json): Json;
  inflight batchWriteItem(options: Json): Json;
  inflight createBackup(options: Json): Json;
  inflight createGlobalTable(options: Json): Json;
  inflight createTable(options: Json): Json;
  inflight deleteBackup(options: Json): Json;
  inflight deleteItem(options: Json): Json;
  inflight deleteTable(options: Json): Json;
  inflight describeBackup(options: Json): Json;
  inflight describeContinuousBackups(options: Json): Json;
  inflight describeContributorInsights(options: Json): Json;
  inflight describeExport(options: Json): Json;
  inflight describeGlobalTable(options: Json): Json;
  inflight describeGlobalTableSettings(options: Json): Json;
  inflight describeImport(options: Json): Json;
  inflight describeKinesisStreamingDestination(options: Json): Json;
  inflight describeLimits(options: Json): Json;
  inflight describeTable(options: Json): Json;
  inflight describeTableReplicaAutoScaling(options: Json): Json;
  inflight describeTimeToLive(options: Json): Json;
  inflight disableKinesisStreamingDestination(options: Json): Json;
  inflight enableKinesisStreamingDestination(options: Json): Json;
  inflight executeStatement(options: Json): Json;
  inflight executeTransaction(options: Json): Json;
  inflight exportTableToPointInTime(options: Json): Json;
  inflight getItem(options: Json): Json;
  inflight importTable(options: Json): Json;
  inflight listBackups(options: Json): Json;
  inflight listContributorInsights(options: Json): Json;
  inflight listExports(options: Json): Json;
  inflight listGlobalTables(options: Json): Json;
  inflight listImports(options: Json): Json;
  inflight listTables(options: Json): Json;
  inflight listTagsOfResource(options: Json): Json;
  inflight putItem(options: Json): Json;
  inflight query(options: Json): Json;
  inflight restoreTableFromBackup(options: Json): Json;
  inflight restoreTableToPointInTime(options: Json): Json;
  inflight scan(options: Json): Json;
  inflight tagResource(options: Json): Json;
  inflight transactGetItems(options: Json): Json;
  inflight transactWriteItems(options: Json): Json;
  inflight untagResource(options: Json): Json;
  inflight updateContinuousBackups(options: Json): Json;
  inflight updateContributorInsights(options: Json): Json;
  inflight updateGlobalTable(options: Json): Json;
  inflight updateGlobalTableSettings(options: Json): Json;
  inflight updateItem(options: Json): Json;
  inflight updateTable(options: Json): Json;
  inflight updateTableReplicaAutoScaling(options: Json): Json;
  inflight updateTimeToLive(options: Json): Json;
}

class Util {
	extern "./host.mjs" pub static inflight getPort(): num;
	extern "./host.mjs" pub static inflight spawn(options: SpawnOptions): Process;
	extern "./host.mjs" pub static inflight createClient(endpoint: str): Client;
	// extern "./host.mjs" pub static inflight createStreamsClient(endpoint: str): Client;
	extern "./host.mjs" pub static inflight processRecordsAsync(endpoint: str, tableName: str): void;
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

struct GetItemOptions {
  key: Json;
}

struct PutItemOptions {
  item: Json;
}

pub class Table {
  host: Host;

  tableName: str;

  new() {
    this.host = Host.of(this);

    let tableName = this.node.addr;
    let state = new sim.State();
    this.tableName = state.token("tableName");

    new cloud.Service(inflight () => {
      util.waitUntil(() => {
        try {
          let client = Util.createClient(this.host.endpoint);
          client.createTable({
            TableName: tableName,
            AttributeDefinitions: [
              {
                AttributeName: "id",
                AttributeType: "S",
              },
            ],
            KeySchema: [
              {
                AttributeName: "id",
                KeyType: "HASH",
              },
            ],
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
    });
  }

  inflight client: Client;

  inflight new() {
    this.client = Util.createClient(this.host.endpoint);
  }

  pub inflight getItem(options: GetItemOptions): Json {
    return this.client.getItem({
      TableName: this.tableName,
      Key: options.key,
    });
  }

  pub inflight putItem(options: PutItemOptions): Json {
    return this.client.putItem({
      TableName: this.tableName,
      Item: options.item,
    });
  }

  pub inflight processStreamRecords() {
    Util.processRecordsAsync(this.host.endpoint, this.tableName);
  }
}
