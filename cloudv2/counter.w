bring aws;
bring cloud;
bring fs;
bring ui;
bring util;
bring sim;

bring "./counter-aws.w" as counter_aws;
bring "./counter-sim.w" as counter_sim;
bring "./counter-types.w" as counter_types;

pub class Counter impl counter_types.ICounter {
  inner: counter_types.ICounter;
  pub initial: num;
  new(props: counter_types.CounterProps) {
    nodeof(this).title = "Counter";
    nodeof(this).description = "A distributed atomic counter";
    nodeof(this).icon = "calculator";
    nodeof(this).color = "lime";

    let target = util.env("WING_TARGET");
    let id = nodeof(this).id;
    this.initial = props.initial ?? 0;
    if target == "sim" {
      this.inner = new counter_sim.Counter_sim(props) as id;
    } else if target == "tf-aws" {
      this.inner = new counter_aws.Counter_tfaws(props) as id;
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
