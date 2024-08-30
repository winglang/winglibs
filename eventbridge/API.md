<h2>API Reference</h2>

<h3>Table of Contents</h3>

- **Classes**
  - <a href="#@winglibs/eventbridge.Bus">Bus</a>
  - <a href="#@winglibs/eventbridge.platform.tfaws.Bus">platform.tfaws.Bus</a>
  - <a href="#@winglibs/eventbridge.platform.sim.Bus">platform.sim.Bus</a>
  - <a href="#@winglibs/eventbridge.platform.sim.EventBridgeBus">platform.sim.EventBridgeBus</a>
  - <a href="#@winglibs/eventbridge.platform.awscdk.Bus">platform.awscdk.Bus</a>
  - <a href="#@winglibs/eventbridge.platform.aws.Util">platform.aws.Util</a>
- **Interfaces**
  - <a href="#@winglibs/eventbridge.IBus">IBus</a>
- **Structs**
  - <a href="#@winglibs/eventbridge.BusProps">BusProps</a>
  - <a href="#@winglibs/eventbridge.Event">Event</a>
  - <a href="#@winglibs/eventbridge.PublishEvent">PublishEvent</a>
  - <a href="#@winglibs/eventbridge.platform.aws.PutEventCommandEntry">platform.aws.PutEventCommandEntry</a>
  - <a href="#@winglibs/eventbridge.platform.aws.PutEventCommandInput">platform.aws.PutEventCommandInput</a>

<h3 id="@winglibs/eventbridge.Bus">Bus (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(props: BusProps?): Bus
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>onEvent(name: str, handler: inflight (Event): void, pattern: Json): void</code> | *No description* |
| <code>inflight putEvents(events: Array<PublishEvent>): void</code> | *No description* |
| <code>subscribeQueue(name: str, queue: Queue, pattern: Json): void</code> | *No description* |

<h3 id="@winglibs/eventbridge.platform.tfaws.Bus">platform.tfaws.Bus (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(props: BusProps?): Bus
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>onEvent(name: str, handler: inflight (Event): void, pattern: Json): void</code> | *No description* |
| <code>inflight putEvents(events: Array<PublishEvent>): void</code> | *No description* |
| <code>subscribeQueue(name: str, queue: Queue, pattern: Json): void</code> | *No description* |

<h3 id="@winglibs/eventbridge.platform.sim.Bus">platform.sim.Bus (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(props: BusProps?): Bus
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>onEvent(name: str, handler: inflight (Event): void, pattern: Json): void</code> | *No description* |
| <code>inflight putEvents(events: Array<PublishEvent>): void</code> | *No description* |
| <code>subscribeQueue(name: str, queue: Queue, pattern: Json): void</code> | *No description* |

<h3 id="@winglibs/eventbridge.platform.sim.EventBridgeBus">platform.sim.EventBridgeBus (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(props: BusProps?): EventBridgeBus
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight putEvents(events: Array<PublishEvent>): void</code> | *No description* |
| <code>subscribe(callback: inflight (Event): void, pattern: Json): Resource</code> | *No description* |

<h3 id="@winglibs/eventbridge.platform.awscdk.Bus">platform.awscdk.Bus (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(props: BusProps?): Bus
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>static addRulePermission(handler: str, arn: str): void</code> | *No description* |
| <code>onEvent(name: str, handler: inflight (Event): void, pattern: Json): void</code> | *No description* |
| <code>inflight putEvents(events: Array<PublishEvent>): void</code> | *No description* |
| <code>subscribeQueue(name: str, queue: Queue, pattern: Json): void</code> | *No description* |

<h3 id="@winglibs/eventbridge.platform.aws.Util">platform.aws.Util (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(): Util
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>static inflight _putEvent(name: str, event: PutEventCommandInput): void</code> | *No description* |
| <code>static inflight putEvent(name: str, events: Array<PublishEvent>): void</code> | *No description* |

<h3 id="@winglibs/eventbridge.IBus">IBus (interface)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>node</code> | <code>Node</code> | The tree node. |

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>onEvent(name: str, handler: inflight (Event): void, pattern: Json): void</code> | *No description* |
| <code>inflight putEvents(events: Array<PublishEvent>): void</code> | *No description* |
| <code>subscribeQueue(name: str, queue: Queue, pattern: Json): void</code> | *No description* |

<h3 id="@winglibs/eventbridge.BusProps">BusProps (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>debug</code> | <code>bool?</code> | *No description* |
| <code>name</code> | <code>str</code> | *No description* |

<h3 id="@winglibs/eventbridge.Event">Event (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>account</code> | <code>str</code> | *No description* |
| <code>detail</code> | <code>Json</code> | *No description* |
| <code>detailType</code> | <code>str</code> | *No description* |
| <code>id</code> | <code>str</code> | *No description* |
| <code>region</code> | <code>str</code> | *No description* |
| <code>resources</code> | <code>Array<str></code> | *No description* |
| <code>source</code> | <code>str</code> | *No description* |
| <code>time</code> | <code>str</code> | *No description* |
| <code>version</code> | <code>str</code> | *No description* |

<h3 id="@winglibs/eventbridge.PublishEvent">PublishEvent (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>detail</code> | <code>Json</code> | *No description* |
| <code>detailType</code> | <code>str</code> | *No description* |
| <code>resources</code> | <code>Array<str></code> | *No description* |
| <code>source</code> | <code>str</code> | *No description* |
| <code>version</code> | <code>str</code> | *No description* |

<h3 id="@winglibs/eventbridge.platform.aws.PutEventCommandEntry">platform.aws.PutEventCommandEntry (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>Detail</code> | <code>str</code> | *No description* |
| <code>DetailType</code> | <code>str</code> | *No description* |
| <code>EventBusName</code> | <code>str</code> | *No description* |
| <code>Resources</code> | <code>Array<str></code> | *No description* |
| <code>Source</code> | <code>str</code> | *No description* |

<h3 id="@winglibs/eventbridge.platform.aws.PutEventCommandInput">platform.aws.PutEventCommandInput (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>Entries</code> | <code>Array<PutEventCommandEntry></code> | *No description* |

