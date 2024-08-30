<h2>API Reference</h2>

<h3>Table of Contents</h3>

- **Classes**
  - <a href="#@winglibs/momento.Cache">Cache</a>
- **Interfaces**
  - <a href="#@winglibs/momento.ICache">ICache</a>
- **Structs**
  - <a href="#@winglibs/momento.CacheGetOptions">CacheGetOptions</a>
  - <a href="#@winglibs/momento.CacheProps">CacheProps</a>
  - <a href="#@winglibs/momento.CacheSetOptions">CacheSetOptions</a>

<h3 id="@winglibs/momento.Cache">Cache (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(props: CacheProps): Cache
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight get(key: str): str?</code> | *No description* |
| <code>inflight set(key: str, value: str, opts: CacheSetOptions?): void</code> | *No description* |

<h3 id="@winglibs/momento.ICache">ICache (interface)</h3>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight get(key: str, opts: CacheGetOptions?): str?</code> | Get a value from the cache. |
| <code>inflight set(key: str, value: str, opts: CacheSetOptions?): void</code> | Set a value in the cache. |

<h3 id="@winglibs/momento.CacheGetOptions">CacheGetOptions (struct)</h3>

<h4>Properties</h4>

*No properties*

<h3 id="@winglibs/momento.CacheProps">CacheProps (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>defaultTtl</code> | <code>duration?</code> | The default time-to-live for cache entries. @default 60 |
| <code>name</code> | <code>str?</code> | The name of the cache. @default - a unique id will be generated |
| <code>token</code> | <code>Secret</code> | A secret containing the Momento API key to use for accessing the cache at runtime. |

<h3 id="@winglibs/momento.CacheSetOptions">CacheSetOptions (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>ttl</code> | <code>duration?</code> | The time-to-live for the cache entry, in seconds. @default 60s |

