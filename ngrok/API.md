<h2>API Reference</h2>

<h3>Table of Contents</h3>

- **Classes**
  - <a href="#@winglibs/ngrok.Tunnel">Tunnel</a>
- **Interfaces**
  - <a href="#@winglibs/ngrok.OnConnectHandler">OnConnectHandler</a>
- **Structs**
  - <a href="#@winglibs/ngrok.NgrokProps">NgrokProps</a>

<h3 id="@winglibs/ngrok.Tunnel">Tunnel (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(url: str, props: NgrokProps?): Tunnel
</pre>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>url</code> | <code>str</code> | *No description* |

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>onConnect(handler: inflight (str): void): void</code> | *No description* |

<h3 id="@winglibs/ngrok.OnConnectHandler">OnConnectHandler (interface)</h3>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight handle(url: str): void</code> | *No description* |

<h3 id="@winglibs/ngrok.NgrokProps">NgrokProps (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>domain</code> | <code>str?</code> | *No description* |
| <code>onConnect</code> | <code>(inflight (str): void)?</code> | *No description* |

