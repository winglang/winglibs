export default interface extern {
  _startWebSocketApi: (connectFn: (arg0: string) => Promise<void>, disconnectFn: (arg0: string) => Promise<void>, onmessageFn: (arg0: string, arg1: string) => Promise<void>) => Promise<StartWebSocketApiResult$Inflight>,
}
export interface StartWebSocketApiResult$Inflight {
  readonly close: () => Promise<() => Promise<void>>;
  readonly local: () => Promise<string>;
  readonly url: () => Promise<string>;
}