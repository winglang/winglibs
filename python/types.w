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
}

pub struct LiftOptions {
  allow: Array<str>;
}

pub interface IInflight extends cloud.IFunctionHandler {
  lift(id: str, client: std.Resource, options: LiftOptions): cloud.IFunctionHandler;
}
