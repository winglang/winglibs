export default interface extern {
  _publish: (options: PublishOptions) => Promise<PublishResult>,
}
export interface MessageAttributeValue {
  readonly DataType?: (string) | undefined;
  readonly StringValue?: (string) | undefined;
}
export interface PublishOptions {
  readonly Message?: (string) | undefined;
  readonly MessageAttributes?: (Readonly<Record<string, MessageAttributeValue>>) | undefined;
  readonly PhoneNumber?: (string) | undefined;
  readonly Subject?: (string) | undefined;
  readonly TopicArn?: (string) | undefined;
}
export interface PublishResult {
  readonly MessageId?: (string) | undefined;
  readonly SequenceNumber?: (string) | undefined;
}