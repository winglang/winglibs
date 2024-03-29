import {InvokeEndpointCommand, SageMakerRuntimeClient} from "@aws-sdk/client-sagemaker-runtime";

exports._invoke = async (endpointName, body, inferenceComponentName, options = {}) => {
  const client = new SageMakerRuntimeClient();
  const command = new InvokeEndpointCommand({
    ...options,
    InferenceComponentName: inferenceComponentName,
    EndpointName: endpointName,
    Body: JSON.stringify(body),
  });
  let res = await client.send(command);
  
  return {
    ...res, 
    Body: Buffer.from(res.Body).toString('utf8')
  };
};
