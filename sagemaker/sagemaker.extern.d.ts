export default interface extern {
  _invoke: (endpointName: string, body: Readonly<any>, inferenceComponentName: string, options?: (InvocationOptions) | undefined) => Promise<InvocationOutput>,
}
export interface InvocationOptions {
  readonly Accept?: (string) | undefined;
  readonly ContentType?: (string) | undefined;
  readonly CustomAttributes?: (string) | undefined;
  readonly EnableExplanations?: (string) | undefined;
  readonly InferenceComponentName?: (string) | undefined;
  readonly InferenceId?: (string) | undefined;
  readonly TargetContainerHostname?: (string) | undefined;
  readonly TargetModel?: (string) | undefined;
  readonly TargetVariant?: (string) | undefined;
}
export interface InvocationOutput {
  readonly Body: string;
  readonly ContentType?: (string) | undefined;
  readonly CustomAttributes?: (string) | undefined;
  readonly InvokedProductionVariant?: (string) | undefined;
}