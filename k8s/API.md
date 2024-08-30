<h2>API Reference</h2>

<h3>Table of Contents</h3>

- **Classes**
  - <a href="#@winglibs/k8s.ApiObject">ApiObject</a>
- **Structs**
  - <a href="#@winglibs/k8s.ApiObjectProps">ApiObjectProps</a>

<h3 id="@winglibs/k8s.ApiObject">ApiObject (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(props: ApiObjectProps): ApiObject
</pre>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>apiGroup</code> | <code>str</code> | The group portion of the API version (e.g. `authorization.k8s.io`). |
| <code>apiVersion</code> | <code>str</code> | The object's API version (e.g. `authorization.k8s.io/v1`). |
| <code>chart</code> | <code>Chart</code> | The chart in which this object is defined. |
| <code>kind</code> | <code>str</code> | The object kind. |
| <code>metadata</code> | <code>ApiObjectMetadataDefinition</code> | Metadata associated with this API object. |
| <code>name</code> | <code>str</code> | The name of the API object. |

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>addDependency(dependencies: Array<IConstruct>): void</code> | Create a dependency between this ApiObject and other constructs. |
| <code>addJsonPatch(ops: Array<JsonPatch>): void</code> | Applies a set of RFC-6902 JSON-Patch operations to the manifest synthesized for this API object. |
| <code>static isApiObject(o: any): bool</code> | Return whether the given object is an `ApiObject`. |
| <code>static of(c: IConstruct): ApiObject</code> | Returns the `ApiObject` named `Resource` which is a child of the given construct. |
| <code>toJson(): any</code> | Renders the object to Kubernetes JSON. |

<h3 id="@winglibs/k8s.ApiObjectProps">ApiObjectProps (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>apiVersion</code> | <code>str</code> | API version. |
| <code>kind</code> | <code>str</code> | Resource kind. |
| <code>metadata</code> | <code>ApiObjectMetadata?</code> | Object metadata. |
| <code>spec</code> | <code>Json?</code> | *No description* |

