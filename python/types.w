bring cloud;

pub struct BuildOptions {
  entrypointDir: str;
  workDir: str;
  path: str;
  homeEnv: str;
  pathEnv: str;
}

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
