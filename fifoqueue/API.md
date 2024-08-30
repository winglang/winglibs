<h2>API Reference</h2>

<h3>Table of Contents</h3>

- **Classes**
  - <a href="#@winglibs/fifoqueue.FifoQueue">FifoQueue</a>
  - <a href="#@winglibs/fifoqueue.FifoQueue_sim">FifoQueue_sim</a>
  - <a href="#@winglibs/fifoqueue.FifoQueue_aws">FifoQueue_aws</a>
- **Interfaces**
  - <a href="#@winglibs/fifoqueue.IFifoQueue">IFifoQueue</a>
- **Structs**
  - <a href="#@winglibs/fifoqueue.FifoQueueProps">FifoQueueProps</a>
  - <a href="#@winglibs/fifoqueue.PushOptions">PushOptions</a>
  - <a href="#@winglibs/fifoqueue.SetConsumerOptions">SetConsumerOptions</a>

<h3 id="@winglibs/fifoqueue.FifoQueue">FifoQueue (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(props: FifoQueueProps?): FifoQueue
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight push(message: str, options: PushOptions): void</code> | *No description* |
| <code>setConsumer(fn: inflight (str): void, options: SetConsumerOptions?): void</code> | *No description* |

<h3 id="@winglibs/fifoqueue.FifoQueue_sim">FifoQueue_sim (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(): FifoQueue_sim
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight push(message: str, options: PushOptions): void</code> | *No description* |
| <code>setConsumer(handler: inflight (str): void, options: SetConsumerOptions?): void</code> | *No description* |

<h3 id="@winglibs/fifoqueue.FifoQueue_aws">FifoQueue_aws (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(props: FifoQueueProps?): FifoQueue_aws
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight push(message: str, options: PushOptions): void</code> | *No description* |
| <code>setConsumer(handler: inflight (str): void, options: SetConsumerOptions?): void</code> | *No description* |

<h3 id="@winglibs/fifoqueue.IFifoQueue">IFifoQueue (interface)</h3>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight push(message: str, options: PushOptions): void</code> | *No description* |
| <code>setConsumer(handler: inflight (str): void, options: SetConsumerOptions?): void</code> | *No description* |

<h3 id="@winglibs/fifoqueue.FifoQueueProps">FifoQueueProps (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>dlq</code> | <code>DeadLetterQueueProps?</code> | A dead-letter queue. |
| <code>retentionPeriod</code> | <code>duration?</code> | How long a queue retains a message. |
| <code>timeout</code> | <code>duration?</code> | How long a queue's consumers have to process a message. |

<h3 id="@winglibs/fifoqueue.PushOptions">PushOptions (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>groupId</code> | <code>str</code> | *No description* |

<h3 id="@winglibs/fifoqueue.SetConsumerOptions">SetConsumerOptions (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>batchSize</code> | <code>num?</code> | The maximum number of messages to send to subscribers at once. |
| <code>concurrency</code> | <code>num?</code> | The maximum concurrent invocations that can run at one time. |
| <code>env</code> | <code>Map<str>?</code> | Environment variables to pass to the function. |
| <code>logRetentionDays</code> | <code>num?</code> | Specifies the number of days that function logs will be kept. |
| <code>memory</code> | <code>num?</code> | The amount of memory to allocate to the function, in MB. |
| <code>timeout</code> | <code>duration?</code> | The maximum amount of time the function can run. |

