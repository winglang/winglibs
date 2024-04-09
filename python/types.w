pub struct BuildOptions {
  entrypointDir: str;
  workDir: str;
  path: str;
  homeEnv: str;
  pathEnv: str;
}

pub struct FunctionProps {
  path: str;
  handler: str;
}

pub interface IFunction {
  liftClient(id: str, client: std.Resource, ops: Array<str>): void;
  inflight invoke(payload: str?): str?;
}
