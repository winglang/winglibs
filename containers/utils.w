bring "./api.w" as api;
bring fs;

interface Process {
  inflight kill(): void;
}

struct SpawnOptions {
  command: str;
  arguments: Array<str>;
  stdio: str?;
}

pub class Util {
  extern "./utils.js" pub static inflight spawn(options: SpawnOptions): Process;
  extern "./utils.js" pub static inflight shell(command: str, args: Array<str>, cwd: str?): str;
  extern "./utils.js" pub static contentHash(files: Array<str>, cwd: str): str;
  extern "./utils.js" pub static dirname(): str;

  pub static entrypointDir(scope: std.IResource): str {
    return std.Node.of(scope).app.entrypointDir;
  }

  pub static isPath(s: str): bool {
    return s.startsWith("/") || s.startsWith("./");
  }

  pub static inflight isPathInflight(s: str): bool {
    return s.startsWith("/") || s.startsWith("./");
  }

  pub static resolveContentHash(scope: std.IResource, props: api.WorkloadProps): str? {
    if !Util.isPath(props.image) {
      return nil;
    }

    let sources = props.sources ?? ["**/*"];
    let imageDir = props.image;
    return props.sourceHash ?? Util.contentHash(sources, imageDir);
  }
}
