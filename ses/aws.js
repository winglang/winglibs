import { SESClient, SendEmailCommand, SendRawEmailCommand } from '@aws-sdk/client-ses';

export const _sendEmail = async (options) => {
  const ses = new SESClient();
  let res = await ses.send(new SendEmailCommand(options));
  return res.MessageId;
};

export const _sendRawEmail = async (options) => {
  const ses = new SESClient();
  options.RawMessage.Data = Buffer.from(options.RawMessage.Data);
  let res = await ses.send(new SendRawEmailCommand(options));
  return res.MessageId;
};
