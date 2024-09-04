## API Reference

### Table of Contents

- **Classes**
  - <a href="#@winglibs/postgres.Database">Database</a>
  - <a href="#@winglibs/postgres.DatabaseRef">DatabaseRef</a>
- **Interfaces**
  - <a href="#@winglibs/postgres.IDatabase">IDatabase</a>
- **Structs**
  - <a href="#@winglibs/postgres.AwsParameters">AwsParameters</a>
  - <a href="#@winglibs/postgres.ConnectionOptions">ConnectionOptions</a>
  - <a href="#@winglibs/postgres.DatabaseProps">DatabaseProps</a>

### Database (preflight class) <a class="wing-docs-anchor" id="@winglibs/postgres.Database"></a>

*No description*

#### Constructor

```
new(props: DatabaseProps): Database
```

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>connection</code> | <code>ConnectionOptions</code> | *No description* |

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight connectionOptions(): ConnectionOptions</code> | *No description* |
| <code>inflight query(query: str): Array<Map<Json>></code> | *No description* |

### DatabaseRef (preflight class) <a class="wing-docs-anchor" id="@winglibs/postgres.DatabaseRef"></a>

*No description*

#### Constructor

```
new(): DatabaseRef
```

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight query(query: str): Array<Map<Json>></code> | *No description* |

### IDatabase (interface) <a class="wing-docs-anchor" id="@winglibs/postgres.IDatabase"></a>

*No description*

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight connectionOptions(): ConnectionOptions?</code> | *No description* |
| <code>inflight query(query: str): Array<Map<Json>></code> | *No description* |

### AwsParameters (struct) <a class="wing-docs-anchor" id="@winglibs/postgres.AwsParameters"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>postgresEngine</code> | <code>str?</code> | *No description* |

### ConnectionOptions (struct) <a class="wing-docs-anchor" id="@winglibs/postgres.ConnectionOptions"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>database</code> | <code>str</code> | *No description* |
| <code>host</code> | <code>str</code> | *No description* |
| <code>password</code> | <code>str</code> | *No description* |
| <code>port</code> | <code>str</code> | *No description* |
| <code>ssl</code> | <code>bool</code> | *No description* |
| <code>user</code> | <code>str</code> | *No description* |

### DatabaseProps (struct) <a class="wing-docs-anchor" id="@winglibs/postgres.DatabaseProps"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>name</code> | <code>str</code> | *No description* |
| <code>pgVersion</code> | <code>num?</code> | *No description* |

