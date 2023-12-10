import {
  SQSClient,
  SendMessageCommand,
} from "@aws-sdk/client-sqs";

export const _push = async (queueUrl: string, message: string, groupId: string) => {
  const client = new SQSClient();
  client.send(new SendMessageCommand({
    QueueUrl: queueUrl,
    MessageBody: message,
    MessageGroupId: groupId,
  }))
};
