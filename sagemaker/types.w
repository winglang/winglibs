pub struct InvocationOptions {
  ContentType: str?;
  Accept: str?;
  CustomAttributes: str?;
  TargetModel: str?;
  TargetVariant: str?;
  TargetContainerHostname: str?;
  InferenceId: str?;
  EnableExplanations: str?;
  InferenceComponentName: str?;
}

pub struct InvocationOutput {
  Body: str;
  ContentType: str?;
  InvokedProductionVariant: str?;
  CustomAttributes: str?;
}

pub interface ISageMaker {
  inflight invoke(body: Json, InvocationOptions: InvocationOptions?): InvocationOutput;  
}