## API Reference

### Table of Contents

- **Classes**
  - <a href="#@winglibs/messagefanout.MessageFanout">MessageFanout</a>
  - <a href="#@winglibs/messagefanout.platform.MessageFanout_tfaws">platform.MessageFanout_tfaws</a>
  - <a href="#@winglibs/messagefanout.platform.MessageFanout_sim">platform.MessageFanout_sim</a>
- **Interfaces**
  - <a href="#@winglibs/messagefanout.commons.IMessageFanout">commons.IMessageFanout</a>
- **Structs**
  - <a href="#@winglibs/messagefanout.commons.MessageFanoutProps">commons.MessageFanoutProps</a>

### MessageFanout (preflight class) <a class="wing-docs-anchor" id="@winglibs/messagefanout.MessageFanout"></a>

*No description*

#### Constructor

```
new(): MessageFanout
```

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>addConsumer(handler: inflight (str): void, props: MessageFanoutProps): void</code> | *No description* |
| <code>inflight publish(message: str): void</code> | *No description* |

### platform.MessageFanout_tfaws (preflight class) <a class="wing-docs-anchor" id="@winglibs/messagefanout.platform.MessageFanout_tfaws"></a>

*No description*

#### Constructor

```
new(): MessageFanout_tfaws
```

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>addConsumer(handler: inflight (str): void, props: MessageFanoutProps): void</code> | *No description* |
| <code>inflight publish(message: str): void</code> | *No description* |

### platform.MessageFanout_sim (preflight class) <a class="wing-docs-anchor" id="@winglibs/messagefanout.platform.MessageFanout_sim"></a>

*No description*

#### Constructor

```
new(): MessageFanout_sim
```

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>addConsumer(handler: inflight (str): void, props: MessageFanoutProps): void</code> | *No description* |
| <code>inflight publish(message: str): void</code> | *No description* |

### commons.IMessageFanout (interface) <a class="wing-docs-anchor" id="@winglibs/messagefanout.commons.IMessageFanout"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>node</code> | <code>Node</code> | The tree node. |

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>addConsumer(handler: inflight (str): void, props: MessageFanoutProps): void</code> | *No description* |
| <code>inflight publish(message: str): void</code> | *No description* |

### commons.MessageFanoutProps (struct) <a class="wing-docs-anchor" id="@winglibs/messagefanout.commons.MessageFanoutProps"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>dlq</code> | <code>DeadLetterQueueProps?</code> | A dead-letter queue. |
| <code>name</code> | <code>str</code> | *No description* |
| <code>retentionPeriod</code> | <code>duration?</code> | How long a queue retains a message. |
| <code>timeout</code> | <code>duration?</code> | How long a queue's consumers have to process a message. |

