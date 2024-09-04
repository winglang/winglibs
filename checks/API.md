## API Reference

### Table of Contents

- **Classes**
  - <a href="#@winglibs/checks.Results">Results</a>
  - <a href="#@winglibs/checks.Check">Check</a>
  - <a href="#@winglibs/checks.CheckHttp">CheckHttp</a>
- **Interfaces**
  - <a href="#@winglibs/checks.ICheck">ICheck</a>
- **Structs**
  - <a href="#@winglibs/checks.CheckResult">CheckResult</a>
  - <a href="#@winglibs/checks.CheckProps">CheckProps</a>
  - <a href="#@winglibs/checks.CheckHttpProps">CheckHttpProps</a>

### Results (preflight class) <a class="wing-docs-anchor" id="@winglibs/checks.Results"></a>

*No description*

#### Constructor

```
new(): Results
```

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight latest(checkid: str): CheckResult?</code> | *No description* |
| <code>static of(scope: IResource): Results</code> | *No description* |
| <code>inflight store(result: CheckResult): void</code> | *No description* |

### Check (preflight class) <a class="wing-docs-anchor" id="@winglibs/checks.Check"></a>

*No description*

#### Constructor

```
new(handler: inflight (): void, props: CheckProps?): Check
```

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight latest(): CheckResult?</code> | *No description* |
| <code>inflight run(): CheckResult</code> | *No description* |

### CheckHttp (preflight class) <a class="wing-docs-anchor" id="@winglibs/checks.CheckHttp"></a>

*No description*

#### Constructor

```
new(url: str, options: CheckHttpProps?): CheckHttp
```

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight latest(): CheckResult?</code> | *No description* |
| <code>inflight run(): CheckResult</code> | *No description* |

### ICheck (interface) <a class="wing-docs-anchor" id="@winglibs/checks.ICheck"></a>

*No description*

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight latest(): CheckResult?</code> | *No description* |
| <code>inflight run(): CheckResult</code> | *No description* |

### CheckResult (struct) <a class="wing-docs-anchor" id="@winglibs/checks.CheckResult"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>checkid</code> | <code>str</code> | *No description* |
| <code>checkpath</code> | <code>str</code> | *No description* |
| <code>error</code> | <code>str?</code> | *No description* |
| <code>ok</code> | <code>bool</code> | *No description* |
| <code>timestamp</code> | <code>str</code> | *No description* |

### CheckProps (struct) <a class="wing-docs-anchor" id="@winglibs/checks.CheckProps"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>deploy</code> | <code>bool?</code> | *No description* |
| <code>rate</code> | <code>duration?</code> | *No description* |
| <code>testing</code> | <code>bool?</code> | *No description* |

### CheckHttpProps (struct) <a class="wing-docs-anchor" id="@winglibs/checks.CheckHttpProps"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>body</code> | <code>str?</code> | *No description* |
| <code>deploy</code> | <code>bool?</code> | *No description* |
| <code>method</code> | <code>HttpMethod?</code> | *No description* |
| <code>path</code> | <code>str?</code> | *No description* |
| <code>rate</code> | <code>duration?</code> | *No description* |
| <code>status</code> | <code>num?</code> | *No description* |
| <code>testing</code> | <code>bool?</code> | *No description* |

