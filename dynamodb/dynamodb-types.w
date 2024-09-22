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

/// `TableBatchGetOptions` is used as an input to the `batchGet` operation on a Table or Client
/// (through [`BatchGetOptions`](#@winglibs/dynamodb.BatchGetOptions)).
pub struct TableBatchGetOptions {
  Keys: Array<Json>;
  AttributesToGet: Array<str>?;
  ConsistentRead: bool?;
  ExpressionAttributeNames: Map<str>?;
  ProjectionExpression: str?;

  /// When passed in on a **Table** resource, `ReturnConsumedCapacity` will be hoisted to the top
  /// level inside of the request. When passed in on a **Client** resource (via
  /// [`BatchGetOptions`](#@winglibs/dynamodb.BatchGetOptions)), setting `ReturnConsumedCapacity`
  /// here has no effect, set it inside of the top-level instead.
  ReturnConsumedCapacity: str?;
}

/// Input to the `batchGet` operation on a Client.
pub struct BatchGetOptions {
  RequestItems: Map<TableBatchGetOptions>;
  ReturnConsumedCapacity: str?;
}

pub struct BatchGetOutput {
  UnprocessedKeys: Map<TableBatchGetOptions>;
  Responses: Map<Array<Json>>?;
  ConsumedCapacity: Array<Json>?;
}

/// Represents a request to perform a `DeleteItem` operation on an item.
pub struct DeleteRequest {
  /// `Key` is a map of attribute name to attribute values, representing the primary key of the item
  /// to delete. All of the table's primary key attributes must be specified
  Key: Json;
}

/// Represents a request to perform a `PutItem` operation on an item.
pub struct PutRequest {
  /// A map of attribute name to attribute values, representing the primary key of an item to be
  /// processed by PutItem. All of the table's primary key attributes must be specified, and their
  /// data types must match those of the table's key schema. If any attributes are present in the item
  /// that are part of an index key schema for the table, their types must match the index key
  /// schema.
  Item: Json;
}

/// Represents an operation to perform - either `DeleteItem` or `PutItem`. Used internally to map
/// from the `DeleteRequests` or `PutRequests` on `TableBatchWriteOptions` to the contract required
/// from DynamoDB.
pub struct WriteRequest {
  DeleteRequest: DeleteRequest?;
  PutRequest: PutRequest?;
}

/// `TableBatchWriteOptions` is used as an input to the `batchWrite` operation on a Table or Client
/// (through [`BatchWriteOptions`](#@winglibs/dynamodb.BatchWriteOptions)).
pub struct TableBatchWriteOptions {
  /// `DeleteRequests` contains a list of `DeleteItem` operations to perform on this table.
  DeleteRequests: Array<DeleteRequest>?;

  /// `PutRequests` contains a list of `PutItem` operations to perform on this table.
  PutRequests: Array<PutRequest>?;

  /// When passed in on a **Table** resource, `ReturnConsumedCapacity` will be hoisted to the top
  /// level inside of the request. When passed in on a **Client** resource (via
  /// [`BatchWriteOptions`](#@winglibs/dynamodb.BatchWriteOptions)), setting
  /// `ReturnConsumedCapacity` here has no effect, set it inside of the top-level instead.
  ReturnConsumedCapacity: str?;

  /// When passed in on a **Table** resource, `ReturnItemCollectionMetrics` will be hoisted to the
  /// top level inside of the request. When passed in on a **Client** resource (via
  /// [`BatchWriteOptions`](#@winglibs/dynamodb.BatchWriteOptions)), setting
  /// `ReturnConsumedCapacity` here has no effect, set it inside of the top-level instead.
  ReturnItemCollectionMetrics: str?;
}

/// Input to the `batchWrite` operation on a Client.
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
