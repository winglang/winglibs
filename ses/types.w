pub struct EmailServiceProps {
  emailIdentities: Array<str>?;
}

pub struct Destination {
  ToAddresses: Array<str>?;
  CcAddresses: Array<str>?;
  BccAddresses: Array<str>?;
}

pub struct Content {
  Data: str?;
}

pub struct Body {
  Text: Content?;
  Html: Content?;
}

pub struct Message {
  Subject: Content?;
  Body: Body?;
}

pub struct SendEmailOptions {
  Source: str;
  Destination: Destination?;
  Message: Message?;
}

pub struct RawMessage {
  Data: str;
}

pub struct SendRawEmailOptions {
  Source: str?;
  Destinations: Array<str>?;
  RawMessage: RawMessage;
}

pub interface IEmailService {
  inflight sendEmail(options: SendEmailOptions): str?;
  inflight sendRawEmail(options: SendRawEmailOptions): str?;
}
