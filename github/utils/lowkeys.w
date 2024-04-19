pub inflight class LowkeysMap {
  pub static inflight fromMap(map: Map<str>): Map<str> {
    let res = MutMap<str>{};

    for key in map.keys() {
      res.set(key.lowercase(), map[key]);
    }

    return res.copy();
  }
}
