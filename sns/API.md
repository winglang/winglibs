## API Reference

### Table of Contents

- **Classes**
  - <a href="#@winglibs/sns.MobileNotifications_sim">MobileNotifications_sim</a>
  - <a href="#@winglibs/sns.MobileNotifications">MobileNotifications</a>
  - <a href="#@winglibs/sns.MobileNotifications_aws">MobileNotifications_aws</a>
- **Interfaces**
  - <a href="#@winglibs/sns.IMobileNotifications">IMobileNotifications</a>
- **Structs**
  - <a href="#@winglibs/sns.MessageAttributeValue">MessageAttributeValue</a>
  - <a href="#@winglibs/sns.PublishOptions">PublishOptions</a>
  - <a href="#@winglibs/sns.PublishResult">PublishResult</a>

### MobileNotifications_sim (preflight class) <a class="wing-docs-anchor" id="@winglibs/sns.MobileNotifications_sim"></a>

*No description*

#### Constructor

```
new(): MobileNotifications_sim
```

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight publish(options: PublishOptions): PublishResult</code> | *No description* |

### MobileNotifications (preflight class) <a class="wing-docs-anchor" id="@winglibs/sns.MobileNotifications"></a>

MobileNotifications is a client for interacting with SNS mobile service.
No cloud resources are created when using this class.
When running the simulator in a non test environment, it will use the
actual cloud implementation.

#### Constructor

```
new(): MobileNotifications
```

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight publish(options: PublishOptions): PublishResult</code> | *No description* |

### MobileNotifications_aws (preflight class) <a class="wing-docs-anchor" id="@winglibs/sns.MobileNotifications_aws"></a>

*No description*

#### Constructor

```
new(): MobileNotifications_aws
```

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight publish(options: PublishOptions): PublishResult</code> | *No description* |

### IMobileNotifications (interface) <a class="wing-docs-anchor" id="@winglibs/sns.IMobileNotifications"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>node</code> | <code>Node</code> | The tree node. |

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight publish(options: PublishOptions): PublishResult</code> | *No description* |

### MessageAttributeValue (struct) <a class="wing-docs-anchor" id="@winglibs/sns.MessageAttributeValue"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>DataType</code> | <code>str?</code> | *No description* |
| <code>StringValue</code> | <code>str?</code> | *No description* |

### PublishOptions (struct) <a class="wing-docs-anchor" id="@winglibs/sns.PublishOptions"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>Message</code> | <code>str?</code> | *No description* |
| <code>MessageAttributes</code> | <code>Map<MessageAttributeValue>?</code> | *No description* |
| <code>PhoneNumber</code> | <code>str?</code> | *No description* |
| <code>Subject</code> | <code>str?</code> | *No description* |
| <code>TopicArn</code> | <code>str?</code> | *No description* |

### PublishResult (struct) <a class="wing-docs-anchor" id="@winglibs/sns.PublishResult"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>MessageId</code> | <code>str?</code> | *No description* |
| <code>SequenceNumber</code> | <code>str?</code> | *No description* |

