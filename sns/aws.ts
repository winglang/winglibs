import { PublishCommand, SNSClient } from "@aws-sdk/client-sns";
import type extern from "./aws.extern";

export const _publish: extern["_publish"] = async ({
  Message,
  MessageAttributes,
  PhoneNumber,
  Subject,
  TopicArn,
}) => {
  const client = new SNSClient();
  const command = new PublishCommand({
    Message,
    MessageAttributes: MessageAttributes as any,
    PhoneNumber,
    Subject,
    TopicArn,
  });
  const { MessageId, SequenceNumber } = await client.send(command);
  return {
    MessageId,
    SequenceNumber,
  };
};
