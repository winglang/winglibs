bring cloud;
bring util;
bring "constructs" as construct;
bring "./types.w" as types;
bring "./sim/inflight.w" as sim;
bring "./tfaws/inflight.w" as aws;

pub class InflightFunction impl cloud.IFunctionHandler {
  _inflightType: str;
  inner: types.IInflight;

  new(props: types.InflightProps) {
    this._inflightType = "_inflightPython";

    let target = util.env("WING_TARGET");
    if target == "sim" {
      this.inner = new sim.Inflight(props);
    } elif target == "tf-aws" {
      this.inner = new aws.Inflight_tfaws(props);
    } else {
      throw "Unsupported target ${target}";
    }
  }

  pub inflight handle(event: str?): str? {
    return this.inner.handle(event);
  }

  pub lift(obj: std.Resource, options: types.LiftOptions): cloud.IFunctionHandler {
    this.inner.lift(obj, options);
    return this;
  }
}
