## API Reference

### Table of Contents

- **Classes**
  - <a href="#@winglibs/ngrok.Tunnel">Tunnel</a>
- **Interfaces**
  - <a href="#@winglibs/ngrok.OnConnectHandler">OnConnectHandler</a>
- **Structs**
  - <a href="#@winglibs/ngrok.NgrokProps">NgrokProps</a>

### Tunnel (preflight class) <a class="wing-docs-anchor" id="@winglibs/ngrok.Tunnel"></a>

*No description*

#### Constructor

```
new(url: str, props: NgrokProps?): Tunnel
```

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>url</code> | <code>str</code> | *No description* |

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>onConnect(handler: inflight (str): void): void</code> | *No description* |

### OnConnectHandler (interface) <a class="wing-docs-anchor" id="@winglibs/ngrok.OnConnectHandler"></a>

*No description*

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight handle(url: str): void</code> | *No description* |

### NgrokProps (struct) <a class="wing-docs-anchor" id="@winglibs/ngrok.NgrokProps"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>domain</code> | <code>str?</code> | *No description* |
| <code>onConnect</code> | <code>(inflight (str): void)?</code> | *No description* |

