pub class Util {
  pub static extern "./utils.js" dirname(): str;
  pub static entrypointDir(scope: std.IResource): str {
    return std.Node.of(scope).app.entrypointDir;
  }
}