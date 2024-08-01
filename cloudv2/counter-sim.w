bring fs;
bring sim;

bring "./counter-types.w" as counter_types;

inflight class CounterBackend impl sim.IResource {
  valuesFile: str;
  initial: num;
  statedir: str;
  values: MutMap<num>;
  new(ctx: sim.IResourceContext, initial: num) {
    this.initial = initial;

    this.statedir = ctx.statedir();
    this.valuesFile = fs.join(this.statedir, "values.json");
    if fs.exists(this.valuesFile) {
      let data = fs.readJson(this.valuesFile);
      // TODO: MutMap<num>.fromJson(...) - https://github.com/winglang/wing/issues/1796
      this.values = unsafeCast(data["values"]);
    } else {
      this.values = {};
    }
  }

  pub onStop() {
    fs.writeJson(this.valuesFile, { "values": this.values.copy() });
  }

  pub inc(amount: num, key: str): num {
    let prev = this.values.tryGet(key) ?? this.initial;
    this.values[key] = prev + amount;
    return prev;
  }

  pub dec(amount: num, key: str): num {
    let prev = this.values.tryGet(key) ?? this.initial;
    this.values[key] = prev - amount;
    return prev;
  }

  pub peek(key: str): num {
    return this.values.tryGet(key) ?? this.initial;
  }

  pub set(value: num, key: str) {
    this.values[key] = value;
  }
}

// TODO: internal access modifiers - https://github.com/winglang/wing/issues/4156

pub class Counter_sim impl counter_types.ICounter {
  initial: num;
  backend: sim.Resource;
  defaultKey: str; // TODO: module-level constants - https://github.com/winglang/wing/issues/3606
  new(props: counter_types.CounterProps) {
    this.initial = props.initial ?? 0;
    this.backend = new sim.Resource(inflight (ctx) => {
      return new CounterBackend(ctx, this.initial);
    }) as "Backend";
    nodeof(this.backend).icon = "calculator";
    nodeof(this.backend).color = "lime";
    this.defaultKey = "default";
  }

  pub inflight inc(amount: num?, key: str?): num {
    let response = this.backend.call("inc", Json [amount ?? 1, key ?? this.defaultKey]);
    return num.fromJson(response);
  }

  pub inflight dec(amount: num?, key: str?): num {
    let response = this.backend.call("dec", Json [amount ?? 1, key ?? this.defaultKey]);
    return num.fromJson(response);
  }

  pub inflight peek(key: str?): num {
    let response = this.backend.call("peek", Json [key ?? this.defaultKey]);
    return num.fromJson(response);
  }

  pub inflight set(value: num, key: str?): void {
    this.backend.call("set", Json [value, key ?? this.defaultKey]);
  }

  // TODO: rename this to std.IHost
  pub onLift(host: std.IInflightHost, ops: Array<str>) {
    // TODO: check that host is sim.ISimHost
    // if sim.Host.from(host) == nil {
    //   throw "Counter_sim can only be lifted by an ISimHost";
    // }
  }
}
