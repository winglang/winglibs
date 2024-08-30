<h2>API Reference</h2>

<h3>Table of Contents</h3>

- **Classes**
  - <a href="#@winglibs/openai.OpenAI">OpenAI</a>
- **Structs**
  - <a href="#@winglibs/openai.CompletionParams">CompletionParams</a>
  - <a href="#@winglibs/openai.OpenAIProps">OpenAIProps</a>

<h3 id="@winglibs/openai.OpenAI">OpenAI (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(props: OpenAIProps?): OpenAI
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight createCompletion(prompt: str, params: CompletionParams?): str</code> | *No description* |
| <code>static inflight createNewInflightClient(apiKey: str, org: str?): IClient</code> | *No description* |

<h3 id="@winglibs/openai.CompletionParams">CompletionParams (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>maxTokens</code> | <code>num?</code> | *No description* |
| <code>model</code> | <code>str?</code> | *No description* |

<h3 id="@winglibs/openai.OpenAIProps">OpenAIProps (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>apiKey</code> | <code>str?</code> | *No description* |
| <code>apiKeySecret</code> | <code>Secret?</code> | *No description* |
| <code>org</code> | <code>str?</code> | *No description* |
| <code>orgSecret</code> | <code>Secret?</code> | *No description* |

