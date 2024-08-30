<h2>API Reference</h2>

<h3>Table of Contents</h3>

- **Classes**
  - <a href="#@winglibs/websockets.WebSocket">WebSocket</a>
  - <a href="#@winglibs/websockets.platform.WebSocket_tfaws">platform.WebSocket_tfaws</a>
  - <a href="#@winglibs/websockets.platform.WebSocket_sim">platform.WebSocket_sim</a>
  - <a href="#@winglibs/websockets.platform.WebSocket_awscdk">platform.WebSocket_awscdk</a>
- **Interfaces**
  - <a href="#@winglibs/websockets.platform.aws.IAwsWebSocket">platform.aws.IAwsWebSocket</a>
  - <a href="#@winglibs/websockets.commons.IWebSocket">commons.IWebSocket</a>
- **Structs**
  - <a href="#@winglibs/websockets.platform.aws.WebSocketAwsRequest">platform.aws.WebSocketAwsRequest</a>
  - <a href="#@winglibs/websockets.platform.aws.WebSocketAwsRequestContext">platform.aws.WebSocketAwsRequestContext</a>
  - <a href="#@winglibs/websockets.platform.aws.WebSocketAwsResponse">platform.aws.WebSocketAwsResponse</a>
  - <a href="#@winglibs/websockets.commons.WebSocketProps">commons.WebSocketProps</a>

<h3 id="@winglibs/websockets.WebSocket">WebSocket (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(props: WebSocketProps): WebSocket
</pre>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>url</code> | <code>str</code> | *No description* |

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>onConnect(handler: inflight (str): void): void</code> | *No description* |
| <code>onDisconnect(handler: inflight (str): void): void</code> | *No description* |
| <code>onMessage(handler: inflight (str, str): void): void</code> | *No description* |
| <code>inflight sendMessage(connectionId: str, message: str): void</code> | *No description* |

<h3 id="@winglibs/websockets.platform.WebSocket_tfaws">platform.WebSocket_tfaws (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(props: WebSocketProps): WebSocket_tfaws
</pre>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>url</code> | <code>str</code> | *No description* |

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>addRoute(handler: Function, routeKey: str): void</code> | *No description* |
| <code>onConnect(handler: inflight (str): void): void</code> | *No description* |
| <code>onDisconnect(handler: inflight (str): void): void</code> | *No description* |
| <code>onMessage(handler: inflight (str, str): void): void</code> | *No description* |
| <code>inflight sendMessage(connectionId: str, message: str): void</code> | *No description* |

<h3 id="@winglibs/websockets.platform.WebSocket_sim">platform.WebSocket_sim (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(props: WebSocketProps): WebSocket_sim
</pre>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>url</code> | <code>str</code> | *No description* |

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>onConnect(handler: inflight (str): void): void</code> | *No description* |
| <code>onDisconnect(handler: inflight (str): void): void</code> | *No description* |
| <code>onMessage(handler: inflight (str, str): void): void</code> | *No description* |
| <code>inflight sendMessage(connectionId: str, message: str): void</code> | *No description* |

<h3 id="@winglibs/websockets.platform.WebSocket_awscdk">platform.WebSocket_awscdk (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(props: WebSocketProps): WebSocket_awscdk
</pre>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>url</code> | <code>str</code> | *No description* |

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>addRoute(handler: Function, routeKey: str): void</code> | *No description* |
| <code>onConnect(handler: inflight (str): void): void</code> | *No description* |
| <code>onDisconnect(handler: inflight (str): void): void</code> | *No description* |
| <code>onMessage(handler: inflight (str, str): void): void</code> | *No description* |
| <code>inflight sendMessage(connectionId: str, message: str): void</code> | *No description* |

<h3 id="@winglibs/websockets.platform.aws.IAwsWebSocket">platform.aws.IAwsWebSocket (interface)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>node</code> | <code>Node</code> | The tree node. |

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>addRoute(handler: Function, routeKey: str): void</code> | *No description* |
| <code>onConnect(handler: inflight (str): void): void</code> | *No description* |
| <code>onDisconnect(handler: inflight (str): void): void</code> | *No description* |
| <code>onMessage(handler: inflight (str, str): void): void</code> | *No description* |
| <code>inflight sendMessage(connectionId: str, message: str): void</code> | *No description* |

<h3 id="@winglibs/websockets.commons.IWebSocket">commons.IWebSocket (interface)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>node</code> | <code>Node</code> | The tree node. |

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>onConnect(handler: inflight (str): void): void</code> | *No description* |
| <code>onDisconnect(handler: inflight (str): void): void</code> | *No description* |
| <code>onMessage(handler: inflight (str, str): void): void</code> | *No description* |
| <code>inflight sendMessage(connectionId: str, message: str): void</code> | *No description* |

<h3 id="@winglibs/websockets.platform.aws.WebSocketAwsRequest">platform.aws.WebSocketAwsRequest (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>body</code> | <code>str</code> | *No description* |
| <code>requestContext</code> | <code>WebSocketAwsRequestContext</code> | *No description* |

<h3 id="@winglibs/websockets.platform.aws.WebSocketAwsRequestContext">platform.aws.WebSocketAwsRequestContext (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>connectionId</code> | <code>str</code> | *No description* |
| <code>routeKey</code> | <code>str</code> | *No description* |

<h3 id="@winglibs/websockets.platform.aws.WebSocketAwsResponse">platform.aws.WebSocketAwsResponse (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>body</code> | <code>str?</code> | *No description* |
| <code>statusCode</code> | <code>num</code> | *No description* |

<h3 id="@winglibs/websockets.commons.WebSocketProps">commons.WebSocketProps (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>name</code> | <code>str</code> | *No description* |
| <code>stageName</code> | <code>str?</code> | *No description* |

