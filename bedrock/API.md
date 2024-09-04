## API Reference

### Table of Contents

- **Classes**
  - <a href="#@winglibs/bedrock.JokeMaker">JokeMaker</a>
  - <a href="#@winglibs/bedrock.Model">Model</a>

### JokeMaker (preflight class) <a class="wing-docs-anchor" id="@winglibs/bedrock.JokeMaker"></a>

*No description*

#### Constructor

```
new(): JokeMaker
```

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight makeJoke(topic: str): str</code> | *No description* |

### Model (preflight class) <a class="wing-docs-anchor" id="@winglibs/bedrock.Model"></a>

*No description*

#### Constructor

```
new(modelId: str): Model
```

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>modelId</code> | <code>str</code> | *No description* |

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight invoke(body: Json): Json</code> | *No description* |

