## API Reference

### Table of Contents

- **Classes**
  - <a href="#@winglibs/sagemaker.Endpoint">Endpoint</a>
  - <a href="#@winglibs/sagemaker.SageMaker_tfaws">SageMaker_tfaws</a>
  - <a href="#@winglibs/sagemaker.SageMaker_sim">SageMaker_sim</a>
- **Interfaces**
  - <a href="#@winglibs/sagemaker.ISageMaker">ISageMaker</a>
- **Structs**
  - <a href="#@winglibs/sagemaker.InvocationOptions">InvocationOptions</a>
  - <a href="#@winglibs/sagemaker.InvocationOutput">InvocationOutput</a>

### Endpoint (preflight class) <a class="wing-docs-anchor" id="@winglibs/sagemaker.Endpoint"></a>

*No description*

#### Constructor

```
new(endpointName: str, inferenceComponentName: str): Endpoint
```

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>endpointName</code> | <code>str</code> | *No description* |

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight invoke(body: Json, options: InvocationOptions?): InvocationOutput</code> | *No description* |

### SageMaker_tfaws (preflight class) <a class="wing-docs-anchor" id="@winglibs/sagemaker.SageMaker_tfaws"></a>

*No description*

#### Constructor

```
new(endpointName: str, inferenceComponentName: str): SageMaker_tfaws
```

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>endpointName</code> | <code>str</code> | *No description* |
| <code>inferenceComponentName</code> | <code>str</code> | *No description* |

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight invoke(body: Json, options: InvocationOptions?): InvocationOutput</code> | *No description* |

### SageMaker_sim (preflight class) <a class="wing-docs-anchor" id="@winglibs/sagemaker.SageMaker_sim"></a>

*No description*

#### Constructor

```
new(endpointName: str, inferenceName: str): SageMaker_sim
```

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight invoke(body: Json, options: InvocationOptions?): InvocationOutput</code> | *No description* |
| <code>setMockResponse(fn: inflight (Json, InvocationOptions?): InvocationOutput): void</code> | *No description* |

### ISageMaker (interface) <a class="wing-docs-anchor" id="@winglibs/sagemaker.ISageMaker"></a>

*No description*

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight invoke(body: Json, InvocationOptions: InvocationOptions?): InvocationOutput</code> | *No description* |

### InvocationOptions (struct) <a class="wing-docs-anchor" id="@winglibs/sagemaker.InvocationOptions"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>Accept</code> | <code>str?</code> | *No description* |
| <code>ContentType</code> | <code>str?</code> | *No description* |
| <code>CustomAttributes</code> | <code>str?</code> | *No description* |
| <code>EnableExplanations</code> | <code>str?</code> | *No description* |
| <code>InferenceComponentName</code> | <code>str?</code> | *No description* |
| <code>InferenceId</code> | <code>str?</code> | *No description* |
| <code>TargetContainerHostname</code> | <code>str?</code> | *No description* |
| <code>TargetModel</code> | <code>str?</code> | *No description* |
| <code>TargetVariant</code> | <code>str?</code> | *No description* |

### InvocationOutput (struct) <a class="wing-docs-anchor" id="@winglibs/sagemaker.InvocationOutput"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>Body</code> | <code>str</code> | *No description* |
| <code>ContentType</code> | <code>str?</code> | *No description* |
| <code>CustomAttributes</code> | <code>str?</code> | *No description* |
| <code>InvokedProductionVariant</code> | <code>str?</code> | *No description* |

