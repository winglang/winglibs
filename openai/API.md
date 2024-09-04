## API Reference

### Table of Contents

- **Classes**
  - <a href="#@winglibs/openai.OpenAI">OpenAI</a>
- **Structs**
  - <a href="#@winglibs/openai.CompletionParams">CompletionParams</a>
  - <a href="#@winglibs/openai.OpenAIProps">OpenAIProps</a>

### OpenAI (preflight class) <a class="wing-docs-anchor" id="@winglibs/openai.OpenAI"></a>

*No description*

#### Constructor

```
new(props: OpenAIProps?): OpenAI
```

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight createCompletion(prompt: str, params: CompletionParams?): str</code> | *No description* |
| <code>static inflight createNewInflightClient(apiKey: str, org: str?): IClient</code> | *No description* |

### CompletionParams (struct) <a class="wing-docs-anchor" id="@winglibs/openai.CompletionParams"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>maxTokens</code> | <code>num?</code> | *No description* |
| <code>model</code> | <code>str?</code> | *No description* |

### OpenAIProps (struct) <a class="wing-docs-anchor" id="@winglibs/openai.OpenAIProps"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>apiKey</code> | <code>str?</code> | *No description* |
| <code>apiKeySecret</code> | <code>Secret?</code> | *No description* |
| <code>org</code> | <code>str?</code> | *No description* |
| <code>orgSecret</code> | <code>Secret?</code> | *No description* |

