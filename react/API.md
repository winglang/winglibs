## API Reference

### Table of Contents

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

### Utils (preflight class) <a class="wing-docs-anchor" id="@winglibs/react.Utils"></a>

*No description*

#### Constructor

```
new(): Utils
```

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>static inflight exec(command: str, env: MutMap<str>, cwd: str): inflight (): void</code> | *No description* |
| <code>static execSync(command: str, env: MutMap<str>, cwd: str): void</code> | *No description* |
| <code>static inflight serveStaticFiles(path: str, port: num): inflight (): void</code> | *No description* |

### AppTfAws (preflight class) <a class="wing-docs-anchor" id="@winglibs/react.AppTfAws"></a>

*No description*

#### Constructor

```
new(props: AppProps): AppTfAws
```

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>_preSynthesize(): void</code> | *No description* |
| <code>getUrl(): str</code> | *No description* |
| <code>addEnvironment(key: str, value: str): void</code> | *No description* |

### AppSim (preflight class) <a class="wing-docs-anchor" id="@winglibs/react.AppSim"></a>

*No description*

#### Constructor

```
new(props: AppProps): AppSim
```

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>url</code> | <code>str</code> | *No description* |

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>getUrl(): str</code> | *No description* |
| <code>addEnvironment(key: str, value: str): void</code> | *No description* |

### App (preflight class) <a class="wing-docs-anchor" id="@winglibs/react.App"></a>

*No description*

#### Constructor

```
new(props: AppProps): App
```

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>url</code> | <code>str</code> | *No description* |

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>addEnvironment(key: str, value: str): void</code> | *No description* |

### AppBase (preflight class) <a class="wing-docs-anchor" id="@winglibs/react.AppBase"></a>

*No description*

#### Constructor

```
new(props: AppProps): AppBase
```

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>addEnvironment(key: str, value: str): void</code> | *No description* |

### IApp (interface) <a class="wing-docs-anchor" id="@winglibs/react.IApp"></a>

*No description*

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>addEnvironment(key: str, value: str): void</code> | *No description* |
| <code>getUrl(): str</code> | *No description* |

### AppProps (struct) <a class="wing-docs-anchor" id="@winglibs/react.AppProps"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>buildCommand</code> | <code>str?</code> | *No description* |
| <code>buildDir</code> | <code>str?</code> | *No description* |
| <code>domain</code> | <code>Domain?</code> | *No description* |
| <code>localPort</code> | <code>num?</code> | *No description* |
| <code>projectPath</code> | <code>str</code> | *No description* |
| <code>startCommand</code> | <code>str?</code> | *No description* |
| <code>useBuildCommand</code> | <code>bool?</code> | *No description* |

