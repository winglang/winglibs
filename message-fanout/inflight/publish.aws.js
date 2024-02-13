import {
  SNSClient,
  PublishCommand
} from "@aws-sdk/client-sns";

export const _publish = async function (topicArn, message) {
  const client = new SNSClient({});

  const command = new PublishCommand({
    TopicArn: topicArn,
    Message: message
  });

  await client.send(command);
}
