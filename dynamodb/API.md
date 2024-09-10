## API Reference

### Table of Contents

- **Classes**
  - <a href="#@winglibs/dynamodb.Table">Table</a>
  - <a href="#@winglibs/dynamodb.Table_tfaws">Table_tfaws</a>
  - <a href="#@winglibs/dynamodb.Table_sim">Table_sim</a>
  - <a href="#@winglibs/dynamodb.Client">Client</a>
- **Interfaces**
  - <a href="#@winglibs/dynamodb.IClient">IClient</a>
  - <a href="#@winglibs/dynamodb.ITable">ITable</a>
- **Structs**
  - <a href="#@winglibs/dynamodb.AttributeDefinition">AttributeDefinition</a>
  - <a href="#@winglibs/dynamodb.ClientConfig">ClientConfig</a>
  - <a href="#@winglibs/dynamodb.Connection">Connection</a>
  - <a href="#@winglibs/dynamodb.Credentials">Credentials</a>
  - <a href="#@winglibs/dynamodb.DeleteOptions">DeleteOptions</a>
  - <a href="#@winglibs/dynamodb.DeleteOutput">DeleteOutput</a>
  - <a href="#@winglibs/dynamodb.GetOptions">GetOptions</a>
  - <a href="#@winglibs/dynamodb.GetOutput">GetOutput</a>
  - <a href="#@winglibs/dynamodb.GlobalSecondaryIndex">GlobalSecondaryIndex</a>
  - <a href="#@winglibs/dynamodb.PutOptions">PutOptions</a>
  - <a href="#@winglibs/dynamodb.PutOutput">PutOutput</a>
  - <a href="#@winglibs/dynamodb.QueryOptions">QueryOptions</a>
  - <a href="#@winglibs/dynamodb.QueryOutput">QueryOutput</a>
  - <a href="#@winglibs/dynamodb.ScanOptions">ScanOptions</a>
  - <a href="#@winglibs/dynamodb.ScanOutput">ScanOutput</a>
  - <a href="#@winglibs/dynamodb.StreamConsumerOptions">StreamConsumerOptions</a>
  - <a href="#@winglibs/dynamodb.StreamRecord">StreamRecord</a>
  - <a href="#@winglibs/dynamodb.StreamRecordDynamodb">StreamRecordDynamodb</a>
  - <a href="#@winglibs/dynamodb.TableProps">TableProps</a>
  - <a href="#@winglibs/dynamodb.TransactWriteItem">TransactWriteItem</a>
  - <a href="#@winglibs/dynamodb.TransactWriteItemConditionCheck">TransactWriteItemConditionCheck</a>
  - <a href="#@winglibs/dynamodb.TransactWriteItemDelete">TransactWriteItemDelete</a>
  - <a href="#@winglibs/dynamodb.TransactWriteItemPut">TransactWriteItemPut</a>
  - <a href="#@winglibs/dynamodb.TransactWriteItemUpdate">TransactWriteItemUpdate</a>
  - <a href="#@winglibs/dynamodb.TransactWriteOptions">TransactWriteOptions</a>
  - <a href="#@winglibs/dynamodb.TransactWriteOutput">TransactWriteOutput</a>
  - <a href="#@winglibs/dynamodb.UpdateOptions">UpdateOptions</a>
  - <a href="#@winglibs/dynamodb.UpdateOutput">UpdateOutput</a>
  - <a href="#@winglibs/dynamodb.ClientProps">ClientProps</a>
- **Enums**
  - <a href="#@winglibs/dynamodb.BillingMode">BillingMode</a>

### Table (preflight class) <a class="wing-docs-anchor" id="@winglibs/dynamodb.Table"></a>

*No description*

#### Constructor

