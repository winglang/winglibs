<h2>API Reference</h2>

<h3>Table of Contents</h3>

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

<h3 id="@winglibs/dynamodb.Table">Table (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(props: TableProps): Table
</pre>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>connection</code> | <code>Connection</code> | *No description* |
| <code>tableName</code> | <code>str</code> | *No description* |

<h4>Methods</h4>

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

<h3 id="@winglibs/dynamodb.Table_tfaws">Table_tfaws (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(props: TableProps): Table_tfaws
</pre>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>connection</code> | <code>Connection</code> | *No description* |
| <code>tableName</code> | <code>str</code> | *No description* |

<h4>Methods</h4>

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

<h3 id="@winglibs/dynamodb.Table_sim">Table_sim (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(props: TableProps): Table_sim
</pre>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>connection</code> | <code>Connection</code> | *No description* |
| <code>tableName</code> | <code>str</code> | *No description* |

<h4>Methods</h4>

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

<h3 id="@winglibs/dynamodb.Client">Client (inflight class)</h3>

<h4>Constructor</h4>

<pre>
new(): Client
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight delete(options: DeleteOptions): DeleteOutput</code> | *No description* |
| <code>inflight get(options: GetOptions): GetOutput</code> | *No description* |
| <code>inflight put(options: PutOptions): PutOutput</code> | *No description* |
| <code>inflight query(options: QueryOptions): QueryOutput</code> | *No description* |
| <code>inflight scan(options: ScanOptions?): ScanOutput</code> | *No description* |
| <code>inflight transactWrite(options: TransactWriteOptions): TransactWriteOutput</code> | *No description* |
| <code>inflight update(options: UpdateOptions): UpdateOutput</code> | *No description* |

<h3 id="@winglibs/dynamodb.IClient">IClient (interface)</h3>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight delete(options: DeleteOptions): DeleteOutput</code> | *No description* |
| <code>inflight get(options: GetOptions): GetOutput</code> | *No description* |
| <code>inflight put(options: PutOptions): PutOutput</code> | *No description* |
| <code>inflight query(options: QueryOptions): QueryOutput</code> | *No description* |
| <code>inflight scan(options: ScanOptions?): ScanOutput</code> | *No description* |
| <code>inflight transactWrite(options: TransactWriteOptions): TransactWriteOutput</code> | *No description* |
| <code>inflight update(options: UpdateOptions): UpdateOutput</code> | *No description* |

<h3 id="@winglibs/dynamodb.ITable">ITable (interface)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>node</code> | <code>Node</code> | The tree node. |

<h4>Methods</h4>

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

<h3 id="@winglibs/dynamodb.AttributeDefinition">AttributeDefinition (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>name</code> | <code>str</code> | *No description* |
| <code>type</code> | <code>str</code> | *No description* |

<h3 id="@winglibs/dynamodb.ClientConfig">ClientConfig (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>credentials</code> | <code>Credentials</code> | *No description* |
| <code>endpoint</code> | <code>str</code> | *No description* |
| <code>region</code> | <code>str</code> | *No description* |

<h3 id="@winglibs/dynamodb.Connection">Connection (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>clientConfig</code> | <code>ClientConfig?</code> | *No description* |
| <code>tableName</code> | <code>str</code> | *No description* |

<h3 id="@winglibs/dynamodb.Credentials">Credentials (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>accessKeyId</code> | <code>str</code> | *No description* |
| <code>secretAccessKey</code> | <code>str</code> | *No description* |

<h3 id="@winglibs/dynamodb.DeleteOptions">DeleteOptions (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>ConditionExpression</code> | <code>str?</code> | *No description* |
| <code>ExpressionAttributeNames</code> | <code>Map<str>?</code> | *No description* |
| <code>ExpressionAttributeValues</code> | <code>Map<Json>?</code> | *No description* |
| <code>Key</code> | <code>Json</code> | *No description* |
| <code>ReturnValues</code> | <code>str?</code> | *No description* |

<h3 id="@winglibs/dynamodb.DeleteOutput">DeleteOutput (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>Attributes</code> | <code>Json?</code> | *No description* |

<h3 id="@winglibs/dynamodb.GetOptions">GetOptions (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>ConsistentRead</code> | <code>bool?</code> | *No description* |
| <code>ExpressionAttributeNames</code> | <code>Map<str>?</code> | *No description* |
| <code>ExpressionAttributeValues</code> | <code>Map<Json>?</code> | *No description* |
| <code>Key</code> | <code>Json</code> | *No description* |
| <code>ProjectionExpression</code> | <code>str?</code> | *No description* |

<h3 id="@winglibs/dynamodb.GetOutput">GetOutput (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>Item</code> | <code>Json?</code> | *No description* |

<h3 id="@winglibs/dynamodb.GlobalSecondaryIndex">GlobalSecondaryIndex (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>hashKey</code> | <code>str</code> | *No description* |
| <code>name</code> | <code>str</code> | *No description* |
| <code>nonKeyAttributes</code> | <code>Array<str>?</code> | *No description* |
| <code>projectionType</code> | <code>str</code> | *No description* |
| <code>rangeKey</code> | <code>str?</code> | *No description* |
| <code>readCapacity</code> | <code>num?</code> | *No description* |
| <code>writeCapacity</code> | <code>num?</code> | *No description* |

<h3 id="@winglibs/dynamodb.PutOptions">PutOptions (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>ConditionExpression</code> | <code>str?</code> | *No description* |
| <code>ExpressionAttributeNames</code> | <code>Map<str>?</code> | *No description* |
| <code>ExpressionAttributeValues</code> | <code>Map<Json>?</code> | *No description* |
| <code>Item</code> | <code>Json</code> | *No description* |
| <code>ReturnValues</code> | <code>str?</code> | *No description* |

<h3 id="@winglibs/dynamodb.PutOutput">PutOutput (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>Attributes</code> | <code>Json?</code> | *No description* |

<h3 id="@winglibs/dynamodb.QueryOptions">QueryOptions (struct)</h3>

<h4>Properties</h4>

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

<h3 id="@winglibs/dynamodb.QueryOutput">QueryOutput (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>ConsumedCapacity</code> | <code>Json?</code> | *No description* |
| <code>Count</code> | <code>num</code> | *No description* |
| <code>Items</code> | <code>Array<Json></code> | *No description* |
| <code>LastEvaluatedKey</code> | <code>Json?</code> | *No description* |
| <code>ScannedCount</code> | <code>num</code> | *No description* |

<h3 id="@winglibs/dynamodb.ScanOptions">ScanOptions (struct)</h3>

<h4>Properties</h4>

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

<h3 id="@winglibs/dynamodb.ScanOutput">ScanOutput (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>ConsumedCapacity</code> | <code>Json?</code> | *No description* |
| <code>Count</code> | <code>num</code> | *No description* |
| <code>Items</code> | <code>Array<Json></code> | *No description* |
| <code>LastEvaluatedKey</code> | <code>Json?</code> | *No description* |
| <code>ScannedCount</code> | <code>num</code> | *No description* |

<h3 id="@winglibs/dynamodb.StreamConsumerOptions">StreamConsumerOptions (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>batchSize</code> | <code>num?</code> | *No description* |
| <code>startingPosition</code> | <code>str?</code> | *No description* |

<h3 id="@winglibs/dynamodb.StreamRecord">StreamRecord (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>dynamodb</code> | <code>StreamRecordDynamodb</code> | *No description* |
| <code>eventID</code> | <code>str</code> | *No description* |
| <code>eventName</code> | <code>str</code> | *No description* |

<h3 id="@winglibs/dynamodb.StreamRecordDynamodb">StreamRecordDynamodb (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>ApproximateCreationDateTime</code> | <code>str</code> | *No description* |
| <code>Keys</code> | <code>Json</code> | *No description* |
| <code>NewImage</code> | <code>Json?</code> | *No description* |
| <code>OldImage</code> | <code>Json?</code> | *No description* |
| <code>SequenceNumber</code> | <code>str</code> | *No description* |
| <code>SizeBytes</code> | <code>num</code> | *No description* |
| <code>StreamViewType</code> | <code>str</code> | *No description* |

<h3 id="@winglibs/dynamodb.TableProps">TableProps (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>attributes</code> | <code>Array<AttributeDefinition></code> | *No description* |
| <code>globalSecondaryIndex</code> | <code>Array<GlobalSecondaryIndex>?</code> | *No description* |
| <code>hashKey</code> | <code>str</code> | *No description* |
| <code>name</code> | <code>str?</code> | *No description* |
| <code>pointInTimeRecovery</code> | <code>bool?</code> | *No description* |
| <code>rangeKey</code> | <code>str?</code> | *No description* |
| <code>timeToLiveAttribute</code> | <code>str?</code> | *No description* |

<h3 id="@winglibs/dynamodb.TransactWriteItem">TransactWriteItem (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>ConditionCheck</code> | <code>TransactWriteItemConditionCheck?</code> | *No description* |
| <code>Delete</code> | <code>TransactWriteItemDelete?</code> | *No description* |
| <code>Put</code> | <code>TransactWriteItemPut?</code> | *No description* |
| <code>Update</code> | <code>TransactWriteItemUpdate?</code> | *No description* |

<h3 id="@winglibs/dynamodb.TransactWriteItemConditionCheck">TransactWriteItemConditionCheck (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>ConditionExpression</code> | <code>str?</code> | *No description* |
| <code>ExpressionAttributeNames</code> | <code>Map<str>?</code> | *No description* |
| <code>ExpressionAttributeValues</code> | <code>Map<Json>?</code> | *No description* |
| <code>Key</code> | <code>Json</code> | *No description* |
| <code>ReturnValuesOnConditionCheckFailure</code> | <code>bool?</code> | *No description* |

<h3 id="@winglibs/dynamodb.TransactWriteItemDelete">TransactWriteItemDelete (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>ConditionExpression</code> | <code>str?</code> | *No description* |
| <code>ExpressionAttributeNames</code> | <code>Map<str>?</code> | *No description* |
| <code>ExpressionAttributeValues</code> | <code>Map<Json>?</code> | *No description* |
| <code>Key</code> | <code>Json</code> | *No description* |
| <code>ReturnValuesOnConditionCheckFailure</code> | <code>bool?</code> | *No description* |

<h3 id="@winglibs/dynamodb.TransactWriteItemPut">TransactWriteItemPut (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>ConditionExpression</code> | <code>str?</code> | *No description* |
| <code>ExpressionAttributeNames</code> | <code>Map<str>?</code> | *No description* |
| <code>ExpressionAttributeValues</code> | <code>Map<Json>?</code> | *No description* |
| <code>Item</code> | <code>Json</code> | *No description* |
| <code>ReturnValuesOnConditionCheckFailure</code> | <code>bool?</code> | *No description* |

<h3 id="@winglibs/dynamodb.TransactWriteItemUpdate">TransactWriteItemUpdate (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>ConditionExpression</code> | <code>str?</code> | *No description* |
| <code>ExpressionAttributeNames</code> | <code>Map<str>?</code> | *No description* |
| <code>ExpressionAttributeValues</code> | <code>Map<Json>?</code> | *No description* |
| <code>Key</code> | <code>Json</code> | *No description* |
| <code>ReturnValuesOnConditionCheckFailure</code> | <code>bool?</code> | *No description* |
| <code>UpdateExpression</code> | <code>str?</code> | *No description* |

<h3 id="@winglibs/dynamodb.TransactWriteOptions">TransactWriteOptions (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>TransactItems</code> | <code>Array<TransactWriteItem></code> | *No description* |

<h3 id="@winglibs/dynamodb.TransactWriteOutput">TransactWriteOutput (struct)</h3>

<h4>Properties</h4>

*No properties*

<h3 id="@winglibs/dynamodb.UpdateOptions">UpdateOptions (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>ConditionExpression</code> | <code>str?</code> | *No description* |
| <code>ExpressionAttributeNames</code> | <code>Map<str>?</code> | *No description* |
| <code>ExpressionAttributeValues</code> | <code>Map<Json>?</code> | *No description* |
| <code>Key</code> | <code>Json</code> | *No description* |
| <code>ReturnConsumedCapacity</code> | <code>str?</code> | *No description* |
| <code>ReturnValues</code> | <code>str?</code> | *No description* |
| <code>UpdateExpression</code> | <code>str</code> | *No description* |

<h3 id="@winglibs/dynamodb.UpdateOutput">UpdateOutput (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>ConditionExpression</code> | <code>str?</code> | *No description* |
| <code>ExpressionAttributeNames</code> | <code>Map<str>?</code> | *No description* |
| <code>ExpressionAttributeValues</code> | <code>Map<Json>?</code> | *No description* |
| <code>Item</code> | <code>Json</code> | *No description* |
| <code>ReturnValues</code> | <code>str?</code> | *No description* |

<h3 id="@winglibs/dynamodb.ClientProps">ClientProps (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>credentials</code> | <code>Credentials?</code> | *No description* |
| <code>endpoint</code> | <code>str?</code> | *No description* |
| <code>region</code> | <code>str?</code> | *No description* |
| <code>tableName</code> | <code>str</code> | *No description* |

