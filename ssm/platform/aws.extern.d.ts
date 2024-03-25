export default interface extern {
  fetchParameter: (key: string) => Promise<AwsParameter>,
}
export interface AwsParameter {
  readonly Name: string;
  readonly Value: string;
}