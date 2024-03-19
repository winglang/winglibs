export default interface extern {
  createNewInflightClient: (apiKey: string, org?: (string) | undefined) => Promise<IOpenAI$Inflight>,
}
export interface CompletionParams {
  readonly max_tokens: number;
  readonly model: string;
}
export interface IOpenAI$Inflight {
  readonly createCompletion: (prompt: string, params?: (CompletionParams) | undefined) => Promise<string>;
}