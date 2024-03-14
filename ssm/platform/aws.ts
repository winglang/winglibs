import { SSMClient, GetParameterCommand, GetParameterResult } from "@aws-sdk/client-ssm";

export const fetchParameter = async (key: string): Promise<GetParameterResult["Parameter"]> => {
  const client = new SSMClient({});
  const command = new GetParameterCommand({ Name: key, WithDecryption: true });
  const response = await client.send(command);
  return response.Parameter;
}
