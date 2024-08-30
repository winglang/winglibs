<h2>API Reference</h2>

<h3>Table of Contents</h3>

- **Classes**
  - <a href="#@winglibs/slack.SlackUtils">SlackUtils</a>
  - <a href="#@winglibs/slack.Message">Message</a>
  - <a href="#@winglibs/slack.App">App</a>
  - <a href="#@winglibs/slack.Channel">Channel</a>
  - <a href="#@winglibs/slack.EventContext">EventContext</a>
  - <a href="#@winglibs/slack.EventContext_Mock">EventContext_Mock</a>
  - <a href="#@winglibs/slack.MockChannel">MockChannel</a>
  - <a href="#@winglibs/slack.Thread">Thread</a>
- **Interfaces**
  - <a href="#@winglibs/slack.IThread">IThread</a>
- **Structs**
  - <a href="#@winglibs/slack.Block">Block</a>
  - <a href="#@winglibs/slack.Field">Field</a>
  - <a href="#@winglibs/slack.Section">Section</a>
  - <a href="#@winglibs/slack.AppProps">AppProps</a>
  - <a href="#@winglibs/slack.CallbackEvent">CallbackEvent</a>
  - <a href="#@winglibs/slack.MessageCallbackEvent">MessageCallbackEvent</a>
  - <a href="#@winglibs/slack.SlackEvent">SlackEvent</a>
  - <a href="#@winglibs/slack.VerificationEvent">VerificationEvent</a>
- **Enums**
  - <a href="#@winglibs/slack.BlockType">BlockType</a>
  - <a href="#@winglibs/slack.FieldType">FieldType</a>

<h3 id="@winglibs/slack.SlackUtils">SlackUtils (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(): SlackUtils
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>static inflight post(body: Json, token: str): Json</code> | *No description* |

<h3 id="@winglibs/slack.Message">Message (inflight class)</h3>

Represents a Message block see: https://api.slack.com/block-kit

<h4>Constructor</h4>

<pre>
new(): Message
</pre>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>sections</code> | <code>MutArray<Section></code> | *No description* |

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight addSection(section: Section): void</code> | *No description* |
| <code>inflight toJson(): Json</code> | Returns Json representation of message |

<h3 id="@winglibs/slack.App">App (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(props: AppProps): App
</pre>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>api</code> | <code>Api</code> | *No description* |

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight channel(id: str): Channel</code> | Retrieve a channel object from a channel Id or name |
| <code>onEvent(eventName: str, handler: inflight (EventContext, Json): Json?): void</code> | Register an event handler (for available events see: https://api.slack.com/events) |

<h3 id="@winglibs/slack.Channel">Channel (inflight class)</h3>

Represents the context of a slack channel

<h4>Constructor</h4>

<pre>
new(): Channel
</pre>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>id</code> | <code>str</code> | The channel id |

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight post(message: str): Json</code> | Post raw text to a channel |
| <code>inflight postMessage(message: Message): Json</code> | Post a message block to a channel |

<h3 id="@winglibs/slack.EventContext">EventContext (inflight class)</h3>

Represents the context of an event callback

<h4>Constructor</h4>

<pre>
new(): EventContext
</pre>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>channel</code> | <code>Channel</code> | *No description* |
| <code>thread</code> | <code>Thread</code> | *No description* |

<h4>Methods</h4>

*No methods*

<h3 id="@winglibs/slack.EventContext_Mock">EventContext_Mock (inflight class)</h3>

Internally used for mocking event context

<h4>Constructor</h4>

<pre>
new(): EventContext_Mock
</pre>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>channel</code> | <code>Channel</code> | *No description* |
| <code>thread</code> | <code>Thread</code> | *No description* |

<h4>Methods</h4>

*No methods*

<h3 id="@winglibs/slack.MockChannel">MockChannel (inflight class)</h3>

Only used for internal testing

<h4>Constructor</h4>

<pre>
new(): MockChannel
</pre>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>id</code> | <code>str</code> | The channel id |

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight post(message: str): Json</code> | *No description* |
| <code>inflight postMessage(message: Message): Json</code> | *No description* |

<h3 id="@winglibs/slack.Thread">Thread (inflight class)</h3>

Represents the context of a slack thread

<h4>Constructor</h4>

<pre>
new(): Thread
</pre>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>channel</code> | <code>Channel</code> | The channel context |
| <code>timestamp</code> | <code>str</code> | The thread timestamp |

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight post(message: str): Json</code> | Post raw text to a thread |
| <code>inflight postMessage(message: Message): Json</code> | Post a message to a thread |

<h3 id="@winglibs/slack.IThread">IThread (interface)</h3>

The bahvioral interface of a thread

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight post(message: str): Json</code> | *No description* |
| <code>inflight postMessage(message: Message): Json</code> | *No description* |

<h3 id="@winglibs/slack.Block">Block (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>fields</code> | <code>Array<Field></code> | *No description* |
| <code>type</code> | <code>BlockType</code> | *No description* |

<h3 id="@winglibs/slack.Field">Field (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>text</code> | <code>str</code> | *No description* |
| <code>type</code> | <code>FieldType</code> | *No description* |

<h3 id="@winglibs/slack.Section">Section (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>fields</code> | <code>Array<Field></code> | *No description* |

<h3 id="@winglibs/slack.AppProps">AppProps (struct)</h3>

Properties for Slack bot

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>ignoreBots</code> | <code>bool?</code> | Whether events from bot users should be ignored (default: true) |
| <code>token</code> | <code>Secret</code> | The token secret to use for the app |

<h3 id="@winglibs/slack.CallbackEvent">CallbackEvent (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>app_id</code> | <code>str?</code> | *No description* |
| <code>bot_id</code> | <code>str?</code> | *No description* |
| <code>channel</code> | <code>str</code> | *No description* |
| <code>event_ts</code> | <code>str</code> | *No description* |
| <code>team</code> | <code>str?</code> | *No description* |
| <code>ts</code> | <code>str</code> | *No description* |
| <code>type</code> | <code>str</code> | *No description* |
| <code>user</code> | <code>str</code> | *No description* |

<h3 id="@winglibs/slack.MessageCallbackEvent">MessageCallbackEvent (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>app_id</code> | <code>str?</code> | *No description* |
| <code>bot_id</code> | <code>str?</code> | *No description* |
| <code>channel</code> | <code>str</code> | *No description* |
| <code>event_ts</code> | <code>str</code> | *No description* |
| <code>team</code> | <code>str?</code> | *No description* |
| <code>text</code> | <code>str</code> | *No description* |
| <code>ts</code> | <code>str</code> | *No description* |
| <code>type</code> | <code>str</code> | *No description* |
| <code>user</code> | <code>str</code> | *No description* |

<h3 id="@winglibs/slack.SlackEvent">SlackEvent (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>type</code> | <code>str</code> | *No description* |

<h3 id="@winglibs/slack.VerificationEvent">VerificationEvent (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>challenge</code> | <code>str</code> | *No description* |
| <code>token</code> | <code>str</code> | *No description* |
| <code>type</code> | <code>str</code> | *No description* |

<h3 id="@winglibs/slack.BlockType">BlockType (enum)</h3>

<h4>Values</h4>

| **Name** | **Description** |
| --- | --- |
| <code>section</code> | *No description* |

<h3 id="@winglibs/slack.FieldType">FieldType (enum)</h3>

<h4>Values</h4>

| **Name** | **Description** |
| --- | --- |
| <code>plain_text</code> | *No description* |
| <code>mrkdwn</code> | *No description* |

