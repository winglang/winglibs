const {
  ApiGatewayManagementApiClient,
  PostToConnectionCommand
} = require("@aws-sdk/client-apigatewaymanagementapi");

exports._postToConnection = async function (callbackUrl, connectionId, message) {
  const client = new ApiGatewayManagementApiClient({
    endpoint: callbackUrl,
  });

  const command = new PostToConnectionCommand({
    ConnectionId: connectionId,
    Data: Buffer.from(message),
  });

  await client.send(command);
}
