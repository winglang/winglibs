<h2>API Reference</h2>

<h3>Table of Contents</h3>

- **Classes**
  - <a href="#@winglibs/lock.Lock">Lock</a>
- **Structs**
  - <a href="#@winglibs/lock.LockAcquireOptions">LockAcquireOptions</a>

<h3 id="@winglibs/lock.Lock">Lock (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(): Lock
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight acquire(id: str, options: LockAcquireOptions): void</code> | *No description* |
| <code>inflight release(id: str): void</code> | *No description* |
| <code>inflight tryAcquire(id: str, options: LockAcquireOptions): bool</code> | *No description* |
| <code>inflight tryRelease(id: str): bool</code> | *No description* |

<h3 id="@winglibs/lock.LockAcquireOptions">LockAcquireOptions (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>expiry</code> | <code>duration?</code> | *No description* |
| <code>timeout</code> | <code>duration</code> | *No description* |

