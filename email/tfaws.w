bring aws;
bring "./types.w" as types;
bring "@cdktf/provider-aws" as tfaws;

internal class Email_tfaws impl types.IEmail {
  sender: str;
  identity: tfaws.sesv2EmailIdentity.Sesv2EmailIdentity;

  new(props: types.EmailProps) {
    this.sender = props.sender;

    this.identity = new tfaws.sesv2EmailIdentity.Sesv2EmailIdentity(
      emailIdentity: this.sender
    ) as "EmailIdentity-{this.sender.replaceAll("@", "_")}";
  }

  pub inflight send(options: types.SendEmailOptions): str? {
    Email_tfaws._sendEmail(this.sender, options);
  }

  pub onLift(host: std.IInflightHost, ops: Array<str>) {
    if let func = aws.Function.from(host) {
      func.addPolicyStatements({
        effect: aws.Effect.ALLOW,
        actions: ["ses:SendEmail"],
        resources: [this.identity.arn]
      });
    }
  }

  extern "./aws.ts" static inflight _sendEmail(sender: str, options: types.SendEmailOptions): str?;
}
