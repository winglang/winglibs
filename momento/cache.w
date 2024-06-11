bring util;
bring tf;

pub struct CacheProps {
  /// The name of the cache.
  /// @default - a unique id will be generated
  name: str?;
  /// The default time-to-live for cache entries.
  /// @default 60
  defaultTtl: duration?;
}

pub interface ICache {
  /// Get a value from the cache.
  inflight get(key: str, opts: CacheGetOptions?): str?;

  /// Set a value in the cache.
  inflight set(key: str, value: str, opts: CacheSetOptions?): void;
}

pub struct CacheGetOptions {}

pub struct CacheSetOptions {
  /// The time-to-live for the cache entry, in seconds.
  /// @default 60s
  ttl: duration?;
}

pub class Cache {
  inner: ICache;
  new(props: CacheProps) {
    let target = util.env("WING_TARGET");
    let node = nodeof(this);
    let name = props.name ?? node.id.substring(0, 8) + "_" + node.addr.substring(34);
    if target.startsWith("tf") {
      this.inner = new Cache_tf({ name: name, defaultTtl: props.defaultTtl });
    }
  }

  pub inflight get(key: str): str? {
    return this.inner.get(key);
  }

  pub inflight set(key: str, value: str, opts: CacheSetOptions?): void {
    this.inner.set(key, value, opts);
  }
}

class Cache_tf impl ICache {
  name: str;
  new(props: CacheProps) {
    this.name = props.name!;
    new tf.Resource(type: "momento_cache", attributes: {
      name: this.name,
    });
    MomentoProvider.getOrCreate(this);
  }

  extern "./cache.ts" static inflight _get(cacheName: str, key: str): str?;
  extern "./cache.ts" static inflight _set(cacheName: str, key: str, value: str, ttl: num): void;

  pub inflight get(key: str): str? {
    return Cache_tf._get(this.name, key);
  }

  pub inflight set(key: str, value: str, opts: CacheSetOptions?): void {
    let ttl = opts?.ttl ?? 60s;
    Cache_tf._set(this.name, key, value, ttl.seconds);
  }

  pub onLift(host: std.IInflightHost, ops: Array<str>) {
    host.addEnvironment("MOMENTO_AUTH_TOKEN", util.env("MOMENTO_AUTH_TOKEN"));
  }
}

class MomentoProvider {
  pub static getOrCreate(scope: std.IResource): tf.Provider {
    let root = nodeof(scope).root;
    let singletonKey = "WingMomentoProvider";
    let existing = root.node.tryFindChild(singletonKey);
    if existing? {
      return unsafeCast(existing);
    }

    return new tf.Provider(
      name: "momento",
      source: "Chriscbr/momento",
      version: "0.1.2",
    ) as singletonKey in root;
  }
}
