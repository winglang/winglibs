bring sim;
bring util;
bring cloud;
bring ui;

pub struct StreamRecordDynamodb {
  approximateCreationDateTime: str;
  keys: Json;
  newImage: Json?;
  oldImage: Json?;
  sequenceNumber: str;
  sizeBytes: num;
  streamViewType: str;
}

pub struct StreamRecord {
  dynamodb: StreamRecordDynamodb;
  eventName: str;
  eventId: str;
}

pub struct DeleteOptions {
  key: Json;
  conditionExpression: str?;
  expressionAttributeNames: Map<str>?;
  expressionAttributeValues: Map<Json>?;
  returnValues: str?;
}

pub struct DeleteOutput {
  attributes: Json?;
}

pub struct GetOptions {
  key: Json;
  consistentRead: bool?;
  projectionExpression: str?;
  expressionAttributeNames: Map<str>?;
  expressionAttributeValues: Map<Json>?;
}

pub struct GetOutput {
  item: Json?;
}

pub struct PutOptions {
  item: Json;
  conditionExpression: str?;
  expressionAttributeNames: Map<str>?;
  expressionAttributeValues: Map<Json>?;
  returnValues: str?;
}

pub struct PutOutput {
  attributes: Json?;
}

pub struct QueryOptions {
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

pub struct QueryOutput {
  items: Array<Json>;
  count: num;
  scannedCount: num;
  lastEvaluatedKey: Json?;
  consumedCapacity: Json?;
}

pub struct ScanOptions {
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

pub struct ScanOutput {
  items: Array<Json>;
  count: num;
  scannedCount: num;
  lastEvaluatedKey: Json?;
  consumedCapacity: Json?;
}

pub struct TransactWriteItemConditionCheck {
  key: Json;
  conditionExpression: str?;
  expressionAttributeNames: Map<str>?;
  expressionAttributeValues: Map<Json>?;
  returnValuesOnConditionCheckFailure: bool?;
}

pub struct TransactWriteItemPut {
  item: Json;
  conditionExpression: str?;
  expressionAttributeNames: Map<str>?;
  expressionAttributeValues: Map<Json>?;
  returnValuesOnConditionCheckFailure: bool?;
}

pub struct TransactWriteItemDelete {
  key: Json;
  conditionExpression: str?;
  expressionAttributeNames: Map<str>?;
  expressionAttributeValues: Map<Json>?;
  returnValuesOnConditionCheckFailure: bool?;
}

pub struct TransactWriteItemUpdate {
  key: Json;
  conditionExpression: str?;
  updateExpression: str?;
  expressionAttributeNames: Map<str>?;
  expressionAttributeValues: Map<Json>?;
  returnValuesOnConditionCheckFailure: bool?;
}

pub struct TransactWriteItem {
  conditionCheck: TransactWriteItemConditionCheck?;
  put: TransactWriteItemPut?;
  delete: TransactWriteItemDelete?;
  update: TransactWriteItemUpdate?;
}

pub struct TransactWriteOptions {
  transactItems: Array<TransactWriteItem>;
}

pub struct TransactWriteOutput {}

pub struct AttributeDefinition {
  attributeName: str;
  attributeType: str;
}

pub struct KeySchema {
  attributeName: str;
  keyType: str;
}

pub struct TableProps {
  attributeDefinitions: Array<AttributeDefinition>;
  keySchema: Array<KeySchema>;
  timeToLiveAttribute: str?;
}

pub interface IClient {
  inflight delete(options: DeleteOptions): DeleteOutput;
  inflight get(options: GetOptions): GetOutput;
  inflight put(options: PutOptions): PutOutput;
  inflight query(options: QueryOptions): QueryOutput;
  inflight scan(options: ScanOptions?): ScanOutput;
  inflight transactWrite(options: TransactWriteOptions): TransactWriteOutput;
}

pub interface ITable extends IClient {
  setStreamConsumer(handler: inflight (StreamRecord): void): void;
}