```
new(props: TableProps): Table
```

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>connection</code> | <code>Connection</code> | *No description* |
| <code>tableName</code> | <code>str</code> | *No description* |

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight delete(options: DeleteOptions): DeleteOutput</code> | *No description* |
| <code>inflight get(options: GetOptions): GetOutput</code> | *No description* |
| <code>inflight put(options: PutOptions): PutOutput</code> | *No description* |
| <code>inflight query(options: QueryOptions): QueryOutput</code> | *No description* |
| <code>inflight readWriteConnection(): Connection</code> | *No description* |
| <code>inflight scan(options: ScanOptions?): ScanOutput</code> | *No description* |
| <code>setStreamConsumer(handler: inflight (StreamRecord): void, opts: StreamConsumerOptions?): void</code> | *No description* |
| <code>inflight transactWrite(options: TransactWriteOptions): TransactWriteOutput</code> | *No description* |
| <code>inflight update(options: UpdateOptions): UpdateOutput</code> | *No description* |

### Table_tfaws (preflight class) <a class="wing-docs-anchor" id="@winglibs/dynamodb.Table_tfaws"></a>

*No description*

#### Constructor

```
new(props: TableProps): Table_tfaws
```

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>connection</code> | <code>Connection</code> | *No description* |
| <code>tableName</code> | <code>str</code> | *No description* |

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight delete(options: DeleteOptions): DeleteOutput</code> | *No description* |
| <code>inflight get(options: GetOptions): GetOutput</code> | *No description* |
| <code>inflight put(options: PutOptions): PutOutput</code> | *No description* |
| <code>inflight query(options: QueryOptions): QueryOutput</code> | *No description* |
| <code>inflight readWriteConnection(): Connection</code> | *No description* |
| <code>inflight scan(options: ScanOptions?): ScanOutput</code> | *No description* |
| <code>setStreamConsumer(handler: inflight (StreamRecord): void, options: StreamConsumerOptions?): void</code> | *No description* |
| <code>inflight transactWrite(options: TransactWriteOptions): TransactWriteOutput</code> | *No description* |
| <code>inflight update(options: UpdateOptions): UpdateOutput</code> | *No description* |

### Table_sim (preflight class) <a class="wing-docs-anchor" id="@winglibs/dynamodb.Table_sim"></a>

*No description*

#### Constructor

```
new(props: TableProps): Table_sim
```

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>connection</code> | <code>Connection</code> | *No description* |
| <code>tableName</code> | <code>str</code> | *No description* |

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight delete(options: DeleteOptions): DeleteOutput</code> | *No description* |
| <code>inflight get(options: GetOptions): GetOutput</code> | *No description* |
| <code>inflight put(options: PutOptions): PutOutput</code> | *No description* |
| <code>inflight query(options: QueryOptions): QueryOutput</code> | *No description* |
| <code>inflight readWriteConnection(): Connection</code> | *No description* |
| <code>inflight scan(options: ScanOptions?): ScanOutput</code> | *No description* |
| <code>setStreamConsumer(handler: inflight (StreamRecord): void, options: StreamConsumerOptions?): void</code> | *No description* |
| <code>inflight transactWrite(options: TransactWriteOptions): TransactWriteOutput</code> | *No description* |
| <code>inflight update(options: UpdateOptions): UpdateOutput</code> | *No description* |

### Client (inflight class) <a class="wing-docs-anchor" id="@winglibs/dynamodb.Client"></a>

*No description*

#### Constructor

```
new(): Client
```

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight delete(options: DeleteOptions): DeleteOutput</code> | *No description* |
| <code>inflight get(options: GetOptions): GetOutput</code> | *No description* |
| <code>inflight put(options: PutOptions): PutOutput</code> | *No description* |
| <code>inflight query(options: QueryOptions): QueryOutput</code> | *No description* |
| <code>inflight scan(options: ScanOptions?): ScanOutput</code> | *No description* |
| <code>inflight transactWrite(options: TransactWriteOptions): TransactWriteOutput</code> | *No description* |
| <code>inflight update(options: UpdateOptions): UpdateOutput</code> | *No description* |

### IClient (interface) <a class="wing-docs-anchor" id="@winglibs/dynamodb.IClient"></a>

