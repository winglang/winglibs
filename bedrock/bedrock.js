import { BedrockRuntimeClient, InvokeModelCommand } from "@aws-sdk/client-bedrock-runtime";

exports._invokeModel = async ({ modelId, body }) => {
  const client = new BedrockRuntimeClient();
  let command = new InvokeModelCommand({
    modelId,
    body: JSON.stringify(body),
    contentType: "application/json",
    accept: "application/json",
  });

  const response = await client.send(command);
  return JSON.parse(response.body.transformToString());
};
