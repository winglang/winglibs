<h2>API Reference</h2>

<h3>Table of Contents</h3>

- **Classes**
  - <a href="#@winglibs/react.Utils">Utils</a>
  - <a href="#@winglibs/react.AppTfAws">AppTfAws</a>
  - <a href="#@winglibs/react.AppSim">AppSim</a>
  - <a href="#@winglibs/react.App">App</a>
  - <a href="#@winglibs/react.AppBase">AppBase</a>
- **Interfaces**
  - <a href="#@winglibs/react.IApp">IApp</a>
- **Structs**
  - <a href="#@winglibs/react.AppProps">AppProps</a>

<h3 id="@winglibs/react.Utils">Utils (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(): Utils
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>static inflight exec(command: str, env: MutMap<str>, cwd: str): inflight (): void</code> | *No description* |
| <code>static execSync(command: str, env: MutMap<str>, cwd: str): void</code> | *No description* |
| <code>static inflight serveStaticFiles(path: str, port: num): inflight (): void</code> | *No description* |

<h3 id="@winglibs/react.AppTfAws">AppTfAws (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(props: AppProps): AppTfAws
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>_preSynthesize(): void</code> | *No description* |
| <code>getUrl(): str</code> | *No description* |
| <code>addEnvironment(key: str, value: str): void</code> | *No description* |

<h3 id="@winglibs/react.AppSim">AppSim (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(props: AppProps): AppSim
</pre>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>url</code> | <code>str</code> | *No description* |

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>getUrl(): str</code> | *No description* |
| <code>addEnvironment(key: str, value: str): void</code> | *No description* |

<h3 id="@winglibs/react.App">App (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(props: AppProps): App
</pre>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>url</code> | <code>str</code> | *No description* |

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>addEnvironment(key: str, value: str): void</code> | *No description* |

<h3 id="@winglibs/react.AppBase">AppBase (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(props: AppProps): AppBase
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>addEnvironment(key: str, value: str): void</code> | *No description* |

<h3 id="@winglibs/react.IApp">IApp (interface)</h3>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>addEnvironment(key: str, value: str): void</code> | *No description* |
| <code>getUrl(): str</code> | *No description* |

<h3 id="@winglibs/react.AppProps">AppProps (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>buildCommand</code> | <code>str?</code> | *No description* |
| <code>buildDir</code> | <code>str?</code> | *No description* |
| <code>domain</code> | <code>Domain?</code> | *No description* |
| <code>localPort</code> | <code>num?</code> | *No description* |
| <code>projectPath</code> | <code>str</code> | *No description* |
| <code>startCommand</code> | <code>str?</code> | *No description* |
| <code>useBuildCommand</code> | <code>bool?</code> | *No description* |