*No description*

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight delete(options: DeleteOptions): DeleteOutput</code> | *No description* |
| <code>inflight get(options: GetOptions): GetOutput</code> | *No description* |
| <code>inflight put(options: PutOptions): PutOutput</code> | *No description* |
| <code>inflight query(options: QueryOptions): QueryOutput</code> | *No description* |
| <code>inflight scan(options: ScanOptions?): ScanOutput</code> | *No description* |
| <code>inflight transactWrite(options: TransactWriteOptions): TransactWriteOutput</code> | *No description* |
| <code>inflight update(options: UpdateOptions): UpdateOutput</code> | *No description* |

### ITable (interface) <a class="wing-docs-anchor" id="@winglibs/dynamodb.ITable"></a>

*No description*

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight delete(options: DeleteOptions): DeleteOutput</code> | *No description* |
| <code>inflight get(options: GetOptions): GetOutput</code> | *No description* |
| <code>inflight put(options: PutOptions): PutOutput</code> | *No description* |
| <code>inflight query(options: QueryOptions): QueryOutput</code> | *No description* |
| <code>inflight readWriteConnection(): Connection</code> | *No description* |
| <code>inflight scan(options: ScanOptions?): ScanOutput</code> | *No description* |
| <code>setStreamConsumer(handler: inflight (StreamRecord): void, options: StreamConsumerOptions?): void</code> | *No description* |
| <code>inflight transactWrite(options: TransactWriteOptions): TransactWriteOutput</code> | *No description* |
| <code>inflight update(options: UpdateOptions): UpdateOutput</code> | *No description* |

### AttributeDefinition (struct) <a class="wing-docs-anchor" id="@winglibs/dynamodb.AttributeDefinition"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>name</code> | <code>str</code> | *No description* |
| <code>type</code> | <code>str</code> | *No description* |

### ClientConfig (struct) <a class="wing-docs-anchor" id="@winglibs/dynamodb.ClientConfig"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>credentials</code> | <code>Credentials</code> | *No description* |
| <code>endpoint</code> | <code>str</code> | *No description* |
| <code>region</code> | <code>str</code> | *No description* |

### Connection (struct) <a class="wing-docs-anchor" id="@winglibs/dynamodb.Connection"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>clientConfig</code> | <code>ClientConfig?</code> | *No description* |
| <code>tableName</code> | <code>str</code> | *No description* |

### Credentials (struct) <a class="wing-docs-anchor" id="@winglibs/dynamodb.Credentials"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>accessKeyId</code> | <code>str</code> | *No description* |
| <code>secretAccessKey</code> | <code>str</code> | *No description* |

### DeleteOptions (struct) <a class="wing-docs-anchor" id="@winglibs/dynamodb.DeleteOptions"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>ConditionExpression</code> | <code>str?</code> | *No description* |
| <code>ExpressionAttributeNames</code> | <code>Map<str>?</code> | *No description* |
| <code>ExpressionAttributeValues</code> | <code>Map<Json>?</code> | *No description* |
| <code>Key</code> | <code>Json</code> | *No description* |
| <code>ReturnValues</code> | <code>str?</code> | *No description* |

### DeleteOutput (struct) <a class="wing-docs-anchor" id="@winglibs/dynamodb.DeleteOutput"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>Attributes</code> | <code>Json?</code> | *No description* |

### GetOptions (struct) <a class="wing-docs-anchor" id="@winglibs/dynamodb.GetOptions"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>ConsistentRead</code> | <code>bool?</code> | *No description* |
| <code>ExpressionAttributeNames</code> | <code>Map<str>?</code> | *No description* |
| <code>ExpressionAttributeValues</code> | <code>Map<Json>?</code> | *No description* |
| <code>Key</code> | <code>Json</code> | *No description* |
| <code>ProjectionExpression</code> | <code>str?</code> | *No description* |

### GetOutput (struct) <a class="wing-docs-anchor" id="@winglibs/dynamodb.GetOutput"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>Item</code> | <code>Json?</code> | *No description* |

