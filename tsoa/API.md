## API Reference

### Table of Contents

- **Classes**
  - <a href="#@winglibs/tsoa.Service_tfaws">Service_tfaws</a>
  - <a href="#@winglibs/tsoa.Service_sim">Service_sim</a>
  - <a href="#@winglibs/tsoa.Service">Service</a>
- **Interfaces**
  - <a href="#@winglibs/tsoa.IService">IService</a>
- **Structs**
  - <a href="#@winglibs/tsoa.LiftOptions">LiftOptions</a>
  - <a href="#@winglibs/tsoa.ServiceProps">ServiceProps</a>
  - <a href="#@winglibs/tsoa.SpecProps">SpecProps</a>
  - <a href="#@winglibs/tsoa.StartServiceOptions">StartServiceOptions</a>

### Service_tfaws (preflight class) <a class="wing-docs-anchor" id="@winglibs/tsoa.Service_tfaws"></a>

*No description*

#### Constructor

```
new(props: ServiceProps): Service_tfaws
```

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>specFile</code> | <code>str</code> | *No description* |
| <code>url</code> | <code>str</code> | *No description* |

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>lift(client: Resource, ops: LiftOptions): void</code> | *No description* |

### Service_sim (preflight class) <a class="wing-docs-anchor" id="@winglibs/tsoa.Service_sim"></a>

*No description*

#### Constructor

```
new(props: ServiceProps): Service_sim
```

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>specFile</code> | <code>str</code> | *No description* |
| <code>url</code> | <code>str</code> | *No description* |

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>lift(client: Resource, ops: LiftOptions): void</code> | *No description* |

### Service (preflight class) <a class="wing-docs-anchor" id="@winglibs/tsoa.Service"></a>

*No description*

#### Constructor

```
new(props: ServiceProps): Service
```

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>specFile</code> | <code>str</code> | *No description* |
| <code>url</code> | <code>str</code> | *No description* |

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>lift(client: Resource, ops: LiftOptions): void</code> | *No description* |

### IService (interface) <a class="wing-docs-anchor" id="@winglibs/tsoa.IService"></a>

*No description*

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>lift(client: Resource, ops: LiftOptions): void</code> | *No description* |

### LiftOptions (struct) <a class="wing-docs-anchor" id="@winglibs/tsoa.LiftOptions"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>allow</code> | <code>Array<str></code> | *No description* |
| <code>id</code> | <code>str</code> | *No description* |

### ServiceProps (struct) <a class="wing-docs-anchor" id="@winglibs/tsoa.ServiceProps"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>controllerPathGlobs</code> | <code>Array<str></code> | *No description* |
| <code>entryFile</code> | <code>str?</code> | *No description* |
| <code>outputDirectory</code> | <code>str</code> | *No description* |
| <code>routesDir</code> | <code>str</code> | *No description* |
| <code>spec</code> | <code>SpecProps?</code> | *No description* |
| <code>watchDir</code> | <code>str?</code> | *No description* |

### SpecProps (struct) <a class="wing-docs-anchor" id="@winglibs/tsoa.SpecProps"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>outputDirectory</code> | <code>str?</code> | *No description* |
| <code>specVersion</code> | <code>num?</code> | *No description* |

### StartServiceOptions (struct) <a class="wing-docs-anchor" id="@winglibs/tsoa.StartServiceOptions"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>basedir</code> | <code>str</code> | *No description* |
| <code>clients</code> | <code>Map<Resource></code> | *No description* |
| <code>currentdir</code> | <code>str</code> | *No description* |
| <code>homeEnv</code> | <code>str</code> | *No description* |
| <code>lastPort</code> | <code>str?</code> | *No description* |
| <code>options</code> | <code>ServiceProps</code> | *No description* |
| <code>pathEnv</code> | <code>str</code> | *No description* |
| <code>workdir</code> | <code>str</code> | *No description* |

