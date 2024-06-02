export default interface extern {
  _sendEmail: (options: SendEmailOptions) => Promise<string | void>,
  _sendRawEmail: (options: SendRawEmailOptions) => Promise<string | void>,
}
export interface Destination {
  readonly BccAddresses?: ((readonly (string)[])) | undefined;
  readonly CcAddresses?: ((readonly (string)[])) | undefined;
  readonly ToAddresses?: ((readonly (string)[])) | undefined;
}
export interface Content {
  readonly Data?: (string) | undefined;
}
export interface Body {
  readonly Html?: (Content) | undefined;
  readonly Text?: (Content) | undefined;
}
export interface Message {
  readonly Body?: (Body) | undefined;
  readonly Subject?: (Content) | undefined;
}
export interface SendEmailOptions {
  readonly Destination?: (Destination) | undefined;
  readonly Message?: (Message) | undefined;
  readonly Source: string;
}
export interface RawMessage {
  readonly Data: string;
}
export interface SendRawEmailOptions {
  readonly Destinations?: ((readonly (string)[])) | undefined;
  readonly RawMessage: RawMessage;
  readonly Source?: (string) | undefined;
}