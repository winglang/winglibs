<h2>API Reference</h2>

<h3>Table of Contents</h3>

- **Classes**
  - <a href="#@winglibs/redis.Util">Util</a>
  - <a href="#@winglibs/redis.Redis">Redis</a>
  - <a href="#@winglibs/redis.Redis_sim">Redis_sim</a>
- **Interfaces**
  - <a href="#@winglibs/redis.IRedis">IRedis</a>
  - <a href="#@winglibs/redis.IRedisClient">IRedisClient</a>

<h3 id="@winglibs/redis.Util">Util (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(): Util
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>static inflight newRedisClient(url: str, redisPassword: str): IRedisClient</code> | *No description* |

<h3 id="@winglibs/redis.Redis">Redis (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(): Redis
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight del(key: str): void?</code> | *No description* |
| <code>inflight get(key: str): str?</code> | *No description* |
| <code>inflight hGet(key: str, field: str): str?</code> | *No description* |
| <code>inflight hSet(key: str, field: str, value: str): void?</code> | *No description* |
| <code>inflight sAdd(key: str, value: str): void?</code> | *No description* |
| <code>inflight sMembers(key: str): Array<str>?</code> | *No description* |
| <code>inflight set(key: str, value: str): void?</code> | *No description* |
| <code>inflight url(): str</code> | *No description* |

<h3 id="@winglibs/redis.Redis_sim">Redis_sim (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(): Redis_sim
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight del(key: str): void</code> | *No description* |
| <code>inflight get(key: str): str?</code> | *No description* |
| <code>inflight hGet(key: str, field: str): str?</code> | *No description* |
| <code>inflight hSet(key: str, field: str, value: str): void</code> | *No description* |
| <code>inflight sAdd(key: str, value: str): void</code> | *No description* |
| <code>inflight sMembers(key: str): Array<str>?</code> | *No description* |
| <code>inflight set(key: str, value: str): void</code> | *No description* |
| <code>inflight url(): str</code> | *No description* |

<h3 id="@winglibs/redis.IRedis">IRedis (interface)</h3>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight del(key: str): void</code> | *No description* |
| <code>inflight get(key: str): str?</code> | *No description* |
| <code>inflight hGet(key: str, field: str): str?</code> | *No description* |
| <code>inflight hSet(key: str, field: str, value: str): void</code> | *No description* |
| <code>inflight sAdd(key: str, value: str): void</code> | *No description* |
| <code>inflight sMembers(key: str): Array<str>?</code> | *No description* |
| <code>inflight set(key: str, value: str): void</code> | *No description* |
| <code>inflight url(): str</code> | *No description* |

<h3 id="@winglibs/redis.IRedisClient">IRedisClient (interface)</h3>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight connect(): void</code> | *No description* |
| <code>inflight del(key: str): void</code> | *No description* |
| <code>inflight disconnect(): void</code> | *No description* |
| <code>inflight get(key: str): str?</code> | *No description* |
| <code>inflight hGet(key: str, field: str): str?</code> | *No description* |
| <code>inflight hSet(key: str, field: str, value: str): void</code> | *No description* |
| <code>inflight sAdd(key: str, value: str): void</code> | *No description* |
| <code>inflight sMembers(key: str): Array<str>?</code> | *No description* |
| <code>inflight set(key: str, value: str): void</code> | *No description* |
| <code>inflight url(): str</code> | *No description* |

