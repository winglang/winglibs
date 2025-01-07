## API Reference

### Table of Contents

- **Classes**
  - <a href="#@winglibs/containers.Workload">Workload</a>
  - <a href="#@winglibs/containers.sim.Workload_sim">sim.Workload_sim</a>
  - <a href="#@winglibs/containers.helm.Chart">helm.Chart</a>
  - <a href="#@winglibs/containers.eks.Workload_tfaws">eks.Workload_tfaws</a>
  - <a href="#@winglibs/containers.eks.Vpc">eks.Vpc</a>
  - <a href="#@winglibs/containers.eks.Cluster">eks.Cluster</a>
  - <a href="#@winglibs/containers.eks.ClusterBase">eks.ClusterBase</a>
  - <a href="#@winglibs/containers.eks.Repository">eks.Repository</a>
  - <a href="#@winglibs/containers.eks.Aws">eks.Aws</a>
- **Interfaces**
  - <a href="#@winglibs/containers.IForward">IForward</a>
  - <a href="#@winglibs/containers.IWorkload">IWorkload</a>
- **Structs**
  - <a href="#@winglibs/containers.ContainerOpts">ContainerOpts</a>
  - <a href="#@winglibs/containers.ForwardOptions">ForwardOptions</a>
  - <a href="#@winglibs/containers.WorkloadProps">WorkloadProps</a>

### Workload (preflight class) <a class="wing-docs-anchor" id="@winglibs/containers.Workload"></a>

*No description*

#### Constructor

```
new(props: WorkloadProps): Workload
```

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>internalUrl</code> | <code>str?</code> | *No description* |
| <code>publicUrl</code> | <code>str?</code> | *No description* |

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>forward(opts: ForwardOptions?): IForward</code> | *No description* |

### sim.Workload_sim (preflight class) <a class="wing-docs-anchor" id="@winglibs/containers.sim.Workload_sim"></a>

*No description*

#### Constructor

```
new(props: WorkloadProps): Workload_sim
```

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>internalUrl</code> | <code>str?</code> | *No description* |
| <code>publicUrl</code> | <code>str?</code> | *No description* |

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>forward(opts: ForwardOptions?): IForward</code> | *No description* |

### helm.Chart (preflight class) <a class="wing-docs-anchor" id="@winglibs/containers.helm.Chart"></a>

*No description*

#### Constructor

```
new(props: WorkloadProps): Chart
```

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>apiObjects</code> | <code>Array<ApiObject></code> | Returns all the included API objects. |
| <code>labels</code> | <code>Map<str></code> | Labels applied to all resources in this chart. |
| <code>namespace</code> | <code>str?</code> | The default namespace for all objects in this chart. |

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>forward(opts: ForwardOptions?): IForward</code> | *No description* |
| <code>toHelm(workdir: str): str</code> | *No description* |
| <code>static toHelmChart(wingdir: str, chart: Chart): str</code> | *No description* |
| <code>addDependency(dependencies: Array<IConstruct>): void</code> | Create a dependency between this Chart and other constructs. |
| <code>generateObjectName(apiObject: ApiObject): str</code> | Generates a app-unique name for an object given it's construct node path. |
| <code>static isChart(x: any): bool</code> | Return whether the given object is a Chart. |
| <code>static of(c: IConstruct): Chart</code> | Finds the chart in which a node is defined. |
| <code>toJson(): Array<any></code> | Renders this chart to a set of Kubernetes JSON resources. |

### eks.Workload_tfaws (preflight class) <a class="wing-docs-anchor" id="@winglibs/containers.eks.Workload_tfaws"></a>

*No description*

#### Constructor

```
new(props: WorkloadProps): Workload_tfaws
```

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>internalUrl</code> | <code>str?</code> | *No description* |
| <code>publicUrl</code> | <code>str?</code> | *No description* |

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>forward(opts: ForwardOptions?): IForward</code> | *No description* |

### eks.Vpc (preflight class) <a class="wing-docs-anchor" id="@winglibs/containers.eks.Vpc"></a>

*No description*

#### Constructor

```
new(props: VpcProps?): Vpc
```

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>id</code> | <code>str</code> | *No description* |
| <code>privateSubnets</code> | <code>Array<str></code> | *No description* |
| <code>publicSubnets</code> | <code>Array<str></code> | *No description* |

