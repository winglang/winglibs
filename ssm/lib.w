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

pub class ParameterRef impl types.IParameter {
  inner: types.IParameter;
  new(props: types.ParameterRefProps) {
    let target = util.env("WING_TARGET");
    if target == "sim" || target == "tf-aws" {
      this.inner = new tfaws.ParameterRef(props);
    } else {
      throw "Unsupported platform {target}";
    }

    nodeof(this.inner).hidden = true;
    this.setUi(props.arn);
  }

  setUi(arn: str) {
    new ui.Field("Arn", inflight () => {
      return arn;
    }) as "name";

    new ui.Field("Value", inflight () => {
      try {
        return this.value();
      } catch err {
        return "Unable to fetch value: {err}";
      }
    }) as "value";
    
    // https://us-east-1.console.aws.amazon.com/systems-manager/parameters/param-name
    new ui.Field("AwsConsoleLink", inflight () => {
      let region = arn.split(":").at(3);
      let name = arn.split(":").at(5).replace("parameter", "");
      return "https://{region}.console.aws.amazon.com/systems-manager/parameters{name}";
    }, link: true) as "link";
  }

  pub inflight value(): str {
    return this.inner.value();
  }
}
