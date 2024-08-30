<h2>API Reference</h2>

<h3>Table of Contents</h3>

- **Classes**
  - <a href="#@winglibs/messagefanout.MessageFanout">MessageFanout</a>
  - <a href="#@winglibs/messagefanout.platform.MessageFanout_tfaws">platform.MessageFanout_tfaws</a>
  - <a href="#@winglibs/messagefanout.platform.MessageFanout_sim">platform.MessageFanout_sim</a>
- **Interfaces**
  - <a href="#@winglibs/messagefanout.commons.IMessageFanout">commons.IMessageFanout</a>
- **Structs**
  - <a href="#@winglibs/messagefanout.commons.MessageFanoutProps">commons.MessageFanoutProps</a>

<h3 id="@winglibs/messagefanout.MessageFanout">MessageFanout (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(): MessageFanout
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>addConsumer(handler: inflight (str): void, props: MessageFanoutProps): void</code> | *No description* |
| <code>inflight publish(message: str): void</code> | *No description* |

<h3 id="@winglibs/messagefanout.platform.MessageFanout_tfaws">platform.MessageFanout_tfaws (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(): MessageFanout_tfaws
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>addConsumer(handler: inflight (str): void, props: MessageFanoutProps): void</code> | *No description* |
| <code>inflight publish(message: str): void</code> | *No description* |

<h3 id="@winglibs/messagefanout.platform.MessageFanout_sim">platform.MessageFanout_sim (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(): MessageFanout_sim
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>addConsumer(handler: inflight (str): void, props: MessageFanoutProps): void</code> | *No description* |
| <code>inflight publish(message: str): void</code> | *No description* |

<h3 id="@winglibs/messagefanout.commons.IMessageFanout">commons.IMessageFanout (interface)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>node</code> | <code>Node</code> | The tree node. |

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>addConsumer(handler: inflight (str): void, props: MessageFanoutProps): void</code> | *No description* |
| <code>inflight publish(message: str): void</code> | *No description* |

<h3 id="@winglibs/messagefanout.commons.MessageFanoutProps">commons.MessageFanoutProps (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>dlq</code> | <code>DeadLetterQueueProps?</code> | A dead-letter queue. |
| <code>name</code> | <code>str</code> | *No description* |
| <code>retentionPeriod</code> | <code>duration?</code> | How long a queue retains a message. |
| <code>timeout</code> | <code>duration?</code> | How long a queue's consumers have to process a message. |