#### Methods

*No methods*

### eks.Cluster (preflight class) <a class="wing-docs-anchor" id="@winglibs/containers.eks.Cluster"></a>

*No description*

#### Constructor

```
new(clusterName: str): Cluster
```

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>attributes(): ClusterAttributes</code> | *No description* |
| <code>static getOrCreate(scope: IResource): ICluster</code> | *No description* |
| <code>helmProvider(): TerraformProvider</code> | *No description* |
| <code>kubernetesProvider(): TerraformProvider</code> | *No description* |

### eks.ClusterBase (preflight class) <a class="wing-docs-anchor" id="@winglibs/containers.eks.ClusterBase"></a>

*No description*

#### Constructor

```
new(): ClusterBase
```

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>attributes(): ClusterAttributes</code> | *No description* |
| <code>helmProvider(): TerraformProvider</code> | *No description* |
| <code>kubernetesProvider(): TerraformProvider</code> | *No description* |

### eks.Repository (preflight class) <a class="wing-docs-anchor" id="@winglibs/containers.eks.Repository"></a>

*No description*

#### Constructor

```
new(props: RepositoryProps): Repository
```

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>deps</code> | <code>Array<ITerraformDependable></code> | *No description* |
| <code>image</code> | <code>str</code> | *No description* |

#### Methods

*No methods*

### eks.Aws (preflight class) <a class="wing-docs-anchor" id="@winglibs/containers.eks.Aws"></a>

*No description*

#### Constructor

```
new(): Aws
```

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>accountId(): str</code> | *No description* |
| <code>static getOrCreate(scope: IResource): Aws</code> | *No description* |
| <code>region(): str</code> | *No description* |

### IForward (interface) <a class="wing-docs-anchor" id="@winglibs/containers.IForward"></a>

*No description*

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>fromApi(): inflight (request: ApiRequest): ApiResponse?</code> | *No description* |
| <code>fromBucketEvent(): inflight (key: str, type: BucketEventType): void</code> | *No description* |
| <code>fromQueue(): inflight (message: str): void</code> | *No description* |
| <code>fromSchedule(): inflight (): void</code> | *No description* |
| <code>fromTopic(): inflight (message: str): void</code> | *No description* |

### IWorkload (interface) <a class="wing-docs-anchor" id="@winglibs/containers.IWorkload"></a>

*No description*

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>forward(opts: ForwardOptions?): IForward</code> | *No description* |

### ContainerOpts (struct) <a class="wing-docs-anchor" id="@winglibs/containers.ContainerOpts"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>args</code> | <code>Array<str>?</code> | *No description* |
| <code>env</code> | <code>Map<str?>?</code> | *No description* |
| <code>image</code> | <code>str</code> | *No description* |
| <code>name</code> | <code>str</code> | *No description* |
| <code>port</code> | <code>num?</code> | *No description* |
| <code>public</code> | <code>bool?</code> | *No description* |
| <code>readiness</code> | <code>str?</code> | *No description* |
| <code>replicas</code> | <code>num?</code> | *No description* |
| <code>sourceHash</code> | <code>str?</code> | *No description* |
| <code>sources</code> | <code>str?</code> | *No description* |

### ForwardOptions (struct) <a class="wing-docs-anchor" id="@winglibs/containers.ForwardOptions"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>method</code> | <code>HttpMethod?</code> | *No description* |
| <code>route</code> | <code>str?</code> | *No description* |

### WorkloadProps (struct) <a class="wing-docs-anchor" id="@winglibs/containers.WorkloadProps"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>args</code> | <code>Array<str>?</code> | *No description* |
| <code>env</code> | <code>Map<str?>?</code> | *No description* |
| <code>image</code> | <code>str</code> | *No description* |
| <code>name</code> | <code>str</code> | *No description* |
| <code>port</code> | <code>num?</code> | *No description* |
| <code>public</code> | <code>bool?</code> | *No description* |
| <code>readiness</code> | <code>str?</code> | *No description* |
| <code>replicas</code> | <code>num?</code> | *No description* |
| <code>sourceHash</code> | <code>str?</code> | *No description* |
| <code>sources</code> | <code>str?</code> | *No description* |

