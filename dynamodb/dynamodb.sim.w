bring sim;
bring util;
bring cloud;
bring "./dynamodb-types.w" as dynamodb_types;
bring "./dynamodb-client.w" as dynamodb_client;

inflight interface Client {
  inflight createTable(input: Json): Json;
  inflight deleteTable(input: Json): Json;
  inflight updateTimeToLive(input: Json): Json;
  inflight describeTable(input: Json): Json;
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
  extern "./dynamodb.mjs" pub static dirname(): str;
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
    let root = nodeof(scope).root;
    let rootNode = nodeof(root);
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
    this.host = Host.of(this);

    let tableName = props.name ?? nodeof(this).addr;
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
              if gsi.readCapacity != nil || gsi.writeCapacity != nil {
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
                NonKeyAttributes: gsi.nonKeyAttributes,
              },
              ProvisionedThroughput: provisionedThroughput,
            });
          }
          return indexes.copy();
        }
        return  nil;
      })();

      // delete the table if it already exists because we might be reusing the container
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

          // Wait until we can describe the table. This is
          // to ensure that the table is ready to be used.
          util.waitUntil(() => {
            try {
              client.describeTable({
                TableName: tableName,
              });
              return true;
            } catch error {
              return false;
            }
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
          // container might be starting up
          if error == "socket hang up" || error == "read ECONNRESET" {
            return false;
          }

          log(error);
          throw error;
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

  pub inflight update(options: dynamodb_types.UpdateOptions): dynamodb_types.UpdateOutput {
    return this.client.update(options);
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

  pub inflight readWriteConnection(): dynamodb_types.Connection {
    return this.connection;
  }
}
