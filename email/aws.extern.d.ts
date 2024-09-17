export default interface extern {
  _sendEmail: (sender: string, options: SendEmailOptions) => Promise<string | void>,
}
export interface SendEmailOptions {
  /** The body of the email, in HTML.
  @default - The text body will be used as the HTML body. */
  readonly html?: (string) | undefined;
  /** The subject of the email. */
  readonly subject: string;
  /** The body of the email, in plain text. */
  readonly text: string;
  /** The email addresses to send the email to. */
  readonly to: (readonly (string)[]);
}