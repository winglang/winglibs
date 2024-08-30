<h2>API Reference</h2>

<h3>Table of Contents</h3>

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

<h3 id="@winglibs/tsoa.Service_tfaws">Service_tfaws (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(props: ServiceProps): Service_tfaws
</pre>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>specFile</code> | <code>str</code> | *No description* |
| <code>url</code> | <code>str</code> | *No description* |

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>lift(client: Resource, ops: LiftOptions): void</code> | *No description* |

<h3 id="@winglibs/tsoa.Service_sim">Service_sim (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(props: ServiceProps): Service_sim
</pre>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>specFile</code> | <code>str</code> | *No description* |
| <code>url</code> | <code>str</code> | *No description* |

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>lift(client: Resource, ops: LiftOptions): void</code> | *No description* |

<h3 id="@winglibs/tsoa.Service">Service (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(props: ServiceProps): Service
</pre>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>specFile</code> | <code>str</code> | *No description* |
| <code>url</code> | <code>str</code> | *No description* |

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>lift(client: Resource, ops: LiftOptions): void</code> | *No description* |

<h3 id="@winglibs/tsoa.IService">IService (interface)</h3>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>lift(client: Resource, ops: LiftOptions): void</code> | *No description* |

<h3 id="@winglibs/tsoa.LiftOptions">LiftOptions (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>allow</code> | <code>Array<str></code> | *No description* |
| <code>id</code> | <code>str</code> | *No description* |

<h3 id="@winglibs/tsoa.ServiceProps">ServiceProps (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>controllerPathGlobs</code> | <code>Array<str></code> | *No description* |
| <code>entryFile</code> | <code>str?</code> | *No description* |
| <code>outputDirectory</code> | <code>str</code> | *No description* |
| <code>routesDir</code> | <code>str</code> | *No description* |
| <code>spec</code> | <code>SpecProps?</code> | *No description* |
| <code>watchDir</code> | <code>str?</code> | *No description* |

<h3 id="@winglibs/tsoa.SpecProps">SpecProps (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>outputDirectory</code> | <code>str?</code> | *No description* |
| <code>specVersion</code> | <code>num?</code> | *No description* |

<h3 id="@winglibs/tsoa.StartServiceOptions">StartServiceOptions (struct)</h3>

<h4>Properties</h4>

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

