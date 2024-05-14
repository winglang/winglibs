bring "./dynamodb-types.w" as dynamodb_types;

inflight interface DocumentClient {
  inflight batchGet(input: Json): Json;
  inflight batchWrite(input: Json): Json;
  inflight delete(input: Json): Json;
  inflight get(input: Json): Json;
  inflight put(input: Json): Json;
  inflight query(input: Json): Json;
  inflight scan(input: Json): Json;
  inflight transactGet(input: Json): Json;
  inflight transactWrite(input: Json): Json;
  inflight update(input: Json): Json;
}

struct CreateDocumentClientOptions {
  endpoint: str?;
  region: str?;
  credentials: dynamodb_types.Credentials?;
}

class Util {
  extern "./dynamodb.mjs" pub static inflight createDocumentClient(options: CreateDocumentClientOptions?): DocumentClient;
}

pub struct ClientProps {
  tableName: str;
  endpoint: str?;
  region: str?;
  credentials: dynamodb_types.Credentials?;
}

pub inflight class Client impl dynamodb_types.IClient {
  inflight tableName: str;
  inflight client: DocumentClient;

  inflight new(props: ClientProps) {
    this.tableName = props.tableName;
    this.client = Util.createDocumentClient({
      region: props.region,
      credentials: props.credentials,
      endpoint: props.endpoint,
    });
  }

  pub inflight delete(options: dynamodb_types.DeleteOptions): dynamodb_types.DeleteOutput {
    let input: MutJson = options;
    input.set("TableName", this.tableName);
    return unsafeCast(this.client.delete(input));
  }

  pub inflight get(options: dynamodb_types.GetOptions): dynamodb_types.GetOutput {
    let input: MutJson = options;
    input.set("TableName", this.tableName);
    return unsafeCast(this.client.get(input));
  }

  pub inflight put(options: dynamodb_types.PutOptions): dynamodb_types.PutOutput {
    let input: MutJson = options;
    input.set("TableName", this.tableName);
    return unsafeCast(this.client.put(input));
  }

  pub inflight transactWrite(options: dynamodb_types.TransactWriteOptions): dynamodb_types.TransactWriteOutput {
    let transactItems = MutArray<Json> [];
    for item in options.TransactItems {
      if let operation = item.ConditionCheck {
        let input: MutJson = operation;
        input.set("TableName", this.tableName);
        transactItems.push({
          ConditionCheck: Json.deepCopy(input),
        });
      } elif let operation = item.Delete {
        let input: MutJson = operation;
        input.set("TableName", this.tableName);
        transactItems.push({
          Delete: Json.deepCopy(input),
        });
      } elif let operation = item.Put {
        let input: MutJson = operation;
        input.set("TableName", this.tableName);
        transactItems.push({
          Put: Json.deepCopy(input),
        });
      } elif let operation = item.Update {
        let input: MutJson = operation;
        input.set("TableName", this.tableName);
        transactItems.push({
          Update: Json.deepCopy(input),
        });
      } else {
        throw "Invalid transact item";
      }
    }
    return unsafeCast(this.client.transactWrite({
      TransactItems: transactItems.copy(),
    }));
  }

  pub inflight scan(options: dynamodb_types.ScanOptions?): dynamodb_types.ScanOutput {
    let input: MutJson = options ?? {};
    input.set("TableName", this.tableName);
    return unsafeCast(this.client.scan(input));
  }

  pub inflight query(options: dynamodb_types.QueryOptions): dynamodb_types.QueryOutput {
    let input: MutJson = options;
    input.set("TableName", this.tableName);
    return unsafeCast(this.client.query(input));
  }
}
