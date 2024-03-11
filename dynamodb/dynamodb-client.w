bring sim;
bring util;
bring cloud;
bring ui;
bring "./dynamodb-types.w" as dynamodb_types;

interface DocumentClient {
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

class Util {
  extern "./dynamodb.mjs" pub static inflight createDocumentClient(endpoint: str): DocumentClient;
}

pub struct ClientProps {
  endpoint: str;
  tableName: str;
}

pub inflight class Client impl dynamodb_types.IClient {
  inflight tableName: str;
  inflight client: DocumentClient;

  inflight new(props: ClientProps) {
    this.tableName = props.tableName;
    this.client = Util.createDocumentClient(props.endpoint);
  }

  pub inflight delete(options: dynamodb_types.DeleteOptions): dynamodb_types.DeleteOutput {
    let response = this.client.delete({
      TableName: this.tableName,
      Key: options.key,
      ConditionExpression: options.conditionExpression,
      ExpressionAttributeNames: options.expressionAttributeNames,
      ExpressionAttributeValues: options.expressionAttributeValues,
      ReturnValues: options.returnValues,
    });
    return {
      attributes: unsafeCast(response)?.Attributes,
    };
  }

  pub inflight get(options: dynamodb_types.GetOptions): dynamodb_types.GetOutput {
    let response = this.client.get({
      TableName: this.tableName,
      Key: options.key,
    });
    return {
      item: unsafeCast(response)?.Item,
    };
  }

  pub inflight put(options: dynamodb_types.PutOptions): dynamodb_types.PutOutput {
    let response = this.client.put({
      TableName: this.tableName,
      Item: options.item,
      ConditionExpression: options.conditionExpression,
      ExpressionAttributeNames: options.expressionAttributeNames,
      ExpressionAttributeValues: options.expressionAttributeValues,
      ReturnValues: options.returnValues,
    });
    return {
      attributes: unsafeCast(response)?.Attributes,
    };
  }

  pub inflight transactWrite(options: dynamodb_types.TransactWriteOptions): dynamodb_types.TransactWriteOutput {
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
            UpdateExpression: operation.updateExpression,
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

  pub inflight scan(options: dynamodb_types.ScanOptions?): dynamodb_types.ScanOutput {
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

  pub inflight query(options: dynamodb_types.QueryOptions): dynamodb_types.QueryOutput {
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