### GlobalSecondaryIndex (struct) <a class="wing-docs-anchor" id="@winglibs/dynamodb.GlobalSecondaryIndex"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>hashKey</code> | <code>str</code> | *No description* |
| <code>name</code> | <code>str</code> | *No description* |
| <code>nonKeyAttributes</code> | <code>Array<str>?</code> | *No description* |
| <code>projectionType</code> | <code>str</code> | *No description* |
| <code>rangeKey</code> | <code>str?</code> | *No description* |
| <code>readCapacity</code> | <code>num?</code> | *No description* |
| <code>writeCapacity</code> | <code>num?</code> | *No description* |

### PutOptions (struct) <a class="wing-docs-anchor" id="@winglibs/dynamodb.PutOptions"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>ConditionExpression</code> | <code>str?</code> | *No description* |
| <code>ExpressionAttributeNames</code> | <code>Map<str>?</code> | *No description* |
| <code>ExpressionAttributeValues</code> | <code>Map<Json>?</code> | *No description* |
| <code>Item</code> | <code>Json</code> | *No description* |
| <code>ReturnValues</code> | <code>str?</code> | *No description* |

### PutOutput (struct) <a class="wing-docs-anchor" id="@winglibs/dynamodb.PutOutput"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>Attributes</code> | <code>Json?</code> | *No description* |

### QueryOptions (struct) <a class="wing-docs-anchor" id="@winglibs/dynamodb.QueryOptions"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>ConsistentRead</code> | <code>bool?</code> | *No description* |
| <code>ExclusiveStartKey</code> | <code>Json?</code> | *No description* |
| <code>ExpressionAttributeNames</code> | <code>Map<str>?</code> | *No description* |
| <code>ExpressionAttributeValues</code> | <code>Map<Json>?</code> | *No description* |
| <code>FilterExpression</code> | <code>str?</code> | *No description* |
| <code>IndexName</code> | <code>str?</code> | *No description* |
| <code>KeyConditionExpression</code> | <code>str</code> | *No description* |
| <code>Limit</code> | <code>num?</code> | *No description* |
| <code>ProjectionExpression</code> | <code>str?</code> | *No description* |
| <code>ReturnConsumedCapacity</code> | <code>str?</code> | *No description* |
| <code>ScanIndexForward</code> | <code>bool?</code> | *No description* |
| <code>Select</code> | <code>str?</code> | *No description* |

### QueryOutput (struct) <a class="wing-docs-anchor" id="@winglibs/dynamodb.QueryOutput"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>ConsumedCapacity</code> | <code>Json?</code> | *No description* |
| <code>Count</code> | <code>num</code> | *No description* |
| <code>Items</code> | <code>Array<Json></code> | *No description* |
| <code>LastEvaluatedKey</code> | <code>Json?</code> | *No description* |
| <code>ScannedCount</code> | <code>num</code> | *No description* |

### ScanOptions (struct) <a class="wing-docs-anchor" id="@winglibs/dynamodb.ScanOptions"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>ConsistentRead</code> | <code>bool?</code> | *No description* |
| <code>ExclusiveStartKey</code> | <code>Json?</code> | *No description* |
| <code>ExpressionAttributeNames</code> | <code>Map<str>?</code> | *No description* |
| <code>ExpressionAttributeValues</code> | <code>Map<Json>?</code> | *No description* |
| <code>FilterExpression</code> | <code>str?</code> | *No description* |
| <code>IndexName</code> | <code>str?</code> | *No description* |
| <code>Limit</code> | <code>num?</code> | *No description* |
| <code>ProjectionExpression</code> | <code>str?</code> | *No description* |
| <code>ReturnConsumedCapacity</code> | <code>str?</code> | *No description* |
| <code>Segment</code> | <code>num?</code> | *No description* |
| <code>Select</code> | <code>str?</code> | *No description* |
| <code>TotalSegments</code> | <code>num?</code> | *No description* |

