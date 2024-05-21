bring "./types.w" as types;

pub class Util {
  extern "./util.js" pub static dirname(): str;
  extern "./util.js" pub static build(options: types.BuildOptions): str;
  extern "./util.js" pub static liftTfAws(id: str, client: std.Resource): str;
  extern "./util.js" pub static liftSim(
    obj: std.Resource,
    options: types.LiftOptions,
    host: std.IInflightHost,
    clients: MutMap<types.LiftedSim>,
  ): void;
}