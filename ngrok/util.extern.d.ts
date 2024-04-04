export default interface extern {
  dirname: () => string,
  spawn: (cmd: string, args: (readonly ((string) | undefined)[]), opts?: (Readonly<any>) | undefined) => Promise<ChildProcess$Inflight>,
}
export interface ChildProcess$Inflight {
  readonly kill: () => Promise<void>;
  readonly url: () => Promise<string>;
}