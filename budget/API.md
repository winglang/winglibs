## API Reference

### Table of Contents

- **Classes**
  - <a href="#@winglibs/budget.Alert">Alert</a>
  - <a href="#@winglibs/budget.AlertTfAws">AlertTfAws</a>
  - <a href="#@winglibs/budget.AlertSim">AlertSim</a>
  - <a href="#@winglibs/budget.Util">Util</a>
- **Interfaces**
  - <a href="#@winglibs/budget.IAlert">IAlert</a>
- **Structs**
  - <a href="#@winglibs/budget.AlertProps">AlertProps</a>
- **Enums**
  - <a href="#@winglibs/budget.TimeUnit">TimeUnit</a>

### Alert (preflight class) <a class="wing-docs-anchor" id="@winglibs/budget.Alert"></a>

*No description*

#### Constructor

```
new(props: AlertProps): Alert
```

#### Properties

*No properties*

#### Methods

*No methods*

### AlertTfAws (preflight class) <a class="wing-docs-anchor" id="@winglibs/budget.AlertTfAws"></a>

*No description*

#### Constructor

```
new(props: AlertProps): AlertTfAws
```

#### Properties

*No properties*

#### Methods

*No methods*

### AlertSim (preflight class) <a class="wing-docs-anchor" id="@winglibs/budget.AlertSim"></a>

*No description*

#### Constructor

```
new(props: AlertProps): AlertSim
```

#### Properties

*No properties*

#### Methods

*No methods*

### Util (preflight class) <a class="wing-docs-anchor" id="@winglibs/budget.Util"></a>

*No description*

#### Constructor

```
new(): Util
```

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>static timeUnitToStr(timeUnit: TimeUnit): str</code> | *No description* |

### IAlert (interface) <a class="wing-docs-anchor" id="@winglibs/budget.IAlert"></a>

*No description*

#### Properties

*No properties*

#### Methods

*No methods*

### AlertProps (struct) <a class="wing-docs-anchor" id="@winglibs/budget.AlertProps"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>amount</code> | <code>num</code> | *No description* |
| <code>emailAddresses</code> | <code>Array<str></code> | *No description* |
| <code>name</code> | <code>str</code> | *No description* |
| <code>timeUnit</code> | <code>TimeUnit?</code> | *No description* |

### TimeUnit (enum) <a class="wing-docs-anchor" id="@winglibs/budget.TimeUnit"></a>

*No description*

#### Values

| **Name** | **Description** |
| --- | --- |
| <code>DAILY</code> | *No description* |
| <code>MONTHLY</code> | *No description* |
| <code>ANNUALLY</code> | *No description* |

