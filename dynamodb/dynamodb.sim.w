bring sim;
bring util;
bring cloud;
bring "./dynamodb-types.w" as dynamodb_types;
bring "./dynamodb-client.w" as dynamodb_client;

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

struct CreateClientOptions {
  endpoint: str;
  region: str;
  credentials: Json;
}

class Util {
  extern "./dynamodb.mjs" pub static inflight getPort(): num;
  extern "./dynamodb.mjs" pub static inflight spawn(options: SpawnOptions): Process;
  extern "./dynamodb.mjs" pub static inflight createClient(options: CreateClientOptions): Client;
  extern "./dynamodb.mjs" pub static inflight processRecordsAsync(endpoint: str, tableName: str, handler: inflight (dynamodb_types.StreamRecord): void): void;
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
    let host = unsafeCast(rootNode.tryFindChild(uid)) ?? new Host() as uid in root;
    nodeof(host).hidden = true;
    return host;
  }
}

pub class Table_sim impl dynamodb_types.ITable {
  host: Host;
  tableName: str;

  new(props: dynamodb_types.TableProps) {
    this.host = Host.of(this);

    let tableName = this.node.addr;
    let state = new sim.State();
    this.tableName = state.token("tableName");

    new cloud.Service(inflight () => {
      let client = Util.createClient({
        endpoint: this.host.endpoint,
        region: "local",
        credentials: {
          accessKeyId: "local",
          secretAccessKey: "local",
        },
      });

      let attributeDefinitions = MutArray<Json> [];
      for attributeDefinition in props.attributes {
        attributeDefinitions.push({
          AttributeName: attributeDefinition.name,
          AttributeType: attributeDefinition.type,
        });
      }

      let keySchemas = MutArray<Json> [];
      keySchemas.push({
        AttributeName: props.hashKey,
        KeyType: "HASH",
      });
      if let rangeKey = props.rangeKey {
        keySchemas.push({
          AttributeName: rangeKey,
          KeyType: "RANGE",
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
    });
  }

  pub connection(): dynamodb_types.Connection {
    return {
      endpoint: this.host.endpoint,
      tableName: this.tableName,
    };
  }

  pub setStreamConsumer(handler: inflight (dynamodb_types.StreamRecord): void) {
    new cloud.Service(inflight () => {
      Util.processRecordsAsync(this.host.endpoint, this.tableName, handler);
    }) as "StreamConsumer";
  }

  inflight client: dynamodb_types.IClient;

  inflight new() {
    this.client = new dynamodb_client.Client(
      tableName: this.tableName,
      endpoint: this.host.endpoint,
      region: "local",
      credentials: {
        accessKeyId: "local",
        secretAccessKey: "local",
      },
    );
  }

  pub inflight delete(options: dynamodb_types.DeleteOptions): dynamodb_types.DeleteOutput {
    return this.client.delete(options);
  }

  pub inflight get(options: dynamodb_types.GetOptions): dynamodb_types.GetOutput {
    return this.client.get(options);
  }

  pub inflight put(options: dynamodb_types.PutOptions): dynamodb_types.PutOutput {
    return this.client.put(options);
  }

  pub inflight transactWrite(options: dynamodb_types.TransactWriteOptions): dynamodb_types.TransactWriteOutput {
    return this.client.transactWrite(options);
  }

  pub inflight scan(options: dynamodb_types.ScanOptions?): dynamodb_types.ScanOutput {
    return this.client.scan(options);
  }

  pub inflight query(options: dynamodb_types.QueryOptions): dynamodb_types.QueryOutput {
    return this.client.query(options);
  }
}
