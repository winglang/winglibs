export default interface extern {
  createNewInflightClient: (apiKey: string, org?: (string) | undefined) => Promise<IClient$Inflight>,
}
export interface IClient$Inflight {
  readonly createCompletion: (params: Readonly<any>) => Promise<Readonly<any>>;
}