bring ui;
bring util;

pub class Util {
  pub static addMacro(target: std.IResource, name: str, fn: inflight ():void ){
    if util.env("WING_TARGET") == "sim" {
      nodeof(target).title = "Macros";
      new ui.Button(name, fn) as name in target;
    }
  }
}
