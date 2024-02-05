pub struct invocationOptions {
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

pub struct invocationOutput {
  Body: str;
  ContentType: str?;
  InvokedProductionVariant: str?;
  CustomAttributes: str?;
}

pub interface ISageMaker {
  inflight invoke(body: Json, invocationOptions: invocationOptions?): invocationOutput;  
}