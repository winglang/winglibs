<h2>API Reference</h2>

<h3>Table of Contents</h3>

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

<h3 id="@winglibs/sns.MobileNotifications_sim">MobileNotifications_sim (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(): MobileNotifications_sim
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight publish(options: PublishOptions): PublishResult</code> | *No description* |

<h3 id="@winglibs/sns.MobileNotifications">MobileNotifications (preflight class)</h3>

MobileNotifications is a client for interacting with SNS mobile service.
No cloud resources are created when using this class.
When running the simulator in a non test environment, it will use the
actual cloud implementation.

<h4>Constructor</h4>

<pre>
new(): MobileNotifications
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight publish(options: PublishOptions): PublishResult</code> | *No description* |

<h3 id="@winglibs/sns.MobileNotifications_aws">MobileNotifications_aws (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(): MobileNotifications_aws
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight publish(options: PublishOptions): PublishResult</code> | *No description* |

<h3 id="@winglibs/sns.IMobileNotifications">IMobileNotifications (interface)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>node</code> | <code>Node</code> | The tree node. |

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight publish(options: PublishOptions): PublishResult</code> | *No description* |

<h3 id="@winglibs/sns.MessageAttributeValue">MessageAttributeValue (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>DataType</code> | <code>str?</code> | *No description* |
| <code>StringValue</code> | <code>str?</code> | *No description* |

<h3 id="@winglibs/sns.PublishOptions">PublishOptions (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>Message</code> | <code>str?</code> | *No description* |
| <code>MessageAttributes</code> | <code>Map<MessageAttributeValue>?</code> | *No description* |
| <code>PhoneNumber</code> | <code>str?</code> | *No description* |
| <code>Subject</code> | <code>str?</code> | *No description* |
| <code>TopicArn</code> | <code>str?</code> | *No description* |

<h3 id="@winglibs/sns.PublishResult">PublishResult (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>MessageId</code> | <code>str?</code> | *No description* |
| <code>SequenceNumber</code> | <code>str?</code> | *No description* |

