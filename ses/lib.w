bring util;
bring "./types.w" as types;
bring "./sim.w" as sim;
bring "./tfaws.w" as tfaws;

/// EmailService can used for defining and interacting with AWS SES.
/// When running the simulator in a non test environment, it will use the
/// actual cloud implementation.
pub class EmailService impl types.IEmailService {
  inner: types.IEmailService;
  new(props: types.EmailServiceProps) {
    let target = util.env("WING_TARGET");
    if target == "sim" {
      if std.Node.of(this).app.isTestEnvironment {
        this.inner = new sim.EmailService_sim(props);
      } else {
        this.inner = new tfaws.EmailService_tfaws(props);  
      }
    } elif target == "tf-aws" {
      this.inner = new tfaws.EmailService_tfaws(props);
    } else {
      throw "Unknown target: {target}";
    }

    nodeof(this.inner).hidden = true;
  }

  pub inflight sendEmail(options: types.SendEmailOptions): str? {
    return this.inner.sendEmail(options);
  }

  pub inflight sendRawEmail(options: types.SendRawEmailOptions): str? {
    return this.inner.sendRawEmail(options);
  }
}
