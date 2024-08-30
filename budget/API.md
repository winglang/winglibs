<h2>API Reference</h2>

<h3>Table of Contents</h3>

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

<h3 id="@winglibs/budget.Alert">Alert (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(props: AlertProps): Alert
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

*No methods*

<h3 id="@winglibs/budget.AlertTfAws">AlertTfAws (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(props: AlertProps): AlertTfAws
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

*No methods*

<h3 id="@winglibs/budget.AlertSim">AlertSim (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(props: AlertProps): AlertSim
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

*No methods*

<h3 id="@winglibs/budget.Util">Util (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(): Util
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>static timeUnitToStr(timeUnit: TimeUnit): str</code> | *No description* |

<h3 id="@winglibs/budget.IAlert">IAlert (interface)</h3>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

*No methods*

<h3 id="@winglibs/budget.AlertProps">AlertProps (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>amount</code> | <code>num</code> | *No description* |
| <code>emailAddresses</code> | <code>Array<str></code> | *No description* |
| <code>name</code> | <code>str</code> | *No description* |
| <code>timeUnit</code> | <code>TimeUnit?</code> | *No description* |

<h3 id="@winglibs/budget.TimeUnit">TimeUnit (enum)</h3>

<h4>Values</h4>

| **Name** | **Description** |
| --- | --- |
| <code>DAILY</code> | *No description* |
| <code>MONTHLY</code> | *No description* |
| <code>ANNUALLY</code> | *No description* |

