bring cloud;

pub struct BuildOptions {
  nodePath: str;
  path: str;
  handler: str;
  homeEnv: str;
  pathEnv: str;
}

/// Props to construct a new python inflight handler.
/// `path` should be an absolute path to source of the code.
pub struct InflightProps {
  path: str;
  handler: str;
  lift: Map<Lift>?;
}

pub struct Lift {
  obj: std.Resource;
  allow: Array<str>;
}

pub struct LiftOptions {
  id: str;
  allow: Array<str>;
}

pub interface IInflight extends cloud.IFunctionHandler {
  lift(obj: std.Resource, options: LiftOptions): cloud.IFunctionHandler;
}

pub interface IBucketEventInflight extends cloud.IBucketEventHandler {
  lift(obj: std.Resource, options: LiftOptions): cloud.IBucketEventHandler;
}

pub interface IApiOnRequest extends cloud.IApiEndpointHandler {
  lift(obj: std.Resource, options: LiftOptions): cloud.IApiEndpointHandler;
}

pub struct LiftedSim {
  id: str;
  path: str;
  type: str;
  target: str;
  handle: str;
  props: Json?;
  children: Map<LiftedSim>?;
}
