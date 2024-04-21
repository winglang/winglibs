pub class Utils {
  pub static extern "./utils.js" inflight exec(command: str, env: MutMap<str>, cwd: str): inflight(): void;
  pub static extern "./utils.js" inflight serveStaticFiles(path: str, port: num): inflight (): void;
  pub static extern "./utils.js" execSync(command: str, env: MutMap<str>, cwd: str): void;
}
