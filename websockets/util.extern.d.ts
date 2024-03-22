export default interface extern {
  _buffer_to_string: (data: string) => Promise<string>,
  _ws: (url: string) => Promise<IWebSocketJS$Inflight>,
}
export interface IWebSocketJS$Inflight {
  readonly close: () => Promise<void>;
  readonly on: (cmd: string, handler: (arg0: string) => Promise<void>) => Promise<void>;
  readonly send: (e: string) => Promise<void>;
}