bring sim;
bring util;
bring cloud;
bring "./dynamodb-types.w" as dynamodb_types;
bring "./dynamodb-client.w" as dynamodb_client;

interface Client {
  inflight createTable(input: Json): Json;
  inflight deleteTable(input: Json): Json;
  inflight updateTimeToLive(input: Json): Json;
}

class Util {
  extern "./dynamodb.mjs" pub static inflight getPort(): num;
  extern "./dynamodb.mjs" pub static inflight createClient(options: dynamodb_types.ClientConfig): Client;
  extern "./dynamodb.mjs" pub static inflight processRecordsAsync(
    endpoint: str,
    tableName: str,
    handler: inflight (dynamodb_types.StreamRecord): void,
    options: dynamodb_types.StreamConsumerOptions?,
  ): void;
}

class Host {
  pub endpoint: str;

  new() {
    let container = new sim.Container(
      name: "winglibs-dynamodb",
      image: "amazon/dynamodb-local",
      containerPort: 8000,
    );

    this.endpoint = "http://localhost:{container.hostPort!}";
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
  pub tableName: str;
  pub connection: dynamodb_types.Connection;

  new(props: dynamodb_types.TableProps) {
    // Ideally, we would reuse the same host (and container) for all tables in
    // the same application, but there seems to be a bug somewhere that prevents
    // INSERT events from being processed when there's more than one table in
    // the application.
    //
    // So, instead of `this.host = Host.of(this);`, we just:
    this.host = new Host();

    let tableName = props.name ?? this.node.addr;
    let state = new sim.State();
    this.tableName = state.token("tableName");

    let clientConfig = {
      endpoint: this.host.endpoint,
      region: "local",
      credentials: {
        accessKeyId: "local",
        secretAccessKey: "local",
      },
    };

    this.connection = {
      tableName: tableName,
      clientConfig: clientConfig
    };

    new cloud.Service(inflight () => {
      let client = Util.createClient(clientConfig);

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

      let globalSecondaryIndexes: Array<Json>? = (() => {
        if let globalSecondaryIndex = props.globalSecondaryIndex {
          let indexes = MutArray<Json> [];
          for gsi in globalSecondaryIndex {
            let keySchema = MutArray<Json> [];
            keySchema.push({
              AttributeName: gsi.hashKey,
              KeyType: "HASH",
            });
            if let rangeKey = gsi.rangeKey {
              keySchema.push({
                AttributeName: rangeKey,
                KeyType: "RANGE",
              });
            }

            let provisionedThroughput: Json? = (() => {
              if gsi.readCapacity? || gsi.writeCapacity? {
                return {
                  ReadCapacityUnits: gsi.readCapacity,
                  WriteCapacityUnits: gsi.writeCapacity,
                };
              }
              return nil;
            })();

            indexes.push({
              IndexName: gsi.name,
              KeySchema: keySchema.copy(),
              Projection: {
                ProjectionType: gsi.projectionType,
              },
              ProvisionedThroughput: provisionedThroughput,
            });
          }
          return indexes.copy();
        }
        return  nil;
      })();

      // delete the table if it already exists
      try { client.deleteTable({ TableName: tableName }); } 
      catch e { }

      util.waitUntil(() => {
        try {
          client.createTable({
            TableName: tableName,
            AttributeDefinitions: attributeDefinitions.copy(),
            KeySchema: keySchemas.copy(),
            GlobalSecondaryIndexes: globalSecondaryIndexes,
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

  pub setStreamConsumer(handler: inflight (dynamodb_types.StreamRecord): void, options: dynamodb_types.StreamConsumerOptions?) {
    new cloud.Service(inflight () => {
      Util.processRecordsAsync(this.host.endpoint, this.tableName, handler, options);
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
