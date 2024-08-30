<h2>API Reference</h2>

<h3>Table of Contents</h3>

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

<h3 id="@winglibs/checks.Results">Results (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(): Results
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight latest(checkid: str): CheckResult?</code> | *No description* |
| <code>static of(scope: IResource): Results</code> | *No description* |
| <code>inflight store(result: CheckResult): void</code> | *No description* |

<h3 id="@winglibs/checks.Check">Check (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(handler: inflight (): void, props: CheckProps?): Check
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight latest(): CheckResult?</code> | *No description* |
| <code>inflight run(): CheckResult</code> | *No description* |

<h3 id="@winglibs/checks.CheckHttp">CheckHttp (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(url: str, options: CheckHttpProps?): CheckHttp
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight latest(): CheckResult?</code> | *No description* |
| <code>inflight run(): CheckResult</code> | *No description* |

<h3 id="@winglibs/checks.ICheck">ICheck (interface)</h3>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight latest(): CheckResult?</code> | *No description* |
| <code>inflight run(): CheckResult</code> | *No description* |

<h3 id="@winglibs/checks.CheckResult">CheckResult (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>checkid</code> | <code>str</code> | *No description* |
| <code>checkpath</code> | <code>str</code> | *No description* |
| <code>error</code> | <code>str?</code> | *No description* |
| <code>ok</code> | <code>bool</code> | *No description* |
| <code>timestamp</code> | <code>str</code> | *No description* |

<h3 id="@winglibs/checks.CheckProps">CheckProps (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>deploy</code> | <code>bool?</code> | *No description* |
| <code>rate</code> | <code>duration?</code> | *No description* |
| <code>testing</code> | <code>bool?</code> | *No description* |

<h3 id="@winglibs/checks.CheckHttpProps">CheckHttpProps (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>body</code> | <code>str?</code> | *No description* |
| <code>deploy</code> | <code>bool?</code> | *No description* |
| <code>method</code> | <code>HttpMethod?</code> | *No description* |
| <code>path</code> | <code>str?</code> | *No description* |
| <code>rate</code> | <code>duration?</code> | *No description* |
| <code>status</code> | <code>num?</code> | *No description* |
| <code>testing</code> | <code>bool?</code> | *No description* |

