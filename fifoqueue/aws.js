const {
  SQSClient,
  SendMessageCommand,
} = require("@aws-sdk/client-sqs");

exports._push = async (queueUrl, message, groupId) => {
  const client = new SQSClient();
  return client.send(new SendMessageCommand({
    QueueUrl: queueUrl,
    MessageBody: message,
    MessageGroupId: groupId,
  }))
};
