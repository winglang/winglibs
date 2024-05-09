bring "@cdktf/provider-aws" as aws;
bring "./types.w" as types;
bring aws as awsUtils;

pub class EmailService_tfaws impl types.IEmailService {
  new(props: types.EmailServiceProps) {
    if let emailIdentities = props.emailIdentities {
      for email in emailIdentities {
        new aws.sesEmailIdentity.SesEmailIdentity(
          email: email
        ) as "emailIdentity-{email.replaceAll("@", "_")}";
      }
    }
  }

  pub inflight sendEmail(options: types.SendEmailOptions): str? {
    return EmailService_tfaws._sendEmail(options);
  }

  pub inflight sendRawEmail(options: types.SendRawEmailOptions): str? {
    return EmailService_tfaws._sendRawEmail(options);
  }

  pub onLift(host: std.IInflightHost, ops: Array<str>) {
    if let awsFunc = awsUtils.Function.from(host) {
      if ops.contains("sendEmail") {
        awsFunc.addPolicyStatements({
          effect: awsUtils.Effect.ALLOW,
          actions: ["ses:SendEmail"],
          resources: [
            "*"
          ]
        });
      } elif ops.contains("sendRawEmail") {
        awsFunc.addPolicyStatements({
          effect: awsUtils.Effect.ALLOW,
          actions: ["ses:SendRawEmail"],
          resources: [
            "*"
          ]
        });
      }
    }
  }

  extern "./aws.js" static inflight _sendEmail(options: types.SendEmailOptions): str?;
  extern "./aws.js" static inflight _sendRawEmail(options: types.SendRawEmailOptions): str?;
}
