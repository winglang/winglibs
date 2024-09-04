## API Reference

### Table of Contents

- **Classes**
  - <a href="#@winglibs/redis.Util">Util</a>
  - <a href="#@winglibs/redis.Redis">Redis</a>
  - <a href="#@winglibs/redis.Redis_sim">Redis_sim</a>
- **Interfaces**
  - <a href="#@winglibs/redis.IRedis">IRedis</a>
  - <a href="#@winglibs/redis.IRedisClient">IRedisClient</a>

### Util (preflight class) <a class="wing-docs-anchor" id="@winglibs/redis.Util"></a>

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
| <code>static inflight newRedisClient(url: str, redisPassword: str): IRedisClient</code> | *No description* |

### Redis (preflight class) <a class="wing-docs-anchor" id="@winglibs/redis.Redis"></a>

*No description*

#### Constructor

```
new(): Redis
```

#### Properties

*No properties*

#### Methods

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

### Redis_sim (preflight class) <a class="wing-docs-anchor" id="@winglibs/redis.Redis_sim"></a>

*No description*

#### Constructor

```
new(): Redis_sim
```

#### Properties

*No properties*

#### Methods

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

### IRedis (interface) <a class="wing-docs-anchor" id="@winglibs/redis.IRedis"></a>

*No description*

#### Properties

*No properties*

#### Methods

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

### IRedisClient (interface) <a class="wing-docs-anchor" id="@winglibs/redis.IRedisClient"></a>

*No description*

#### Properties

*No properties*

#### Methods

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

