import types from "./aws.extern";
import { SESv2Client, SendEmailCommand } from "@aws-sdk/client-sesv2";

export const _sendEmail: types["_sendEmail"] = async (sender, options) => {
  const ses = new SESv2Client();
  let res = await ses.send(new SendEmailCommand({
    Content: {
      Simple: {
        Body: {
          Text: {
            Data: options.text,
            Charset: "UTF-8",
          },
          Html: {
            Data: options.html,
            Charset: "UTF-8",
          }
        },
        Subject: {
          Data: options.subject,
          Charset: "UTF-8",
        }
      }
    },
    Destination: {
      ToAddresses: options.to as string[], // cast from readonly string[] to string[]
    },
    FromEmailAddress: sender,
  }));
  return res.MessageId;
};
