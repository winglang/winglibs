export default interface extern {
  createGithubAppJwt: (appId: string, privateKey: string) => Promise<string>,
  createProbotAdapter: (options: CreateAdapterOptions) => Promise<ProbotInstance>,
}
export interface CreateAdapterOptions {
  readonly appId: string;
  readonly privateKey: string;
  readonly webhookSecret: string;
}
export interface IProbotAuth {
}
export interface IProbotWebhooks {
}
export interface ProbotInstance {
  readonly auth: IProbotAuth;
  readonly webhooks: IProbotWebhooks;
}