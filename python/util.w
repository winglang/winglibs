bring "./types.w" as types;

pub class Util {
  extern "./util.js" pub static dirname(): str;
  extern "./util.js" pub static build(options: types.BuildOptions): str;
  extern "./util.js" pub static liftTfAws(id: str, client: std.Resource): str;
  extern "./util.js" pub static liftSim(id: str, client: std.Resource): types.LiftedSim;
  extern "./util.js" pub static inflight liftSimInflight(client: std.Resource, lifted: types.LiftedSim): types.LiftedSimResolved?;
}