export default interface extern {
  build: (options: Readonly<any>) => string,
  cliFilename: () => string,
  dev: (options: Readonly<any>) => Promise<DevOutput$Inflight>,
}
export interface DevOutput$Inflight {
  readonly kill: () => Promise<void>;
  readonly url: () => Promise<string>;
}