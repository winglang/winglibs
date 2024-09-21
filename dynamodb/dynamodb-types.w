pub struct StreamRecordDynamodb {
  ApproximateCreationDateTime: str;
  Keys: Json;
  NewImage: Json?;
  OldImage: Json?;
  SequenceNumber: str;
  SizeBytes: num;
  StreamViewType: str;
}

pub struct StreamRecord {
  dynamodb: StreamRecordDynamodb;
  eventName: str;
  eventID: str;
}

pub struct DeleteOptions {
  Key: Json;
  ConditionExpression: str?;
  ExpressionAttributeNames: Map<str>?;
  ExpressionAttributeValues: Map<Json>?;
  ReturnValues: str?;
}

pub struct DeleteOutput {
  Attributes: Json?;
}

pub struct GetOptions {
  Key: Json;
  ConsistentRead: bool?;
  ProjectionExpression: str?;
  ExpressionAttributeNames: Map<str>?;
  ExpressionAttributeValues: Map<Json>?;
}

pub struct GetOutput {
  Item: Json?;
}

pub struct PutOptions {
  Item: Json;
  ConditionExpression: str?;
  ExpressionAttributeNames: Map<str>?;
  ExpressionAttributeValues: Map<Json>?;
  ReturnValues: str?;
}

pub struct UpdateOptions {
  Key: Json;
  ReturnValues: str?;
  ReturnConsumedCapacity: str?;
  UpdateExpression: str;
  ConditionExpression: str?;
  ExpressionAttributeNames: Map<str>?;
  ExpressionAttributeValues: Map<Json>?;
}

pub struct PutOutput {
  Attributes: Json?;
}
pub struct UpdateOutput extends PutOptions {}

pub struct QueryOptions {
  ConsistentRead: bool?;
  ExclusiveStartKey: Json?;
  ExpressionAttributeNames: Map<str>?;
  ExpressionAttributeValues: Map<Json>?;
  FilterExpression: str?;
  IndexName: str?;
  KeyConditionExpression: str;
  Limit: num?;
  ProjectionExpression: str?;
  ReturnConsumedCapacity: str?;
  ScanIndexForward: bool?;
  Select: str?;
}

pub struct QueryOutput {
  Items: Array<Json>;
  Count: num;
  ScannedCount: num;
  LastEvaluatedKey: Json?;
  ConsumedCapacity: Json?;
}

pub struct ScanOptions {
  ConsistentRead: bool?;
  ExclusiveStartKey: Json?;
  ExpressionAttributeNames: Map<str>?;
  ExpressionAttributeValues: Map<Json>?;
  FilterExpression: str?;
  IndexName: str?;
  Limit: num?;
  ProjectionExpression: str?;
  ReturnConsumedCapacity: str?;
  Select: str?;
  Segment: num?;
  TotalSegments: num?;
}

pub struct ScanOutput {
  Items: Array<Json>;
  Count: num;
  ScannedCount: num;
  LastEvaluatedKey: Json?;
  ConsumedCapacity: Json?;
}

pub struct TransactWriteItemConditionCheck {
  Key: Json;
  ConditionExpression: str?;
  ExpressionAttributeNames: Map<str>?;
  ExpressionAttributeValues: Map<Json>?;
  ReturnValuesOnConditionCheckFailure: bool?;
}

pub struct TransactWriteItemPut {
  Item: Json;
  ConditionExpression: str?;
  ExpressionAttributeNames: Map<str>?;
  ExpressionAttributeValues: Map<Json>?;
  ReturnValuesOnConditionCheckFailure: bool?;
}

pub struct TransactWriteItemDelete {
  Key: Json;
  ConditionExpression: str?;
  ExpressionAttributeNames: Map<str>?;
  ExpressionAttributeValues: Map<Json>?;
  ReturnValuesOnConditionCheckFailure: bool?;
}

pub struct TransactWriteItemUpdate {
  Key: Json;
  ConditionExpression: str?;
  UpdateExpression: str?;
  ExpressionAttributeNames: Map<str>?;
  ExpressionAttributeValues: Map<Json>?;
  ReturnValuesOnConditionCheckFailure: bool?;
}

pub struct TransactWriteItem {
  ConditionCheck: TransactWriteItemConditionCheck?;
  Put: TransactWriteItemPut?;
  Delete: TransactWriteItemDelete?;
  Update: TransactWriteItemUpdate?;
}

