pub struct MessageAttributeValue {
    DataType: str?;
    StringValue: str?;
}

pub struct PublishOptions {
  TopicArn: str?;
  Message: str?;
  PhoneNumber: str?;
  Subject: str?;
  MessageAttributes: Map<MessageAttributeValue>?;
}

pub struct PublishResult {
  MessageId: str?;
  SequenceNumber: str?;
}

pub interface IMobileNotifications extends std.IResource {
  inflight publish(options: PublishOptions): PublishResult;
}
