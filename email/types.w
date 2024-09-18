pub interface IEmail {
  /// Sends a simple email.
  inflight send(options: SendEmailOptions): void;
}

pub struct EmailProps {
  /// The email address for the sender of all emails.
  sender: str;
}

pub struct SendEmailOptions {
  /// The email addresses to send the email to.
  to: Array<str>;
  /// The subject of the email.
  subject: str;
  /// The body of the email, in plain text.
  text: str;
  /// The body of the email, in HTML.
  /// @default - The text body will be used as the HTML body.
  html: str?;
}
