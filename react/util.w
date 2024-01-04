
pub struct ShellOpts {
  cwd: str?;
  maxBuffer: num?;
}

pub interface IChildProcess {
  inflight kill(signal: str): void;
}

pub class Util {
  extern "./util.js"
  pub static shell(command: str, opts: ShellOpts): void;

  extern "./util.js"
  pub static inflight spawn(command: str, opts: ShellOpts): IChildProcess;
}