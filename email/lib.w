bring util;
bring "./sim.w" as email_sim;
bring "./tfaws.w" as email_tfaws;
bring "./types.w" as types;

pub class Email {
  inner: types.IEmail;
  new(props: types.EmailProps) {
    let target = util.env("WING_TARGET");

    if target == "sim" {
      let email = new email_sim.Email_sim(props);
      email.addUI(this);
      this.inner = email;
    } else {
      this.inner = new email_tfaws.Email_tfaws(props);
    }

    nodeof(this.inner).hidden = true;
    nodeof(this).icon = "inbox";
    nodeof(this).color = "pink";
  }

  pub inflight send(options: types.SendEmailOptions): void {
    this.inner.send(options);
  }
}