### ScanOutput (struct) <a class="wing-docs-anchor" id="@winglibs/dynamodb.ScanOutput"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>ConsumedCapacity</code> | <code>Json?</code> | *No description* |
| <code>Count</code> | <code>num</code> | *No description* |
| <code>Items</code> | <code>Array<Json></code> | *No description* |
| <code>LastEvaluatedKey</code> | <code>Json?</code> | *No description* |
| <code>ScannedCount</code> | <code>num</code> | *No description* |

### StreamConsumerOptions (struct) <a class="wing-docs-anchor" id="@winglibs/dynamodb.StreamConsumerOptions"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>batchSize</code> | <code>num?</code> | *No description* |
| <code>startingPosition</code> | <code>str?</code> | *No description* |

### StreamRecord (struct) <a class="wing-docs-anchor" id="@winglibs/dynamodb.StreamRecord"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>dynamodb</code> | <code>StreamRecordDynamodb</code> | *No description* |
| <code>eventID</code> | <code>str</code> | *No description* |
| <code>eventName</code> | <code>str</code> | *No description* |

### StreamRecordDynamodb (struct) <a class="wing-docs-anchor" id="@winglibs/dynamodb.StreamRecordDynamodb"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>ApproximateCreationDateTime</code> | <code>str</code> | *No description* |
| <code>Keys</code> | <code>Json</code> | *No description* |
| <code>NewImage</code> | <code>Json?</code> | *No description* |
| <code>OldImage</code> | <code>Json?</code> | *No description* |
| <code>SequenceNumber</code> | <code>str</code> | *No description* |
| <code>SizeBytes</code> | <code>num</code> | *No description* |
| <code>StreamViewType</code> | <code>str</code> | *No description* |

### TableProps (struct) <a class="wing-docs-anchor" id="@winglibs/dynamodb.TableProps"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>attributes</code> | <code>Array<AttributeDefinition></code> | *No description* |
| <code>billingMode</code> | <code>BillingMode?</code> | Billing mode for the table. Defaults to `PAY_PER_REQUEST`. |
| <code>deletionProtection</code> | <code>bool?</code> | Enables deletion protection for table. Disabled by default.  For the Terraform AWS provider, this will also enable `lifecycle { prevent_destroy = true }` |
| <code>globalSecondaryIndex</code> | <code>Array<GlobalSecondaryIndex>?</code> | *No description* |
| <code>hashKey</code> | <code>str</code> | *No description* |
| <code>name</code> | <code>str?</code> | *No description* |
| <code>pointInTimeRecovery</code> | <code>bool?</code> | *No description* |
| <code>rangeKey</code> | <code>str?</code> | *No description* |
| <code>timeToLiveAttribute</code> | <code>str?</code> | *No description* |

### TransactWriteItem (struct) <a class="wing-docs-anchor" id="@winglibs/dynamodb.TransactWriteItem"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>ConditionCheck</code> | <code>TransactWriteItemConditionCheck?</code> | *No description* |
| <code>Delete</code> | <code>TransactWriteItemDelete?</code> | *No description* |
| <code>Put</code> | <code>TransactWriteItemPut?</code> | *No description* |
| <code>Update</code> | <code>TransactWriteItemUpdate?</code> | *No description* |

### TransactWriteItemConditionCheck (struct) <a class="wing-docs-anchor" id="@winglibs/dynamodb.TransactWriteItemConditionCheck"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>ConditionExpression</code> | <code>str?</code> | *No description* |
| <code>ExpressionAttributeNames</code> | <code>Map<str>?</code> | *No description* |
| <code>ExpressionAttributeValues</code> | <code>Map<Json>?</code> | *No description* |
| <code>Key</code> | <code>Json</code> | *No description* |
| <code>ReturnValuesOnConditionCheckFailure</code> | <code>bool?</code> | *No description* |

