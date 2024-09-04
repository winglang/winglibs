## API Reference

### Table of Contents

- **Classes**
  - <a href="#@winglibs/cloudv2.Counter">Counter</a>
  - <a href="#@winglibs/cloudv2.AwsCounter">AwsCounter</a>
- **Interfaces**
  - <a href="#@winglibs/cloudv2.ICounter">ICounter</a>
  - <a href="#@winglibs/cloudv2.IAwsCounter">IAwsCounter</a>
- **Structs**
  - <a href="#@winglibs/cloudv2.CounterProps">CounterProps</a>

### Counter (preflight class) <a class="wing-docs-anchor" id="@winglibs/cloudv2.Counter"></a>

*No description*

#### Constructor

```
new(props: CounterProps): Counter
```

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>initial</code> | <code>num</code> | *No description* |

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight dec(amount: num?, key: str?): num</code> | *No description* |
| <code>inflight inc(amount: num?, key: str?): num</code> | *No description* |
| <code>inflight peek(key: str?): num</code> | *No description* |
| <code>inflight set(value: num, key: str?): void</code> | *No description* |

### AwsCounter (preflight class) <a class="wing-docs-anchor" id="@winglibs/cloudv2.AwsCounter"></a>

*No description*

#### Constructor

```
new(): AwsCounter
```

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>static from(c: ICounter): IAwsCounter?</code> | *No description* |

### ICounter (interface) <a class="wing-docs-anchor" id="@winglibs/cloudv2.ICounter"></a>

*No description*

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight dec(amount: num?, key: str?): num</code> | Decrements the counter atomically by a certain amount and returns the previous value. - `amount` The amount to decrement by (defaults to 1) - `key` The key of the counter (defaults to "default") |
| <code>inflight inc(amount: num?, key: str?): num</code> | Increments the counter atomically by a certain amount and returns the previous value. - `amount` The amount to increment by (defaults to 1) - `key` The key of the counter (defaults to "default") |
| <code>inflight peek(key: str?): num</code> | Returns the current value of the counter. - `key` The key of the counter (defaults to "default") |
| <code>inflight set(value: num, key: str?): void</code> | Sets the value of the counter. - `value` The new value of the counter - `key` The key of the counter (defaults to "default") |

### IAwsCounter (interface) <a class="wing-docs-anchor" id="@winglibs/cloudv2.IAwsCounter"></a>

*No description*

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>dynamoTableArn(): str</code> | *No description* |
| <code>dynamoTableName(): str</code> | *No description* |

### CounterProps (struct) <a class="wing-docs-anchor" id="@winglibs/cloudv2.CounterProps"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>initial</code> | <code>num?</code> | The initial value of the counter @default 0 |

