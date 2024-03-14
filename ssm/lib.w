bring util;
bring ui;
bring "./types.w" as types;
bring "./platform/sim.w" as sim;
bring "./platform/tfaws.w" as tfaws;

pub class Parameter impl types.IParameter {
  inner: types.IParameter;
  new(props: types.ParameterProps) {
    let target = util.env("WING_TARGET");
    if (target == "sim") {
      this.inner = new sim.Parameter(props);
    } elif (target == "tf-aws") {
      this.inner = new tfaws.Parameter(props);
    } else {
      throw "Unsupported platform {target}";
    }

    nodeof(this.inner).hidden = true;
    this.setUi(props.name);
  }

  setUi(name: str) {
    new ui.Field("Name", inflight () => {
      return name;
    }) as "name";
    new ui.Field("Value", inflight () => {
      return this.value();
    }) as "value";
  }

  pub inflight value(): str {
    return this.inner.value();
  }
}
