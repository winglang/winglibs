## API Reference

### Table of Contents

- **Classes**
  - <a href="#@winglibs/lock.Lock">Lock</a>
- **Structs**
  - <a href="#@winglibs/lock.LockAcquireOptions">LockAcquireOptions</a>

### Lock (preflight class) <a class="wing-docs-anchor" id="@winglibs/lock.Lock"></a>

*No description*

#### Constructor

```
new(): Lock
```

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight acquire(id: str, options: LockAcquireOptions): void</code> | *No description* |
| <code>inflight release(id: str): void</code> | *No description* |
| <code>inflight tryAcquire(id: str, options: LockAcquireOptions): bool</code> | *No description* |
| <code>inflight tryRelease(id: str): bool</code> | *No description* |

### LockAcquireOptions (struct) <a class="wing-docs-anchor" id="@winglibs/lock.LockAcquireOptions"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>expiry</code> | <code>duration?</code> | *No description* |
| <code>timeout</code> | <code>duration</code> | *No description* |