pub struct TransactWriteOptions {
  TransactItems: Array<TransactWriteItem>;
}

pub struct TransactWriteOutput {}

pub struct TableBatchGetOptions {
  Keys: Array<Json>;
  AttributesToGet: Array<str>?;
  ConsistentRead: bool?;
  ExpressionAttributeNames: Map<str>?;
  ProjectionExpression: str?;
  ReturnConsumedCapacity: str?;
}

pub struct BatchGetOptions {
  RequestItems: Map<TableBatchGetOptions>;
  ReturnConsumedCapacity: str?;
}

pub struct BatchGetOutput {
  UnprocessedKeys: Map<TableBatchGetOptions>;
  Responses: Map<Array<Json>>?;
  ConsumedCapacity: Array<Json>?;
}

pub struct DeleteRequest {
  Key: Json;
}

pub struct PutRequest {
  Item: Json;
}

pub struct WriteRequest {
  DeleteRequest: DeleteRequest?;
  PutRequest: PutRequest?;
}

pub struct TableBatchWriteOptions {
  DeleteRequests: Array<DeleteRequest>?;
  PutRequests: Array<PutRequest>?;
  ReturnConsumedCapacity: str?;
  ReturnItemCollectionMetrics: str?;
}

pub struct BatchWriteOptions {
  RequestItems: Map<TableBatchWriteOptions>;
  ReturnConsumedCapacity: str?;
  ReturnItemCollectionMetrics: str?;
}

pub struct BatchWriteOutput {
  UnprocessedItems: Map<TableBatchWriteOptions>?;
  ItemCollectionMetrics: Json?;
  ConsumedCapacity: Array<Json>?;
}

pub struct AttributeDefinition {
  name: str;
  type: str;
}

pub struct GlobalSecondaryIndex {
    hashKey: str;
    name: str;
    nonKeyAttributes: Array<str>?;
    projectionType: str;
    rangeKey: str?;
    readCapacity: num?;
    writeCapacity: num?;
}

// pub struct StreamFilterPattern {
//   pattern: str;
// }

// pub struct StreamFilterCriteria {
//   filter: Array<StreamFilterPattern>;
// }

pub struct StreamConsumerOptions {
  // filterCriteria: StreamFilterCriteria?;
  batchSize: num?;
  startingPosition: str?;
}

pub enum BillingMode {
  PAY_PER_REQUEST,
  PROVISIONED
}

pub struct TableProps {
  name: str?;
  attributes: Array<AttributeDefinition>;
  hashKey: str;
  rangeKey: str?;
  timeToLiveAttribute: str?;
  globalSecondaryIndex: Array<GlobalSecondaryIndex>?;
  pointInTimeRecovery: bool?;

  /// Billing mode for the table. Defaults to `PAY_PER_REQUEST`.
  billingMode: BillingMode?;

  /// Enables deletion protection for table. Disabled by default.
  ///
  /// For the Terraform AWS provider, this will also enable `lifecycle { prevent_destroy = true }`
  deletionProtection: bool?;
}

pub struct Credentials {
  accessKeyId: str;
  secretAccessKey: str;
}

pub struct ClientConfig {
  endpoint: str;
  region: str;
  credentials: Credentials;
}

pub struct Connection {
  tableName: str;
  clientConfig: ClientConfig?;
}

pub inflight interface IDynamoResource {
  inflight delete(options: DeleteOptions): DeleteOutput;
  inflight get(options: GetOptions): GetOutput;
  inflight put(options: PutOptions): PutOutput;
  inflight update(options: UpdateOptions): UpdateOutput;
  inflight query(options: QueryOptions): QueryOutput;
  inflight scan(options: ScanOptions?): ScanOutput;
  inflight transactWrite(options: TransactWriteOptions): TransactWriteOutput;
}

pub inflight interface IClient extends IDynamoResource {
  inflight batchGet(options: BatchGetOptions): BatchGetOutput;
  inflight batchWrite(options: BatchWriteOptions): BatchWriteOutput;
}

pub interface ITable extends IDynamoResource, std.IResource {
  setStreamConsumer(handler: inflight (StreamRecord): void, options: StreamConsumerOptions?): void;
  inflight readWriteConnection(): Connection;
  inflight batchGet(options: TableBatchGetOptions): BatchGetOutput;
  inflight batchWrite(options: TableBatchWriteOptions): BatchWriteOutput;
}
