bring cloud;
bring util;
bring "../types.w" as types;

struct Lifted {
  client: std.Resource;
  options: types.LiftOptions;
}

pub class Inflight_tfaws impl types.IInflight {
  props: types.InflightProps;
  lifts: MutMap<Lifted>;

  new(props: types.InflightProps) {
    this.props = props;
    this.lifts = MutMap<Lifted>{};
  }

  pub inflight handle(event: str?): str? {

  }

  pub lift(id: str, client: std.Resource, options: types.LiftOptions): cloud.IFunctionHandler {
    this.lifts.set(id, { client: client, options: options });
    return this;
  }
}
