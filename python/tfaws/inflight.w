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
    if let lifts = props.lift {
      for lift in lifts.entries() {
        this.lift(lift.value.obj, { id: lift.key, allow: lift.value.allow });
      }
    }
  }

  pub inflight handle(event: str?): str? {

  }

  pub lift(obj: std.Resource, options: types.LiftOptions): cloud.IFunctionHandler {
    this.lifts.set(options.id, { client: obj, options: options });
    return this;
  }
}
