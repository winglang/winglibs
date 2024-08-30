<h2>API Reference</h2>

<h3>Table of Contents</h3>

- **Classes**
  - <a href="#@winglibs/postgres.Database">Database</a>
  - <a href="#@winglibs/postgres.DatabaseRef">DatabaseRef</a>
- **Interfaces**
  - <a href="#@winglibs/postgres.IDatabase">IDatabase</a>
- **Structs**
  - <a href="#@winglibs/postgres.AwsParameters">AwsParameters</a>
  - <a href="#@winglibs/postgres.ConnectionOptions">ConnectionOptions</a>
  - <a href="#@winglibs/postgres.DatabaseProps">DatabaseProps</a>

<h3 id="@winglibs/postgres.Database">Database (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(props: DatabaseProps): Database
</pre>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>connection</code> | <code>ConnectionOptions</code> | *No description* |

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight connectionOptions(): ConnectionOptions</code> | *No description* |
| <code>inflight query(query: str): Array<Map<Json>></code> | *No description* |

<h3 id="@winglibs/postgres.DatabaseRef">DatabaseRef (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(): DatabaseRef
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight query(query: str): Array<Map<Json>></code> | *No description* |

<h3 id="@winglibs/postgres.IDatabase">IDatabase (interface)</h3>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight connectionOptions(): ConnectionOptions?</code> | *No description* |
| <code>inflight query(query: str): Array<Map<Json>></code> | *No description* |

<h3 id="@winglibs/postgres.AwsParameters">AwsParameters (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>postgresEngine</code> | <code>str?</code> | *No description* |

<h3 id="@winglibs/postgres.ConnectionOptions">ConnectionOptions (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>database</code> | <code>str</code> | *No description* |
| <code>host</code> | <code>str</code> | *No description* |
| <code>password</code> | <code>str</code> | *No description* |
| <code>port</code> | <code>str</code> | *No description* |
| <code>ssl</code> | <code>bool</code> | *No description* |
| <code>user</code> | <code>str</code> | *No description* |

<h3 id="@winglibs/postgres.DatabaseProps">DatabaseProps (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>name</code> | <code>str</code> | *No description* |
| <code>pgVersion</code> | <code>num?</code> | *No description* |

