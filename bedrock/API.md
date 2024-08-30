<h2>API Reference</h2>

<h3>Table of Contents</h3>

- **Classes**
  - <a href="#@winglibs/bedrock.JokeMaker">JokeMaker</a>
  - <a href="#@winglibs/bedrock.Model">Model</a>

<h3 id="@winglibs/bedrock.JokeMaker">JokeMaker (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(): JokeMaker
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight makeJoke(topic: str): str</code> | *No description* |

<h3 id="@winglibs/bedrock.Model">Model (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(modelId: str): Model
</pre>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>modelId</code> | <code>str</code> | *No description* |

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight invoke(body: Json): Json</code> | *No description* |

