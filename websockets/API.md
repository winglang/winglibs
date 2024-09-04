## API Reference

### Table of Contents

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

### WebSocket (preflight class) <a class="wing-docs-anchor" id="@winglibs/websockets.WebSocket"></a>

*No description*

#### Constructor

```
new(props: WebSocketProps): WebSocket
```

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>url</code> | <code>str</code> | *No description* |

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>onConnect(handler: inflight (str): void): void</code> | *No description* |
| <code>onDisconnect(handler: inflight (str): void): void</code> | *No description* |
| <code>onMessage(handler: inflight (str, str): void): void</code> | *No description* |
| <code>inflight sendMessage(connectionId: str, message: str): void</code> | *No description* |

### platform.WebSocket_tfaws (preflight class) <a class="wing-docs-anchor" id="@winglibs/websockets.platform.WebSocket_tfaws"></a>

*No description*

#### Constructor

```
new(props: WebSocketProps): WebSocket_tfaws
```

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>url</code> | <code>str</code> | *No description* |

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>addRoute(handler: Function, routeKey: str): void</code> | *No description* |
| <code>onConnect(handler: inflight (str): void): void</code> | *No description* |
| <code>onDisconnect(handler: inflight (str): void): void</code> | *No description* |
| <code>onMessage(handler: inflight (str, str): void): void</code> | *No description* |
| <code>inflight sendMessage(connectionId: str, message: str): void</code> | *No description* |

### platform.WebSocket_sim (preflight class) <a class="wing-docs-anchor" id="@winglibs/websockets.platform.WebSocket_sim"></a>

*No description*

#### Constructor

```
new(props: WebSocketProps): WebSocket_sim
```

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>url</code> | <code>str</code> | *No description* |

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>onConnect(handler: inflight (str): void): void</code> | *No description* |
| <code>onDisconnect(handler: inflight (str): void): void</code> | *No description* |
| <code>onMessage(handler: inflight (str, str): void): void</code> | *No description* |
| <code>inflight sendMessage(connectionId: str, message: str): void</code> | *No description* |

### platform.WebSocket_awscdk (preflight class) <a class="wing-docs-anchor" id="@winglibs/websockets.platform.WebSocket_awscdk"></a>

*No description*

#### Constructor

```
new(props: WebSocketProps): WebSocket_awscdk
```

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>url</code> | <code>str</code> | *No description* |

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>addRoute(handler: Function, routeKey: str): void</code> | *No description* |
| <code>onConnect(handler: inflight (str): void): void</code> | *No description* |
| <code>onDisconnect(handler: inflight (str): void): void</code> | *No description* |
| <code>onMessage(handler: inflight (str, str): void): void</code> | *No description* |
| <code>inflight sendMessage(connectionId: str, message: str): void</code> | *No description* |

### platform.aws.IAwsWebSocket (interface) <a class="wing-docs-anchor" id="@winglibs/websockets.platform.aws.IAwsWebSocket"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>node</code> | <code>Node</code> | The tree node. |

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>addRoute(handler: Function, routeKey: str): void</code> | *No description* |
| <code>onConnect(handler: inflight (str): void): void</code> | *No description* |
| <code>onDisconnect(handler: inflight (str): void): void</code> | *No description* |
| <code>onMessage(handler: inflight (str, str): void): void</code> | *No description* |
| <code>inflight sendMessage(connectionId: str, message: str): void</code> | *No description* |

### commons.IWebSocket (interface) <a class="wing-docs-anchor" id="@winglibs/websockets.commons.IWebSocket"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>node</code> | <code>Node</code> | The tree node. |

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>onConnect(handler: inflight (str): void): void</code> | *No description* |
| <code>onDisconnect(handler: inflight (str): void): void</code> | *No description* |
| <code>onMessage(handler: inflight (str, str): void): void</code> | *No description* |
| <code>inflight sendMessage(connectionId: str, message: str): void</code> | *No description* |

### platform.aws.WebSocketAwsRequest (struct) <a class="wing-docs-anchor" id="@winglibs/websockets.platform.aws.WebSocketAwsRequest"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>body</code> | <code>str</code> | *No description* |
| <code>requestContext</code> | <code>WebSocketAwsRequestContext</code> | *No description* |

### platform.aws.WebSocketAwsRequestContext (struct) <a class="wing-docs-anchor" id="@winglibs/websockets.platform.aws.WebSocketAwsRequestContext"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>connectionId</code> | <code>str</code> | *No description* |
| <code>routeKey</code> | <code>str</code> | *No description* |

### platform.aws.WebSocketAwsResponse (struct) <a class="wing-docs-anchor" id="@winglibs/websockets.platform.aws.WebSocketAwsResponse"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>body</code> | <code>str?</code> | *No description* |
| <code>statusCode</code> | <code>num</code> | *No description* |

### commons.WebSocketProps (struct) <a class="wing-docs-anchor" id="@winglibs/websockets.commons.WebSocketProps"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>name</code> | <code>str</code> | *No description* |
| <code>stageName</code> | <code>str?</code> | *No description* |