### TransactWriteItemDelete (struct) <a class="wing-docs-anchor" id="@winglibs/dynamodb.TransactWriteItemDelete"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>ConditionExpression</code> | <code>str?</code> | *No description* |
| <code>ExpressionAttributeNames</code> | <code>Map<str>?</code> | *No description* |
| <code>ExpressionAttributeValues</code> | <code>Map<Json>?</code> | *No description* |
| <code>Key</code> | <code>Json</code> | *No description* |
| <code>ReturnValuesOnConditionCheckFailure</code> | <code>bool?</code> | *No description* |

### TransactWriteItemPut (struct) <a class="wing-docs-anchor" id="@winglibs/dynamodb.TransactWriteItemPut"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>ConditionExpression</code> | <code>str?</code> | *No description* |
| <code>ExpressionAttributeNames</code> | <code>Map<str>?</code> | *No description* |
| <code>ExpressionAttributeValues</code> | <code>Map<Json>?</code> | *No description* |
| <code>Item</code> | <code>Json</code> | *No description* |
| <code>ReturnValuesOnConditionCheckFailure</code> | <code>bool?</code> | *No description* |

### TransactWriteItemUpdate (struct) <a class="wing-docs-anchor" id="@winglibs/dynamodb.TransactWriteItemUpdate"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>ConditionExpression</code> | <code>str?</code> | *No description* |
| <code>ExpressionAttributeNames</code> | <code>Map<str>?</code> | *No description* |
| <code>ExpressionAttributeValues</code> | <code>Map<Json>?</code> | *No description* |
| <code>Key</code> | <code>Json</code> | *No description* |
| <code>ReturnValuesOnConditionCheckFailure</code> | <code>bool?</code> | *No description* |
| <code>UpdateExpression</code> | <code>str?</code> | *No description* |

### TransactWriteOptions (struct) <a class="wing-docs-anchor" id="@winglibs/dynamodb.TransactWriteOptions"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>TransactItems</code> | <code>Array<TransactWriteItem></code> | *No description* |

### TransactWriteOutput (struct) <a class="wing-docs-anchor" id="@winglibs/dynamodb.TransactWriteOutput"></a>

*No description*

#### Properties

*No properties*

### UpdateOptions (struct) <a class="wing-docs-anchor" id="@winglibs/dynamodb.UpdateOptions"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>ConditionExpression</code> | <code>str?</code> | *No description* |
| <code>ExpressionAttributeNames</code> | <code>Map<str>?</code> | *No description* |
| <code>ExpressionAttributeValues</code> | <code>Map<Json>?</code> | *No description* |
| <code>Key</code> | <code>Json</code> | *No description* |
| <code>ReturnConsumedCapacity</code> | <code>str?</code> | *No description* |
| <code>ReturnValues</code> | <code>str?</code> | *No description* |
| <code>UpdateExpression</code> | <code>str</code> | *No description* |

### UpdateOutput (struct) <a class="wing-docs-anchor" id="@winglibs/dynamodb.UpdateOutput"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>ConditionExpression</code> | <code>str?</code> | *No description* |
| <code>ExpressionAttributeNames</code> | <code>Map<str>?</code> | *No description* |
| <code>ExpressionAttributeValues</code> | <code>Map<Json>?</code> | *No description* |
| <code>Item</code> | <code>Json</code> | *No description* |
| <code>ReturnValues</code> | <code>str?</code> | *No description* |

### ClientProps (struct) <a class="wing-docs-anchor" id="@winglibs/dynamodb.ClientProps"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>credentials</code> | <code>Credentials?</code> | *No description* |
| <code>endpoint</code> | <code>str?</code> | *No description* |
| <code>region</code> | <code>str?</code> | *No description* |
| <code>tableName</code> | <code>str</code> | *No description* |

### BillingMode (enum) <a class="wing-docs-anchor" id="@winglibs/dynamodb.BillingMode"></a>

*No description*

#### Values

| **Name** | **Description** |
| --- | --- |
| <code>PAY_PER_REQUEST</code> | *No description* |
| <code>PROVISIONED</code> | *No description* |

