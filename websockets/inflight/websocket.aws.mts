import {
  ApiGatewayManagementApiClient,
  PostToConnectionCommand
} from "@aws-sdk/client-apigatewaymanagementapi";

export const _postToConnection = async function (callbackUrl: string, connectionId: string, data: string) {
  const client = new ApiGatewayManagementApiClient({
    endpoint: callbackUrl,
  });

  const command = new PostToConnectionCommand({
    ConnectionId: connectionId,
    Data: Buffer.from(data),
  });

  await client.send(command);
}
