bring aws;
bring cloud;
bring fs;
bring ui;
bring util;
bring sim;

bring "@cdktf/provider-aws" as tfaws;
bring "./util.w" as myutil;

// TODO: Default values for struct fields - https://github.com/winglang/wing/issues/3121

pub struct CounterProps {
  /// The initial value of the counter
  /// @default 0
  initial: num?;
}

interface ICounter {
  /// Increments the counter atomically by a certain amount and returns the previous value.
  /// - `amount` The amount to increment by (defaults to 1)
  /// - `key` The key of the counter (defaults to "default")
  inflight inc(amount: num?, key: str?): num;

  /// Decrements the counter atomically by a certain amount and returns the previous value.
  /// - `amount` The amount to decrement by (defaults to 1)
  /// - `key` The key of the counter (defaults to "default")
  inflight dec(amount: num?, key: str?): num;

  /// Returns the current value of the counter.
  /// - `key` The key of the counter (defaults to "default")
  inflight peek(key: str?): num;
  
  /// Sets the value of the counter.
  /// - `value` The new value of the counter
  /// - `key` The key of the counter (defaults to "default")
  inflight set(value: num, key: str?): void;
}

pub class Counter impl ICounter {
  inner: ICounter;
  new(props: CounterProps) {
    nodeof(this).title = "Counter";
    nodeof(this).description = "A distributed atomic counter";
    nodeof(this).icon = "calculator";
    nodeof(this).color = "lime";

    let target = util.env("WING_TARGET");
    let id = nodeof(this).id;
    if target == "sim" {
      this.inner = new Counter_sim(props) as id;
    } elif target == "tf-aws" {
      this.inner = new Counter_tfaws(props) as id;
    } else {
      throw "Unsupported target: " + target;
    }
    nodeof(this.inner).hidden = true;

    this.addUI();
  }

  addUI() {
    new ui.Field("Actual value", inflight () => { return "{this.peek()}"; }) as "ValueField";
    new ui.Button("Increment", inflight () => { this.inc(); }) as "IncrementButton";
    new ui.Button("Decrement", inflight () => { this.dec(); }) as "DecrementButton";
    new ui.Button("Reset", inflight () => { this.set(0); }) as "ResetButton";
  }

  pub inflight inc(amount: num?, key: str?): num {
    return this.inner.inc(amount, key);
  }

  pub inflight dec(amount: num?, key: str?): num {
    return this.inner.dec(amount, key);
  }

  pub inflight peek(key: str?): num {
    return this.inner.peek(key);
  }

  pub inflight set(value: num, key: str?): void {
    this.inner.set(value, key);
  }
}

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

class Counter_sim impl ICounter {
  initial: num;
  backend: sim.Resource;
  defaultKey: str; // TODO: module-level constants - https://github.com/winglang/wing/issues/3606
  new(props: CounterProps) {
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

class Counter_tfaws impl ICounter {
  initial: num;
  table: tfaws.dynamodbTable.DynamodbTable;
  hashKey: str;
  defaultKey: str; // TODO: module-level constants - https://github.com/winglang/wing/issues/3606
  envKey: str;
  new(props: CounterProps) {
    this.initial = props.initial ?? 0;
    this.hashKey = "id";
    this.table = new tfaws.dynamodbTable.DynamodbTable(
      name: myutil.friendlyName(this),
      attribute: [{ name: this.hashKey, type: "S" }],
      hashKey: this.hashKey,
      billingMode: "PAY_PER_REQUEST",
    ) as "Default";
    this.defaultKey = "default";
    this.envKey = "COUNTER_" + myutil.shortHash(this);
  }

  extern "./counter-aws.ts" static inflight _inc(amount: num, key: str, tableName: str, hashKey: str, initial: num): num;
  extern "./counter-aws.ts" static inflight _dec(amount: num, key: str, tableName: str, hashKey: str, initial: num): num;
  extern "./counter-aws.ts" static inflight _peek(key: str, tableName: str, hashKey: str, initial: num): num;
  extern "./counter-aws.ts" static inflight _set(value: num, key: str, tableName: str, hashKey: str): void;

  pub inflight inc(amount: num?, key: str?): num {
    return Counter_tfaws._inc(amount ?? 1, key ?? this.defaultKey, this.table.name, this.hashKey, this.initial);
  }

  pub inflight dec(amount: num?, key: str?): num {
    return Counter_tfaws._dec(amount ?? 1, key ?? this.defaultKey, this.table.name, this.hashKey, this.initial);
  }

  pub inflight peek(key: str?): num {
    return Counter_tfaws._peek(key ?? this.defaultKey, this.table.name, this.hashKey, this.initial);
  }

  pub inflight set(value: num, key: str?): void {
    Counter_tfaws._set(value, key ?? this.defaultKey, this.table.name, this.hashKey);
  }

  pub onLift(host: std.IInflightHost, ops: Array<str>) {
    // TODO: implement aws.Host.from
    // if aws.Host.from(host) == nil {
    //   throw "Counter for \"tf-aws\" can only be lifted by a class implementing aws.IHost";
    // }

    // let awsHost: aws.IAwsInflightHost = aws.Host.from(host)!;
    let awsHost: aws.IAwsInflightHost = unsafeCast(host);
    let actions = MutArray<str>[];
    if ops.contains("inc") || ops.contains("dec") || ops.contains("set") {
      actions.push("dynamodb:UpdateItem");
    }
    if ops.contains("peek") {
      actions.push("dynamodb:GetItem");
    }
  
    awsHost.addPolicyStatements({
      actions: actions.copy(),
      effect: aws.Effect.ALLOW,
      resources: [this.table.arn],
    });
    awsHost.addEnvironment(this.envKey, this.table.name);
  }
}
