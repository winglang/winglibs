bring cloud;
bring util;
bring ui;
bring "./sim/function.w" as sim;
bring "./tfaws/function.w" as tfaws;
bring "./types.w" as types;

pub class Function impl types.IFunction {
  pub url: str;
  inner: types.IFunction;
  new(props: types.FunctionProps) {
    let target = util.env("WING_TARGET");
    if target == "sim" {
      let implementation = new sim.Function(props);
      this.inner = implementation;
      this.url = implementation.url;
    } elif target == "tf-aws" {
      let implementation = new tfaws.Function(props);
      this.inner = implementation;
      this.url = implementation.url;
    } else {
      throw "Unsupported target ${target}";
    }

    new cloud.Endpoint(this.url);
    new ui.Field("URL", inflight () => {
      return this.url;
    });
    new ui.Button("Invoke", inflight () => {
      log("{this.invoke() ?? "<empty response>"}");
    });

    nodeof(this).color = "violet";
  }

  pub liftClient(id: str, client: std.Resource, ops: Array<str>): void {
    this.inner.liftClient(id, client, ops);
  }

  pub inflight invoke(payload: str?): str? {
    return this.inner.invoke(payload);
  }
}

