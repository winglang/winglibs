bring util;
bring "./types.w" as types;
bring "./sim.w" as sim;
bring "./tfaws.w" as tfaws;

pub class EmailService impl types.IEmailService {
  inner: types.IEmailService;
  new(props: types.EmailServiceProps) {
    let target = util.env("WING_TARGET");
    if target == "sim" {
      this.inner = new sim.EmailService_sim(props);
    } elif target == "tf-aws" {
      this.inner = new tfaws.EmailService_tfaws(props);
    } else {
      throw "Unknown target: {target}";
    }
  }

  pub inflight sendEmail(options: types.SendEmailOptions): str? {
    return this.inner.sendEmail(options);
  }

  pub inflight sendRawEmail(options: types.SendRawEmailOptions): str? {
    return this.inner.sendRawEmail(options);
  }
}
